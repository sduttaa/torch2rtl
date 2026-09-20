"""Generic constant-storage candidates, independent of a model or FPGA.

These count explicitly described encoded payloads; there is no RTL decoder yet.
They omit banking, decoder state, alignment and the encoding-selector overhead.
Failure even with those optimistic omissions rules out this candidate catalogue,
not every possible logic factorization or lossless representation.
"""

from collections import Counter
from heapq import heapify, heappop, heappush

from .schedule import Option, Problem


def integer_encodings(values, bits):
    values = list(values)
    if not values or bits < 1:
        raise ValueError("A nonempty integer sequence and positive element width are required")
    counts = Counter(values)
    low, high = min(counts), max(counts)
    if high - low >= 1 << bits:
        raise ValueError("Values do not fit the declared element width")
    count = len(values)
    alphabet = len(counts)
    raw = count * bits
    # The base value and field width are stored with each range-packed payload.
    range_width = (high - low).bit_length()
    range_packed = bits + (bits + 1).bit_length() + count * range_width
    # Palette length, palette symbols, and fixed-width indices.
    palette = (alphabet + 1).bit_length() + alphabet * bits + count * (alphabet - 1).bit_length()
    # A bit per position followed by the nonzero values in their original width.
    sparse = count + (count - counts.get(0, 0)) * bits
    # Canonical Huffman: explicit alphabet values and code lengths, plus stream.
    # A tree with K leaves has maximum code length K-1.
    heap = list(counts.values())
    heapify(heap)
    huffman_stream = 0
    while len(heap) > 1:
        merged = heappop(heap) + heappop(heap)
        huffman_stream += merged
        heappush(heap, merged)
    huffman = (alphabet + 1).bit_length() + alphabet * (bits + (alphabet - 1).bit_length()) + huffman_stream
    return {name: (size + 7) // 8 for name, size in {
        "raw": raw, "range_packed": range_packed, "palette": palette,
        "zero_bitmap": sparse, "canonical_huffman": huffman,
    }.items()}


def constant_storage(tensors, target=None):
    entries = []
    for name, tensor in tensors.items():
        costs = {"raw": tensor.numel() * tensor.element_size()}
        if str(tensor.dtype).removeprefix("torch.").startswith(("int", "uint")) and tensor.numel():
            costs = integer_encodings(tensor.detach().cpu().flatten().tolist(), tensor.element_size() * 8)
        encoding = min(costs, key=costs.get)
        entries.append({"name": name, "candidate_bytes": costs,
                        "smallest_encoding": encoding, "smallest_bytes": costs[encoding]})
    raw = sum(item["candidate_bytes"]["raw"] for item in entries)
    best = sum(item["smallest_bytes"] for item in entries)
    budget = None
    generous = None
    if target is not None:
        budget = sum(target["fabric_memory_bits"].values()) // 8
        if "logic_lut_inputs" in target:
            # Favor the candidate by counting every LUT table and every FF as
            # storage, leaving no arithmetic/routing resources. Some resources
            # overlap physically; this is deliberately an optimistic allowance.
            generous = (sum(target["fabric_memory_bits"].values())
                        + target["resources"]["lut"] * (1 << target["logic_lut_inputs"])
                        + target["resources"]["ff"]) // 8
    return {"constants": entries, "raw_bytes": raw, "smallest_catalogue_bytes": best,
            "fabric_ram_bytes": budget, "optimistic_all_storage_bytes": generous,
            "catalogue_fits_fabric_ram": best <= budget if budget is not None else None,
            "catalogue_fits_optimistic_all_storage": best <= generous if generous is not None else None,
            "scope": "Payload accounting for this catalogue only; no physical decoder or universal lower bound."}


def storage_problem(report, budget):
    """Necessary storage-only relaxation, with one lossless option per constant.

    Timing is unconstrained here. An INFEASIBLE result excludes this encoding
    catalogue even before other memories, arithmetic and ports are allocated.
    An OPTIMAL result says only that encoded payloads fit this byte allowance.
    """
    choices = {
        item["name"]: tuple(Option(name, {"payload_bytes": count})
                             for name, count in item["candidate_bytes"].items())
        for item in report["constants"]
    }
    return Problem(("start",), choices, (), (), {"payload_bytes": budget},
                   1, 0, "start", resource_weights={"payload_bytes": 1})
