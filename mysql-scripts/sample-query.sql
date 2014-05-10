# Select all fields, order them nicely, and convert timestamps to epoch
# as per http://sql-info.de/mysql/notes/convert-timestamp-to-unix-epoch.html

SELECT 
  projectName,
  buildNumber,
  taskName,
  UNIX_TIMESTAMP(startDate),
  UNIX_TIMESTAMP(endDate),
  status 
FROM tc.buildhistory 
ORDER BY 
  projectName,
  buildNumber,
  taskName;
