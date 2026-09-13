from typing import List, Optional
from datetime import datetime
from pydantic import BaseModel

class VaultFolderCreateRequest(BaseModel):
    project_id: str
    project_title: str

class VaultSyncRequest(BaseModel):
    project_id: str
    target_drive_email: Optional[str] = "client.vault@aperturetube.io"
    size_gb: float


class VaultSyncResponse(BaseModel):
    status: str
    synced_size: str
    files_count: int
    drive_folder_id: str
    sync_timestamp: datetime

class TokenGenerateRequest(BaseModel):
    project_id: str
    client_email: str
    expires_hours: int = 48

class TokenVerifyResponse(BaseModel):
    is_valid: bool
    project_id: str
    token_code: str
    client_email: str
    vault_status: str
    raw_files_available: int
    total_size: str
    download_urls: List[str] = []
