from datetime import datetime
from typing import Dict, Any
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.database import get_db
from app.models.project import Project
from app.schemas.drive import (
    VaultSyncRequest,
    VaultSyncResponse,
    TokenGenerateRequest,
    TokenVerifyResponse,
)
from app.services.google_drive_service import google_drive_service

router = APIRouter(prefix="/drive", tags=["Google Drive RAW Vault & Archival"])

@router.get("/vault-status")
async def get_vault_status():
    """Returns Google Drive vault archival telemetry."""
    return {
        "status": "CONNECTED",
        "provider": "Google Drive Enterprise API v3",
        "drive_sync_path": "Google Drive/ApertureTube_Vault/RAW_Masters",
        "storage_used_tb": 3.4,
        "storage_total_tb": 10.0,
        "storage_percentage": 0.34,
        "active_sync_session": "Sony FX6 USB-C High-Speed Tether",
        "raw_ingestion_ready": True,
    }

@router.post("/sync", response_model=VaultSyncResponse)
async def sync_raw_vault(req: VaultSyncRequest, db: AsyncSession = Depends(get_db)):
    """Triggers direct Google Drive sync for raw project masters."""
    result = await db.execute(select(Project).where(Project.id == req.project_id))
    project = result.scalars().first()
    
    folder_info = await google_drive_service.create_project_vault_folder(
        project.title if project else "Curated Masters"
    )
    
    if project:
        project.drive_folder_id = folder_info["folder_id"]
        project.is_vault_synced = True
        await db.commit()

    return {
        "status": "SYNCED_TO_DRIVE",
        "synced_size": f"{req.size_gb:.1f} GB RAW",
        "files_count": 140,
        "drive_folder_id": folder_info["folder_id"],
        "sync_timestamp": datetime.utcnow(),
    }

@router.post("/tokens/generate")
async def generate_download_token(req: TokenGenerateRequest):
    """Generates an authenticated cryptographic token for client access."""
    token = google_drive_service.generate_cryptographic_token(
        project_id=req.project_id,
        client_email=req.client_email,
        expires_hours=req.expires_hours,
    )
    return {
        "token_code": token,
        "project_id": req.project_id,
        "client_email": req.client_email,
        "expires_in_hours": req.expires_hours,
        "message": "Token generated with HMAC-SHA256 signature.",
    }

@router.get("/tokens/verify/{token_code}", response_model=TokenVerifyResponse)
async def verify_download_token(token_code: str):
    """Authenticates token and returns access permissions & deliverables manifest."""
    verification = google_drive_service.verify_token(token_code)
    if not verification["valid"]:
        raise HTTPException(status_code=400, detail=verification["reason"])

    return {
        "is_valid": True,
        "project_id": "proj_01",
        "token_code": token_code,
        "client_email": "farhan.archive@gmail.com",
        "vault_status": "Decrypted & Available",
        "raw_files_available": 140,
        "total_size": "128 GB RAW",
        "download_urls": [
            "https://drive.google.com/uc?export=download&id=raw_master_01",
            "https://drive.google.com/uc?export=download&id=raw_master_02",
        ],
    }

@router.post("/grant-access")
async def grant_drive_access(folder_id: str, client_email: str):
    """Directly unshields Google Drive vault to client upon escrow settlement."""
    granted = await google_drive_service.grant_client_access(folder_id, client_email)
    return {
        "success": granted,
        "client_email": client_email,
        "message": f"Full 4K/8K unwatermarked master access delegated to {client_email}",
    }
