# models.py
from sqlalchemy import Column, Integer, String, Float, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime
from app.dependencies import Base
from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String(50), unique=True, index=True)
    email = Column(String(100), unique=True, index=True)
    hashed_password = Column(String(100))
    name = Column(String(100))
    gender = Column(String(10))

    likes = relationship("Like", back_populates="user")
    consumptions = relationship("Consumption", back_populates="user")

    def verify_password(self, password: str) -> bool:
        return pwd_context.verify(password, self.hashed_password)
        
class Drink(Base):
    __tablename__ = 'drinks'

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), index=True)
    volume = Column(Float)
    sugar_content = Column(Float)
    calories = Column(Float)
    sodium_content = Column(Float)
    image_url = Column(String(255))
    cafe_id = Column(Integer, ForeignKey('cafes.id'))

    cafe = relationship("Cafe", back_populates="drinks")
    likes = relationship("Like", back_populates="drink")
    consumptions = relationship("Consumption", back_populates="drink")

    def verify_password(self, password: str) -> bool:
        return pwd_context.verify(password, self.hashed_password)

class Cafe(Base):
    __tablename__ = 'cafes'

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), index=True)

    drinks = relationship("Drink", back_populates="cafe")

class Like(Base):
    __tablename__ = 'likes'

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey('users.id'))
    drink_id = Column(Integer, ForeignKey('drinks.id'))

    user = relationship("User", back_populates="likes")
    drink = relationship("Drink", back_populates="likes")

class Consumption(Base):
    __tablename__ = 'consumptions'

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey('users.id'))
    drink_id = Column(Integer, ForeignKey('drinks.id'))
    timestamp = Column(DateTime, default=datetime.utcnow)

    user = relationship("User", back_populates="consumptions")
    drink = relationship("Drink", back_populates="consumptions")
