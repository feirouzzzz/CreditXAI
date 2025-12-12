from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime

class UserCreate(BaseModel):
    email: EmailStr
    password: str

class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"

class FileOut(BaseModel):
    id: int
    category: str
    filename: str
    object_name: str
    content_type: Optional[str]
    size: Optional[int]
    uploaded_at: datetime

    class Config:
        orm_mode = True
