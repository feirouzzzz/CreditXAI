import pytest
from app.model import load_model

def test_model_loads_successfully():
    model = load_model()
    assert model is not None
