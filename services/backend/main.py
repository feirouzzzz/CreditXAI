from fastapi import FastAPI
from app.auth.auth_router import router as auth_router
from app.controllers.file_controller import router as file_router
from app.database import Base, engine
import app.storage.minio_client as minio_client

# create DB tables (simple dev approach)
Base.metadata.create_all(bind=engine)

app = FastAPI(title="CreditXAI Backend - File Uploads")

app.include_router(auth_router, prefix="/auth", tags=["auth"])
app.include_router(file_router, prefix="/files", tags=["files"])
