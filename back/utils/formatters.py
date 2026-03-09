from datetime import datetime
import json
from decimal import Decimal

def format_datetime(dt: datetime) -> str:
    """날짜 데이터를 표준 문자열로 변환합니다."""
    return dt.strftime("%Y-%m-%d %H:%M:%S")

class CustomJSONEncoder(json.JSONEncoder):
    """Decimal 및 DateTime 처리를 위한 커스텀 JSON 인코더"""
    def default(self, obj):
        if isinstance(obj, Decimal):
            return float(obj)
        if isinstance(obj, datetime):
            return format_datetime(obj)
        return super(CustomJSONEncoder, self).default(obj)
