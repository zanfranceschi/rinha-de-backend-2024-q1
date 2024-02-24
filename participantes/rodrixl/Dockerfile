FROM python:3.11-slim
COPY src/ /app/
COPY ./requirements.txt /app
RUN pip install --upgrade pip
RUN pip install -r app/requirements.txt
WORKDIR /app


