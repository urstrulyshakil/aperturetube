from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.database import get_db
from app.models.user import User
from app.schemas.auth import (
    LoginRequest,
    PasscodeLoginRequest,
    Token,
    UserResponse,
    StudioPreferencesUpdate,
)
from app.services.auth_service import verify_password, create_access_token

router = APIRouter(prefix="/auth", tags=["Authentication & Studio Pro"])

@router.post("/login", response_model=Token)
async def login(req: LoginRequest, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(User).where(User.email == req.email))
    user = result.scalars().first()
    
    if not user or not verify_password(req.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or master access secret",
        )
        
    access_token = create_access_token(data={"sub": user.id, "role": user.role, "email": user.email})
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": {
            "id": user.id,
            "email": user.email,
            "full_name": user.full_name,
            "role": user.role,
            "role_title": user.role_title,
            "avatar_url": user.avatar_url,
            "lut_mode": user.lut_mode,
        },
    }

@router.post("/token-access", response_model=Token)
async def passcode_login(req: PasscodeLoginRequest, db: AsyncSession = Depends(get_db)):
    # Accepts client gallery tokens like MONACO-2024-VIP or AT-891-XK94
    token_clean = req.token.strip().upper()
    if not token_clean:
        raise HTTPException(status_code=400, detail="Token cannot be empty")
        
    client_id = f"client_{token_clean.lower()}"
    access_token = create_access_token(data={"sub": client_id, "role": "client", "token": token_clean})
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": {
            "id": client_id,
            "email": "client.archive@aperturetube.vault",
            "full_name": f"Event VIP Client ({token_clean})",
            "role": "client",
            "token": token_clean,
        },
    }

@router.get("/me", response_model=UserResponse)
async def get_current_user(db: AsyncSession = Depends(get_db)):
    # Default photographer user for studio pro workspace
    result = await db.execute(select(User).limit(1))
    user = result.scalars().first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@router.patch("/preferences", response_model=UserResponse)
async def update_preferences(req: StudioPreferencesUpdate, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(User).limit(1))
    user = result.scalars().first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
        
    if req.lut_mode is not None:
        user.lut_mode = req.lut_mode
    if req.auto_sync_raw is not None:
        user.auto_sync_raw = req.auto_sync_raw
    if req.payout_gateway is not None:
        user.payout_gateway = req.payout_gateway
    if req.default_currency is not None:
        user.default_currency = req.default_currency
        
    await db.commit()
    await db.refresh(user)
    return user
