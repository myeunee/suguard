# dependencies.py
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import boto3
from botocore.client import Config
from passlib.context import CryptContext

SQLALCHEMY_DATABASE_URL = "mysql+mysqlconnector://root:example@db/suguard_db"

engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def init_db():
    import app.models  # Ensure this is importing correctly
    Base.metadata.drop_all(bind=engine)  # 기존 테이블 삭제
    Base.metadata.create_all(bind=engine)  # 새로운 테이블 생성

s3_client = boto3.client(
    's3',
    endpoint_url='http://s3:9000',
    aws_access_key_id='minio',
    aws_secret_access_key='minio123',
    config=Config(signature_version='s3v4'),
    region_name='us-east-1'
)
