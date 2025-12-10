from fastapi import FastAPI # type: ignore

app = FastAPI()

@app.get("/health")
def health_check():
    return {"status": "OK"}
