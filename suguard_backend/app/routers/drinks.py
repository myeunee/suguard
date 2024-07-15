from fastapi import APIRouter, Depends, HTTPException, File, UploadFile
from sqlalchemy.orm import Session
from app import crud, schemas
from app.dependencies import get_db, s3_client

router = APIRouter()

@router.get("/drinks/", response_model=list[schemas.Drink])
def read_drinks(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    drinks = crud.get_drinks(db, skip=skip, limit=limit)
    return drinks

@router.post("/drinks/", response_model=schemas.Drink)
def create_drink(drink: schemas.DrinkCreate, db: Session = Depends(get_db)):
    db_cafe = crud.get_cafe(db, cafe_id=drink.cafe_id)
    if not db_cafe:
        raise HTTPException(status_code=404, detail="Cafe not found")
    return crud.create_drink(db=db, drink=drink)

@router.post("/upload/")
async def upload_file(file: UploadFile = File(...)):
    s3_client.upload_fileobj(file.file, 'your-bucket-name', file.filename)
    return {"filename": file.filename}
