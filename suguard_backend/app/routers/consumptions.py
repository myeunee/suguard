from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app import crud, schemas
from app.dependencies import get_db

router = APIRouter()

@router.post("/consumptions/", response_model=schemas.Consumption)
def create_consumption(consumption: schemas.ConsumptionCreate, db: Session = Depends(get_db)):
    db_user = crud.get_user(db, user_id=consumption.user_id)
    db_drink = crud.get_drink(db, drink_id=consumption.drink_id)
    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")
    if not db_drink:
        raise HTTPException(status_code=404, detail="Drink not found")
    return crud.create_consumption(db=db, consumption=consumption)

@router.get("/consumptions/", response_model=list[schemas.Consumption])
def read_consumptions(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    consumptions = crud.get_consumptions(db, skip=skip, limit=limit)
    return consumptions
