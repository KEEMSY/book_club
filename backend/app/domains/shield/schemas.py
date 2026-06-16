"""Pydantic schemas for the shield purchase domain."""

from __future__ import annotations

from pydantic import BaseModel, field_validator

SHIELD_PRODUCTS: dict[str, dict[str, int]] = {
    "shield_1": {"shields": 1, "price_krw": 990},
    "shield_3": {"shields": 3, "price_krw": 2490},
}


class PurchaseShieldRequest(BaseModel):
    product_id: str
    receipt_data: str

    @field_validator("product_id")
    @classmethod
    def _validate_product_id(cls, v: str) -> str:
        if v not in SHIELD_PRODUCTS:
            raise ValueError(f"알 수 없는 상품입니다: {v}")
        return v


class ShieldPurchaseResult(BaseModel):
    shields_granted: int
    total_shields: int  # balance after purchase


class ShieldBalanceResponse(BaseModel):
    streak_shields: int
