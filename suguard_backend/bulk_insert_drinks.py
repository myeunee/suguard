import json
from sqlalchemy.orm import Session
from app.models import Drink
from app.database import SessionLocal
from app.schemas import DrinkCreate
from app.crud import create_drink

def load_json(file_path: str):
    with open(file_path, encoding='utf-8') as file:
        data = json.load(file)
    return data

def save_drinks_to_db(db: Session, drinks_data: list):
    for drink_data in drinks_data:
        drink_create = DrinkCreate(**drink_data)
        create_drink(db, drink=drink_create)

def main():
    file_path = 'drinks.json'
    drinks = load_json(file_path)
    db = SessionLocal()
    try:
        save_drinks_to_db(db, drinks)
    finally:
        db.close()

if __name__ == "__main__":
    main()
