FROM python:3.9-slim

WORKDIR /api

COPY requirements.txt /api/requirements.txt

RUN pip install --no-cache-dir -U -r /api/requirements.txt

COPY api.py /api/api.py

EXPOSE 8000

CMD ["uvicorn", "api:app", "--proxy-headers", "--host", "0.0.0.0", "--port", "8000"]
