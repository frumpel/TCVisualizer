CREATE DATABASE tc;

CREATE TABLE tc.buildhistory
(
buildNumber varchar(255) NOT NULL,
projectName  varchar(255) NOT NULL,
taskName  varchar(255) NOT NULL,
startDate datetime,
endDate datetime,
status varchar(255),
CONSTRAINT UpsertID PRIMARY KEY (buildNumber,projectName,taskName)
)

