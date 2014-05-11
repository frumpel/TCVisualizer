from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# DB Connection String: remove from source control later and change it
engine = create_engine('mysql://root:hackathon@10.7.71.30/tc')
Session = sessionmaker(bind=engine)
