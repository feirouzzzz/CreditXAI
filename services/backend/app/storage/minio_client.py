from minio import Minio
from app.config import settings
from urllib.parse import urljoin

minio_client = Minio(
    endpoint=settings.MINIO_ENDPOINT,
    access_key=settings.MINIO_ACCESS_KEY,
    secret_key=settings.MINIO_SECRET_KEY,
    secure=settings.MINIO_SECURE
)

BUCKET = settings.MINIO_BUCKET

# Create bucket if not exists
if not minio_client.bucket_exists(BUCKET):
    minio_client.make_bucket(BUCKET)
