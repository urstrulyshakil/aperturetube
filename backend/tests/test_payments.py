import pytest
from httpx import AsyncClient

@pytest.mark.asyncio
async def test_get_active_invoice(client: AsyncClient):
    response = await client.get("/api/v1/invoices/active")
    assert response.status_code == 200
    inv = response.json()
    assert inv["invoice_number"] == "#AT-2025-0891"
    assert inv["total_usd"] == 1890.0
    assert "BDT" in inv["total_bdt"]
    assert len(inv["line_items"]) == 4

@pytest.mark.asyncio
async def test_bkash_payment_flow(client: AsyncClient):
    # 1. Create payment
    create_payload = {
        "invoice_id": "#AT-2025-0891",
        "amount": "225750",
        "payer_reference": "01711223344",
    }
    create_res = await client.post("/api/v1/payments/bkash/create", json=create_payload)
    assert create_res.status_code == 200
    create_data = create_res.json()
    assert "payment_id" in create_data
    payment_id = create_data["payment_id"]
    assert create_data["currency"] == "BDT"

    # 2. Execute payment
    execute_res = await client.post(
        "/api/v1/payments/bkash/execute",
        json={"payment_id": payment_id},
    )
    assert execute_res.status_code == 200
    exec_data = execute_res.json()
    assert exec_data["success"] is True
    assert exec_data["drive_vault_unlocked"] is True
    assert "transaction_id" in exec_data

@pytest.mark.asyncio
async def test_stripe_payment_flow(client: AsyncClient):
    # 1. Create PaymentIntent
    intent_payload = {
        "invoice_id": "#AT-2025-0891",
        "amount": 1890.0,
    }
    intent_res = await client.post("/api/v1/payments/stripe/create-intent", json=intent_payload)
    assert intent_res.status_code == 200
    intent_data = intent_res.json()
    assert "client_secret" in intent_data
    assert "payment_intent_id" in intent_data
    intent_id = intent_data["payment_intent_id"]

    # 2. Confirm PaymentIntent
    confirm_res = await client.post(
        "/api/v1/payments/stripe/confirm",
        params={"payment_intent_id": intent_id},
    )
    assert confirm_res.status_code == 200
    confirm_data = confirm_res.json()
    assert confirm_data["success"] is True
    assert confirm_data["drive_vault_unlocked"] is True

@pytest.mark.asyncio
async def test_google_pay_process(client: AsyncClient):
    gpay_payload = {
        "invoice_id": "inv_01",
        "amount": 1890.0,
        "payment_token": "mock_google_pay_token_base64_encoded",
    }
    response = await client.post("/api/v1/payments/google-pay/process", json=gpay_payload)
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert data["gateway"] == "Google Pay Business"
    assert data["drive_vault_unlocked"] is True

@pytest.mark.asyncio
async def test_artisan_directory_and_booking(client: AsyncClient):
    # List artisans
    list_res = await client.get("/api/v1/community/artisans")
    assert list_res.status_code == 200
    artisans = list_res.json()
    assert len(artisans) >= 4

    # Filter by category
    filter_res = await client.get("/api/v1/community/artisans?discipline=Drone")
    assert filter_res.status_code == 200
    drone_artisans = filter_res.json()
    assert len(drone_artisans) == 1
    assert drone_artisans[0]["name"] == "Marcus Vance"

    # Book artisan
    book_res = await client.post(
        "/api/v1/community/book",
        json={
            "artisan_id": "artisan_01",
            "client_name": "Farhan & Anika",
            "client_email": "farhan@lux.io",
            "event_date": "2026-11-20",
            "notes": "4K RAW coverage needed",
        },
    )
    assert book_res.status_code == 200
    book_data = book_res.json()
    assert book_data["status"] == "CONFIRMED_WITH_ESCROW"
    assert "Google Drive" in book_data["escrow_guarantee"]
