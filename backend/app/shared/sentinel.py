"""A typed sentinel for distinguishing "value omitted" from "value is None".

PATCH-style updates need three states per field: set to a value, explicitly
clear to NULL, or leave unchanged. ``None`` alone cannot express all three, so
callers pass :data:`UNSET` to mean "leave unchanged" while ``None`` means
"clear". Implemented as a single-member enum so ``is``-narrowing works under
mypy (``x is not UNSET`` narrows ``T | None | UnsetType`` to ``T | None``).
"""

import enum
from typing import Final


class _Unset(enum.Enum):
    UNSET = enum.auto()


UNSET: Final = _Unset.UNSET
UnsetType = _Unset
