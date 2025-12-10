from fastapi import FastAPI
from model import load_model, predict_score, explain_prediction
import uvicorn

app = FastAPI(title="ML Scoring Service")

model = load_model()

@app.post("/score")
def score(input_data: dict):
    return {"score": predict_score(model, input_data)}

@app.post("/explain")
def explain(input_data: dict):
    return explain_prediction(model, input_data)

@app.get("/health")
def health():
    return {"status": "ok"}

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8001, reload=True)
