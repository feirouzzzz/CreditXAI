import uuid
from fastapi import UploadFile
from app.storage.minio_client import minio_client, BUCKET
from sqlalchemy.orm import Session
from app import models

ALLOWED_CATEGORIES = {"identity", "income", "bank", "credit", "address", "business"}
ALLOWED_EXTS = {"pdf", "jpg", "jpeg", "png", "csv"}

def _ext_ok(filename: str):
    ext = filename.rsplit(".", 1)[-1].lower()
    return ext in ALLOWED_EXTS

def upload_file_to_minio(file: UploadFile, user_id: int, category: str):
    if category not in ALLOWED_CATEGORIES:
        raise ValueError("Invalid category")
    if not _ext_ok(file.filename):
        raise ValueError("Invalid file extension")
    ext = file.filename.rsplit(".", 1)[-1].lower()
    object_name = f"{user_id}/{category}/{uuid.uuid4()}.{ext}"
    # Note: length is unknown; use put_object with data stream but we need to read file bytes
    body = file.file.read()
    size = len(body)
    minio_client.put_object(BUCKET, object_name, data=body, length=size, content_type=file.content_type)
    url = f"{minio_client._endpoint_url}/{BUCKET}/{object_name}"
    return object_name, url, size

def save_file_metadata(db: Session, user_id: int, category: str, filename: str, object_name: str, content_type: str, size: int):
    file = models.UploadedFile(
        user_id=user_id,
        category=category,
        filename=filename,
        object_name=object_name,
        content_type=content_type,
        size=size
    )
    db.add(file)
    db.commit()
    db.refresh(file)
    return file
