import math

import pytest

from torch2rtl.reporting import frequency_miss_only, reported_fps, timing_checks_passed


FREQUENCY_ERROR="ERROR: Max frequency for clock 'core': 99.21 MHz (FAIL at 108.00 MHz)\n"


def test_only_frequency_shortfalls_are_recoverable():
    assert frequency_miss_only(1,FREQUENCY_ERROR)
    for status,log in ((-9,FREQUENCY_ERROR),(1,"ERROR: Unroutable net\n"),
                       (1,FREQUENCY_ERROR+"ERROR: Hold/min time violation for clock 'core':\n"),
                       (1,""),(0,FREQUENCY_ERROR)):
        assert not frequency_miss_only(status,log)


def test_frequency_and_throughput_report_actual_limit():
    assert not timing_checks_passed({'core':{'achieved':99.20635223388672,'constraint':108.003}})
    assert reported_fps(108_000_000,3_085_714,99.20635223388672)==pytest.approx(32.15020971933456)
    assert reported_fps(108_000_000,3_085_714,110.51)==pytest.approx(35.00000324074104)
    assert timing_checks_passed({'core':{'achieved':110.51,'constraint':108.003}})
    assert not timing_checks_passed({'core':{'achieved':108,'constraint':108}})
    assert not timing_checks_passed({'core':{'achieved':110,'constraint':108},
                                     'other':{'achieved':20,'constraint':27}})


@pytest.mark.parametrize('report',[{},None,{'core':{}},
    {'core':{'achieved':math.nan,'constraint':108}},
    {'core':{'achieved':99,'constraint':0}},
    {'core':{'achieved':math.inf,'constraint':108}}])
def test_missing_or_invalid_timing_is_not_a_performance_warning(report):
    with pytest.raises(ValueError):
        timing_checks_passed(report)
