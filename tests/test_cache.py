from concurrent.futures import ProcessPoolExecutor
import multiprocessing
from pathlib import Path

import pytest

from torch2rtl.cache import entry, write_json


def produce_shared(directory):
    directory=Path(directory)
    def produce():
        with (directory/"calls").open("a") as stream:
            stream.write("synthesis\n")
        return {"resources":{"lut":7},"evidence":"test producer"}
    return entry(directory,{"rtl":"same"},produce)


def test_processes_publish_one_complete_entry(tmp_path):
    with ProcessPoolExecutor(4,mp_context=multiprocessing.get_context("spawn")) as pool:
        records=list(pool.map(produce_shared,[str(tmp_path)]*8))
    assert (tmp_path/"calls").read_text()=="synthesis\n"
    assert sum(not record["cache_hit"] for record in records)==1
    assert all(record["resources"]=={"lut":7} for record in records)
    assert not list(tmp_path.glob(".pending-*"))


@pytest.mark.parametrize("contents",["{", "null", "[]", '{"identity":{},"resources":null}'])
def test_incomplete_cache_can_be_recovered(tmp_path,contents):
    (tmp_path/"report.json").write_text(contents)
    assert entry(tmp_path,{},None,cached_only=True) is None
    record=entry(tmp_path,{},lambda:{"resources":{}})
    assert not record["cache_hit"]


def test_interruption_and_read_only_miss(tmp_path):
    directory=tmp_path/"missing"
    assert entry(directory,{},None,cached_only=True) is None
    assert not directory.exists()
    def failure():
        raise RuntimeError("interrupted")
    with pytest.raises(RuntimeError):
        entry(directory,{},failure)
    assert not (directory/"report.json").exists()
    assert not entry(directory,{},lambda:{"resources":{}})["cache_hit"]


def test_failed_serialization_does_not_replace_published_report(tmp_path):
    report=tmp_path/"report.json"
    write_json(report,{"complete":True})
    with pytest.raises(TypeError):
        write_json(report,{"unserializable":object()})
    assert report.read_text()=='{\n  "complete": true\n}\n'
    assert not list(tmp_path.glob(".pending-*"))
