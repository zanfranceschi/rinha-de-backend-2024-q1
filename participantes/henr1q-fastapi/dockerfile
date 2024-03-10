FROM python:3.10.8


WORKDIR /app
COPY ./requirements.txt .

COPY . /app

RUN pip install --upgrade pip
RUN pip install "psycopg[binary]"
RUN pip install -r requirements.txt
