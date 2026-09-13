import pytest
import pytest_asyncio
from httpx import AsyncClient, ASGITransport
from main import app
from app.init_db import init_database

@pytest_asyncio.fixture(scope="session", autouse=True)
async def setup_test_db():
    await init_database()

@pytest_asyncio.fixture
async def client():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as ac:
        yield ac
