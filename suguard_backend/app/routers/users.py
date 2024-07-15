# users.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app import crud, schemas
from app.dependencies import get_db

router = APIRouter()

@router.post("/users/", response_model=schemas.User)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    db_user = crud.get_user_by_username(db, username=user.username)
    if db_user:
        raise HTTPException(status_code=400, detail="Username already registered")
    return crud.create_user(db=db, user=user)

@router.get("/users/{user_id}/stats/weekly", response_model=schemas.WeeklyStats)
def get_weekly_stats(user_id: int, db: Session = Depends(get_db)):
    stats = crud.get_weekly_stats(db, user_id=user_id)
    if not stats:
        raise HTTPException(status_code=404, detail="User or stats not found")
    return stats