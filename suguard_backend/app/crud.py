# crud.py
from sqlalchemy.orm import Session
from app.models import User, Drink, Cafe, Like, Consumption
from app.schemas import UserCreate, DrinkCreate, CafeCreate, LikeCreate, ConsumptionCreate
from app.dependencies import get_password_hash
from datetime import datetime, timedelta

def get_user(db: Session, user_id: int):
    return db.query(User).filter(User.id == user_id).first()

def get_user_by_username(db: Session, username: str):
    return db.query(User).filter(User.username == username).first()

def create_user(db: Session, user: UserCreate):
    hashed_password = get_password_hash(user.password)
    db_user = User(username=user.username, email=user.email, hashed_password=hashed_password, name=user.name, gender=user.gender)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

def get_drink(db: Session, drink_id: int):
    return db.query(Drink).filter(Drink.id == drink_id).first()

def get_drinks(db: Session, skip: int = 0, limit: int = 10):
    return db.query(Drink).offset(skip).limit(limit).all()

def create_drink(db: Session, drink: DrinkCreate):
    db_drink = Drink(**drink.dict())
    db.add(db_drink)
    db.commit()
    db.refresh(db_drink)
    return db_drink

def get_cafes(db: Session, skip: int = 0, limit: int = 10):
    return db.query(Cafe).offset(skip).limit(limit).all()

def create_cafe(db: Session, cafe: CafeCreate):
    db_cafe = Cafe(**cafe.dict())
    db.add(db_cafe)
    db.commit()
    db.refresh(db_cafe)
    return db_cafe

def get_cafe(db: Session, cafe_id: int):
    return db.query(Cafe).filter(Cafe.id == cafe_id).first()

def get_likes(db: Session, skip: int = 0, limit: int = 10):
    return db.query(Like).offset(skip).limit(limit).all()

def create_like(db: Session, like: LikeCreate):
    db_like = Like(**like.dict())
    db.add(db_like)
    db.commit()
    db.refresh(db_like)
    return db_like

def get_consumptions(db: Session, skip: int = 0, limit: int = 10):
    return db.query(Consumption).offset(skip).limit(limit).all()

def create_consumption(db: Session, consumption: ConsumptionCreate):
    db_consumption = Consumption(**consumption.dict())
    db.add(db_consumption)
    db.commit()
    db.refresh(db_consumption)
    return db_consumption

def get_weekly_stats(db: Session, user_id: int):
    week_ago = datetime.utcnow() - timedelta(days=7)
    consumptions = db.query(Consumption).filter(Consumption.user_id == user_id, Consumption.timestamp >= week_ago).all()

    if not consumptions:
        return None

    total_sugar_intake = sum([c.drink.sugar_content for c in consumptions])
    total_calorie_intake = sum([c.drink.calories for c in consumptions])
    total_sodium_intake = sum([c.drink.sodium_content for c in consumptions])

    daily_average_sugar_intake = total_sugar_intake / 7
    daily_average_drinks = len(consumptions) / 7

    return {
        "total_sugar_intake": total_sugar_intake,
        "daily_average_sugar_intake": daily_average_sugar_intake,
        "daily_average_drinks": daily_average_drinks,
        "total_calorie_intake": total_calorie_intake,
        "total_sodium_intake": total_sodium_intake
    }


def get_liked_drinks_by_cafe(db: Session, cafe_id: int, user_id: int):
    return db.query(Drink).join(Like).filter(Like.user_id == user_id, Drink.cafe_id == cafe_id).all()