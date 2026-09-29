"""Process-safe immutable characterization entries with atomic publication."""

from contextlib import contextmanager
import fcntl
import json
import os
from pathlib import Path
import tempfile


def write_json(path, value):
    path=Path(path)
    path.parent.mkdir(parents=True,exist_ok=True)
    temporary=None
    try:
        with tempfile.NamedTemporaryFile(mode="w",dir=path.parent,prefix=".pending-",delete=False) as stream:
            temporary=Path(stream.name)
            json.dump(value,stream,indent=2)
            stream.write("\n")
            stream.flush()
            os.fsync(stream.fileno())
        os.replace(temporary,path)
    finally:
        if temporary is not None:
            temporary.unlink(missing_ok=True)


@contextmanager
def locked(directory):
    directory=Path(directory)
    directory.mkdir(parents=True,exist_ok=True)
    with (directory/".lock").open("a") as stream:
        fcntl.flock(stream,fcntl.LOCK_EX)
        try:
            yield
        finally:
            fcntl.flock(stream,fcntl.LOCK_UN)


def entry(directory, identity, produce, cached_only=False):
    directory=Path(directory)
    report=directory/"report.json"
    def existing():
        try:
            record=json.loads(report.read_text())
        except (FileNotFoundError,json.JSONDecodeError):
            return None
        if isinstance(record,dict) and record.get("identity")==identity and isinstance(record.get("resources"),dict):
            return {**record,"cache_hit":True,"cache_path":str(directory)}
    record=existing()
    if record is not None or cached_only:
        return record
    with locked(directory):
        record=existing()
        if record is not None:
            return record
        # An interrupted producer never publishes a usable report.
        record={"identity":identity,**produce()}
        write_json(report,record)
        return {**record,"cache_hit":False,"cache_path":str(directory)}
