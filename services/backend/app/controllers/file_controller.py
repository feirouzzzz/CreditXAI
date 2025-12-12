from fastapi import APIRouter, UploadFile, File, Depends, HTTPException
from sqlalchemy.orm import Session
from app.deps import get_current_user
from app.database import get_db
from app.services.file_service import upload_file_to_minio, save_file_metadata, ALLOWED_CATEGORIES
from app.schemas import FileOut
from typing import List

router = APIRouter()

@router.post("/upload/{category}", response_model=FileOut)
def upload(category: str, file: UploadFile = File(...), db: Session = Depends(get_db), user = Depends(get_current_user)):
    if category not in ALLOWED_CATEGORIES:
        raise HTTPException(status_code=400, detail="Invalid category")
    try:
        object_name, url, size = upload_file_to_minio(file, user.id, category)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    metadata = save_file_metadata(db, user.id, category, file.filename, object_name, file.content_type, size)
    return metadata

@router.get("/me", response_model=List[FileOut])
def list_my_files(db: Session = Depends(get_db), user = Depends(get_current_user)):
    files = db.query(__import__("app").models.UploadedFile).filter_by(user_id=user.id).all()
    return files

@router.get("/download/{file_id}")
def download_file(file_id: int, db: Session = Depends(get_db), user = Depends(get_current_user)):
    file = db.query(__import__("app").models.UploadedFile).get(file_id)
    if not file or file.user_id != user.id:
        raise HTTPException(status_code=404, detail="File not found")
    # Generate presigned URL valid for a limited time
    from app.storage.minio_client import minio_client, BUCKET
    url = minio_client.presigned_get_object(BUCKET, file.object_name, expires=60*5)
    return {"download_url": url}
