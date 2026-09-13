from typing import Optional
from pydantic import BaseModel, EmailStr, ConfigDict

class Token(BaseModel):
    access_token: str
    token_type: str
    user: dict

class LoginRequest(BaseModel):
    email: EmailStr
    password: str

class PasscodeLoginRequest(BaseModel):
    token: str

class UserResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    email: str
    full_name: str
    role: str
    avatar_url: Optional[str]
    role_title: str
    rating: float
    reviews_count: int
    drive_sync_path: str
    storage_used_tb: float
    storage_total_tb: float
    auto_sync_raw: bool
    payout_gateway: str
    default_currency: str
    lut_mode: str


class StudioPreferencesUpdate(BaseModel):
    lut_mode: Optional[str] = None
    auto_sync_raw: Optional[bool] = None
    payout_gateway: Optional[str] = None
    default_currency: Optional[str] = None
