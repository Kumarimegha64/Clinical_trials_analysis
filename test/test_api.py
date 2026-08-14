from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)


def test_root():
    response = client.get("/")
    assert response.status_code == 200


def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "ok"


def test_data_summary():
    response = client.get("/data/summary")
    assert response.status_code == 200


def test_trial_search():
    response = client.get("/trials/search?limit=5")
    assert response.status_code == 200
    assert "results" in response.json()