from sqlalchemy import Column, Integer, String, Text, DateTime
from core.database import Base
import datetime

class Course(Base):
    __tablename__ = "courses"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False)
    description = Column(Text)
    thumbnail_url = Column(String)
    video_url = Column(String)  # 유튜브 ID 또는 클라우드 영상 URL 저장용
    price = Column(Integer, default=0)
    level = Column(String)
    instructor_id = Column(String) 
    created_at = Column(DateTime, default=datetime.datetime.utcnow)
