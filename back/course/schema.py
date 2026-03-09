from pydantic import BaseModel, ConfigDict
from typing import Optional, List
from datetime import datetime

class CourseBase(BaseModel):
    title: str
    description: Optional[str] = None
    thumbnail_url: Optional[str] = None
    video_url: Optional[str] = None
    price: int
    level: str

class CourseCreate(CourseBase):
    pass

class Course(CourseBase):
    id: int
    instructor_id: str
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)
