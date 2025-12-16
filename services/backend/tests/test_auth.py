from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_login_fail():
    payload = {"email": "no@user.com", "password": "wrong"}
    response = client.post("/auth/login", json=payload)
    assert response.status_code == 401

def test_login_success():
    payload = {"email": "john@test.com", "password": "strongPass1"}
    response = client.post("/auth/login", json=payload)
    assert response.status_code == 200
    assert "access_token" in response.json()
