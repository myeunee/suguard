# schemas.py
from pydantic import BaseModel
from datetime import datetime
from typing import List

class UserBase(BaseModel):
    username: str
    email: str
    name: str
    gender: str

class UserCreate(UserBase):
    password: str

class User(UserBase):
    id: int

    class Config:
        orm_mode = True

class DrinkBase(BaseModel):
    name: str
    volume: float
    sugar_content: float
    calories: float
    sodium_content: float
    image_url: str

class DrinkCreate(DrinkBase):
    cafe_id: int

class Drink(DrinkBase):
    id: int
    cafe_id: int

    class Config:
        orm_mode = True

class CafeBase(BaseModel):
    name: str

class CafeCreate(CafeBase):
    pass

class Cafe(CafeBase):
    id: int

    class Config:
        orm_mode = True

class LikeBase(BaseModel):
    user_id: int
    drink_id: int

class LikeCreate(LikeBase):
    pass

class Like(LikeBase):
    id: int

    class Config:
        orm_mode = True

class ConsumptionBase(BaseModel):
    user_id: int
    drink_id: int
    timestamp: datetime

class ConsumptionCreate(ConsumptionBase):
    pass

class Consumption(ConsumptionBase):
    id: int

    class Config:
        orm_mode = True

class WeeklyStats(BaseModel):
    total_sugar_intake: float
    daily_average_sugar_intake: float
    daily_average_drinks: float
    total_calorie_intake: float
    total_sodium_intake: float

class Login(BaseModel):
    username: str
    password: str
