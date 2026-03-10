from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker, declarative_base
from sqlalchemy import text
import os
from dotenv import load_dotenv

load_dotenv()

# DATABASE_URL: .env의 설정을 우선하며, 없을 경우 기본값을 사용합니다.
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql+asyncpg://postgres:0000@localhost:5700/edu")

engine = create_async_engine(DATABASE_URL, echo=False)
AsyncSessionLocal = sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)
Base = declarative_base()

async def get_db():
    async with AsyncSessionLocal() as session:
        yield session

async def execute(sql: str, params: dict = None):
    async with engine.begin() as conn:
        await conn.execute(text(sql), params or {})

async def fetch_all(sql: str, params: dict = None):
    async with engine.connect() as conn:
        result = await conn.execute(text(sql), params or {})
        return [dict(row._mapping) for row in result]

async def fetch_one(sql: str, params: dict = None):
    async with engine.connect() as conn:
        result = await conn.execute(text(sql), params or {})
        row = result.first()
        return dict(row._mapping) if row else None

async def insert_and_return(sql: str, params: dict = None):
    """INSERT ... RETURNING * 실행 후 반환된 한 행을 dict로 반환."""
    async with engine.begin() as conn:
        result = await conn.execute(text(sql), params or {})
        row = result.first()
        return dict(row._mapping) if row else None

# === Models Import (Atlas 마이그레이션용 전수 조사) ===
# 향후 도메인이 추가될 때마다 여기에 Import를 추가하여 Atlas가 인식하게 합니다.
try:
    from course.model import Course
    from user.model import User
    # 향후 추가 예정 모델들 (예시)
    # from payment.model import Payment
    # from enrollment.model import Enrollment
except ImportError:
    pass
