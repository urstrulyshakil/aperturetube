import os
from typing import Optional
from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    APP_NAME: str = "ApertureTube API"
    APP_VERSION: str = "1.0.0"
    DEBUG: bool = True
    API_V1_PREFIX: str = "/api/v1"
    
    # ── Database (100% Free SQLite default) ──────────────────────────────────
    DATABASE_URL: str = "sqlite+aiosqlite:///./data/aperturetube.db"
    
    # ── Security & Authentication ────────────────────────────────────────────
    SECRET_KEY: str = "aperturetube_jwt_secret_key_change_in_production_2026"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 7  # 7 days
    
    # ── Google Drive Vault API Configuration ─────────────────────────────────
    GOOGLE_DRIVE_ENABLED: bool = True
    GOOGLE_DRIVE_CLIENT_ID: Optional[str] = None
    GOOGLE_DRIVE_CLIENT_SECRET: Optional[str] = None
    GOOGLE_DRIVE_REFRESH_TOKEN: Optional[str] = None
    GOOGLE_DRIVE_ROOT_FOLDER_ID: Optional[str] = "aperturetube_vault_root"
    
    # ── bKash Direct Merchant PGW Configuration ──────────────────────────────
    BKASH_ENABLED: bool = True
    BKASH_BASE_URL: str = "https://tokenized.sandbox.bka.sh/v1.2.0-beta"
    BKASH_APP_KEY: str = "sandbox_bkash_app_key"
    BKASH_APP_SECRET: str = "sandbox_bkash_app_secret"
    BKASH_USERNAME: str = "sandbox_bkash_user"
    BKASH_PASSWORD: str = "sandbox_bkash_password"
    
    # ── Stripe Payment Gateway Configuration ─────────────────────────────────
    STRIPE_ENABLED: bool = True
    STRIPE_SECRET_KEY: str = "sk_test_mock_stripe_secret_key_aperturetube"
    STRIPE_WEBHOOK_SECRET: Optional[str] = "whsec_mock_stripe_webhook_secret"
    
    # ── Google Pay Gateway Configuration ─────────────────────────────────────
    GOOGLE_PAY_MERCHANT_ID: str = "12345678901234567890"
    GOOGLE_PAY_MERCHANT_NAME: str = "ApertureTube Studio Vault"
    
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

settings = Settings()
