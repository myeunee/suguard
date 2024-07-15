from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from typing import List
from app import crud, schemas
from app.dependencies import get_db

router = APIRouter()

@router.post("/cafes/", response_model=schemas.Cafe)
def create_cafe(cafe: schemas.CafeCreate, db: Session = Depends(get_db)):
    return crud.create_cafe(db=db, cafe=cafe)

@router.get("/cafes/", response_model=List[schemas.Cafe])
def read_cafes(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    cafes = crud.get_cafes(db, skip=skip, limit=limit)
    return cafes

@router.get("/cafes/{cafe_id}/likes/", response_model=List[schemas.Drink])
def read_liked_drinks_by_cafe(cafe_id: int, user_id: int, db: Session = Depends(get_db)):
    drinks = crud.get_liked_drinks_by_cafe(db, cafe_id=cafe_id, user_id=user_id)
    if not drinks:
        raise HTTPException(status_code=404, detail="No liked drinks found for this cafe and user")
    return drinks