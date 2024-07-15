import json
from sqlalchemy.orm import Session
from app.models import Cafe
from app.schemas import CafeCreate
from app.database import SessionLocal
from app.crud import create_cafe

def load_json(file_path):
    with open(file_path, encoding='utf-8') as file:
        data = json.load(file)
    return data

def save_cafes_to_db(db: Session, cafes: list):
    for cafe_data in cafes:
        cafe_create = CafeCreate(**cafe_data)
        create_cafe(db, cafe=cafe_create)

def main():
    file_path = 'cafes.json'
    cafes = load_json(file_path)
    db = SessionLocal()
    save_cafes_to_db(db, cafes)

if __name__ == '__main__':
    main()
