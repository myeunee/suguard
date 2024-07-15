from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app import crud, schemas
from app.dependencies import get_db

router = APIRouter()

@router.post("/login")
async def login(credentials: schemas.Login, db: Session = Depends(get_db)):
    user = crud.get_user_by_username(db, username=credentials.username)
    if not user or not user.verify_password(credentials.password):
        raise HTTPException(status_code=400, detail="Invalid username or password")
    return {"message": "Login successful"}
