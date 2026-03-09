import asyncio
import os
import sys
from sqlalchemy import text

# PYTHONPATH 설정 (back 폴더 인식)
sys.path.append(os.path.join(os.getcwd(), 'back'))

from core.database import engine, Base

COURSES_DATA = [
    {
        "title": "[건설안전기술사] 4-3. 지반 개량 공법의 종류",
        "description": "건설안전 기술사 시험 대비 지반 개량 공법의 종류와 특징을 다루는 실무 강의입니다.",
        "video_url": "f3_XBCz8v-A",
        "thumbnail_url": "https://i.ytimg.com/vi/f3_XBCz8v-A/hqdefault.jpg",
        "price": 0,
        "level": "Expert",
        "instructor_id": "P6IX-SC"
    },
    {
        "title": "[건설안전기술사] 4-2. 다짐과 압밀",
        "description": "토질 역학의 기초가 되는 지반 다짐과 압밀의 원리를 상세하게 설명합니다.",
        "video_url": "yEzfFl-ta3w",
        "thumbnail_url": "https://i.ytimg.com/vi/yEzfFl-ta3w/hqdefault.jpg",
        "price": 0,
        "level": "Expert",
        "instructor_id": "P6IX-SC"
    },
    {
        "title": "[건설안전기술사] 4-1. 최적 함수비(O.M.C)",
        "description": "최적 함수비(O.M.C) 개념과 시험 방법, 실무 적용 사례를 학습합니다.",
        "video_url": "MIQFF5qbBVA",
        "thumbnail_url": "https://i.ytimg.com/vi/MIQFF5qbBVA/hqdefault.jpg",
        "price": 0,
        "level": "Expert",
        "instructor_id": "P6IX-SC"
    },
    {
        "title": "3강 통합본",
        "description": "건설안전 핵심 이론 3강을 한 번에 학습할 수 있는 통합본 영상입니다.",
        "video_url": "Geoc46v2sEo",
        "thumbnail_url": "https://i.ytimg.com/vi/Geoc46v2sEo/hqdefault.jpg",
        "price": 0,
        "level": "Expert",
        "instructor_id": "P6IX-SC"
    },
    {
        "title": "[건설안전기술사] 3-29. 타워크레인을 자립고 이상의 높이로 설치할 경우 지지방법과 준수사항",
        "description": "고층 작업의 핵심인 타워크레인 지지 방법과 안전 준수 사항을 다룹니다.",
        "video_url": "1Paj8k0uP7o",
        "thumbnail_url": "https://i.ytimg.com/vi/1Paj8k0uP7o/hqdefault.jpg",
        "price": 0,
        "level": "Intermediate",
        "instructor_id": "P6IX-SC"
    },
    {
        "title": "[건설안전기술사] 3-28. 타워크레인 재해유형 구성부위별 안전검토사항 조립,해체 시 유의사항",
        "description": "타워크레인 조립 및 해체 시 발생할 수 있는 재해 유형과 예방 대책을 학습합니다.",
        "video_url": "5aP4TQIk0TY",
        "thumbnail_url": "https://i.ytimg.com/vi/5aP4TQIk0TY/hqdefault.jpg",
        "price": 0,
        "level": "Intermediate",
        "instructor_id": "P6IX-SC"
    },
    {
        "title": "[건설안전기술사] 3-26. 곤돌라 안전장치",
        "description": "외벽 작업 시 사용되는 곤돌라의 주요 안전 기구와 점검 요령을 설명합니다.",
        "video_url": "9MJkCH0DWkg",
        "thumbnail_url": "https://i.ytimg.com/vi/9MJkCH0DWkg/hqdefault.jpg",
        "price": 0,
        "level": "Intermediate",
        "instructor_id": "P6IX-SC"
    },
    {
        "title": "[건설안전기술사] 3-25. 건설작업용 리프트의 조립, 해체작업 및 위험성 평가 시 사고유형/안전대책",
        "description": "건설 리프트 작업의 위험성 평가 방법과 조립/해체 시 안전 수칙을 배웁니다.",
        "video_url": "G2h1pIHU3PI",
        "thumbnail_url": "https://i.ytimg.com/vi/G2h1pIHU3PI/hqdefault.jpg",
        "price": 0,
        "level": "Beginner",
        "instructor_id": "P6IX-SC"
    },
    {
        "title": "[건설안전기술사] 3-23. 건설작업용 리프트 사용 시 주의사항 / 3-24. 리프트 설치, 해체, 조립, 점검, 계획, 수립 시 조치사항",
        "description": "리프트 운영 전반에 걸친 계획 수립과 안전 조치 사항을 상세히 정리합니다.",
        "video_url": "ajlp8muWwf4",
        "thumbnail_url": "https://i.ytimg.com/vi/ajlp8muWwf4/hqdefault.jpg",
        "price": 0,
        "level": "Beginner",
        "instructor_id": "P6IX-SC"
    },
    {
        "title": "[건설안전기술사] 3-21. 양중기 안전대책 / 3-22 . 크레인 작업 시 조치사항",
        "description": "중량물 취급 시 필수적인 양중기 안전 관리 체계와 크레인 작업 수칙을 다룹니다.",
        "video_url": "bSoFGw4Hlj4",
        "thumbnail_url": "https://i.ytimg.com/vi/bSoFGw4Hlj4/hqdefault.jpg",
        "price": 0,
        "level": "Beginner",
        "instructor_id": "P6IX-SC"
    }
]

async def seed():
    print("🌱 Seeding Courses from YouTube data...")
    async with engine.begin() as conn:
        # 기존 데이터 삭제 (중복 방지)
        await conn.execute(text("DELETE FROM courses"))
        
        # 새 데이터 삽입
        for course in COURSES_DATA:
            sql = text("""
                INSERT INTO courses (title, description, thumbnail_url, video_url, price, level, instructor_id, created_at)
                VALUES (:title, :description, :thumbnail_url, :video_url, :price, :level, :instructor_id, NOW())
            """)
            await conn.execute(sql, course)
            print(f"✅ Inserted: {course['title']}")

    print("🚀 Seeding Completed!")

if __name__ == "__main__":
    asyncio.run(seed())
