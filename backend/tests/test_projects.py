import pytest
from httpx import AsyncClient

@pytest.mark.asyncio
async def test_list_projects(client: AsyncClient):
    response = await client.get("/api/v1/projects")
    assert response.status_code == 200
    projects = response.json()
    assert len(projects) >= 2
    assert any(p["id"] == "proj_01" for p in projects)
    assert any("Monaco" in p["title"] for p in projects)

@pytest.mark.asyncio
async def test_filter_projects_by_status(client: AsyncClient):
    response = await client.get("/api/v1/projects?status=selection")
    assert response.status_code == 200
    projects = response.json()
    assert len(projects) >= 1
    for p in projects:
        assert p["status"] == "selection"

@pytest.mark.asyncio
async def test_get_bento_metrics_summary(client: AsyncClient):
    response = await client.get("/api/v1/projects/metrics/summary")
    assert response.status_code == 200
    data = response.json()
    assert "live_shoots" in data
    assert "client_curations" in data
    assert "ready_for_handoff" in data
    assert "secured_balance" in data

@pytest.mark.asyncio
async def test_get_project_detail_with_photos(client: AsyncClient):
    response = await client.get("/api/v1/projects/proj_01")
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == "proj_01"
    assert "photos" in data
    assert len(data["photos"]) >= 1
    photo = data["photos"][0]
    assert "camera" in photo
    assert "aperture" in photo
    assert "shutter" in photo

@pytest.mark.asyncio
async def test_update_photo_curation_status(client: AsyncClient):
    # Toggle favorite & retouch
    patch_payload = {
        "is_favorite": True,
        "is_retouch_requested": True,
    }
    response = await client.patch(
        "/api/v1/projects/proj_01/photos/photo_01",
        json=patch_payload,
    )
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == "photo_01"

    assert data["is_favorite"] is True
    assert data["is_retouch_requested"] is True
