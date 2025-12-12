from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.schemas import UserCreate, Token
from app.auth import auth_service, jwt_handler
from app.config import settings

router = APIRouter()

@router.post("/register", response_model=Token)
def register(user_in: UserCreate, db: Session = Depends(get_db)):
    existing = auth_service.get_user_by_email(db, user_in.email)
    if existing:
        raise HTTPException(status_code=400, detail="Email already registered")
    user = auth_service.create_user(db, user_in.email, user_in.password)
    token = jwt_handler.create_access_token({"sub": str(user.id), "email": user.email})
    return {"access_token": token}

@router.post("/login", response_model=Token)
def login(user_in: UserCreate, db: Session = Depends(get_db)):
    user = auth_service.get_user_by_email(db, user_in.email)
    if not user or not auth_service.verify_password(user_in.password, user.hashed_password):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid credentials")
    token = jwt_handler.create_access_token({"sub": str(user.id), "email": user.email})
    return {"access_token": token}
