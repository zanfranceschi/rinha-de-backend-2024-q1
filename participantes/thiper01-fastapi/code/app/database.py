from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

SQLALCHEMY_DATABASE_URL = "postgresql+psycopg2://admin:123@db/rinha"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    # isolation_level="REPEATABLE READ",
)
SessionLocal = sessionmaker(bind=engine)

Base = declarative_base()
