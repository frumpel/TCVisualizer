from sqlalchemy import Column, String, DATETIME
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class Task(Base):
    __tablename__ = 'buildhistory'

    buildNumber = Column(String, primary_key=True, nullable=False)
    projectName = Column(String, primary_key=True, nullable=False)
    taskName = Column(String, primary_key=True, nullable=False)
    startDate = Column(DATETIME)
    endDate = Column(DATETIME)
    status = Column(String)

    def __init__(self, buildNumber, projectName, taskName, startDate, endDate, status):
        self.buildNumber = buildNumber
        self.projectName = projectName
        self.taskName = taskName
        self.startDate = startDate
        self.endDate = endDate
        self.status = status

    def __repr__(self):
        format = "<Task(buildNumber='%s', projectName='%s', taskName='%s', startDate='%s', endDate='%s', status='%s')>"
        fields = (self.buildNumber, self.projectName, self.taskName, self.startDate, self.endDate, self.status)
        return format % fields