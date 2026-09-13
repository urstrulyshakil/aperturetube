import pytest
from httpx import AsyncClient

@pytest.mark.asyncio
async def test_vault_telemetry_status(client: AsyncClient):
    response = await client.get("/api/v1/drive/vault-status")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "CONNECTED"
    assert "Google Drive" in data["provider"]
    assert data["storage_used_tb"] > 0
    assert data["storage_total_tb"] == 10.0
    assert data["raw_ingestion_ready"] is True

@pytest.mark.asyncio
async def test_vault_sync_trigger(client: AsyncClient):
    payload = {
        "project_id": "proj_01",
        "size_gb": 42.5,
    }
    response = await client.post("/api/v1/drive/sync", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "SYNCED_TO_DRIVE"
    assert "42.5 GB RAW" in data["synced_size"]
    assert "drive_folder_id" in data
    assert data["files_count"] == 140

@pytest.mark.asyncio
async def test_token_generation_and_verification(client: AsyncClient):
    # 1. Generate token
    gen_payload = {
        "project_id": "proj_01",
        "client_email": "vip.client@monaco.luxury",
        "expires_hours": 72,
    }
    gen_response = await client.post("/api/v1/drive/tokens/generate", json=gen_payload)
    assert gen_response.status_code == 200
    gen_data = gen_response.json()
    assert "token_code" in gen_data
    token_code = gen_data["token_code"]
    assert token_code.startswith("AT-")

    # 2. Verify token
    verify_response = await client.get(f"/api/v1/drive/tokens/verify/{token_code}")
    assert verify_response.status_code == 200
    verify_data = verify_response.json()
    assert verify_data["is_valid"] is True
    assert verify_data["token_code"] == token_code
    assert verify_data["vault_status"] == "Decrypted & Available"
    assert len(verify_data["download_urls"]) > 0

@pytest.mark.asyncio
async def test_grant_drive_access(client: AsyncClient):
    response = await client.post(
        "/api/v1/drive/grant-access",
        params={"folder_id": "drive_folder_mock_99", "client_email": "vip.client@monaco.luxury"}
    )
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert "vip.client@monaco.luxury" in data["message"]
