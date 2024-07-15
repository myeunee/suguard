from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app import crud, schemas
from app.dependencies import get_db

router = APIRouter()

@router.post("/likes/", response_model=schemas.Like)
def create_like(like: schemas.LikeCreate, db: Session = Depends(get_db)):
    db_user = crud.get_user(db, user_id=like.user_id)
    db_drink = crud.get_drink(db, drink_id=like.drink_id)
    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")
    if not db_drink:
        raise HTTPException(status_code=404, detail="Drink not found")
    return crud.create_like(db=db, like=like)

@router.get("/likes/", response_model=list[schemas.Like])
def read_likes(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    likes = crud.get_likes(db, skip=skip, limit=limit)
    return likes
