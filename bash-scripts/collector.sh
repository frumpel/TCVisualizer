#!/bin/bash

TEAMCITY=ampcity.smarttech.inc
[[ -z "$XMLSTARLET" && -x /usr/local/bin/xml ]] && XMLSTARLET=/usr/local/bin/xml
[[ -z "$XMLSTARLET" && -x /opt/local/bin/xml ]] && XMLSTARLET=/opt/local/bin/xml

# Get all builds
curl -s -n -X GET  -H "Content-type: text/plain" "http://ampcity.smarttech.inc/httpAuth/app/rest/builds" \
| $XMLSTARLET sel -t -m '//build' -v '@href' -n \
| while read uri; do
    curl -s -n -X GET -H "Content-type: text/plain" "http://ampcity.smarttech.inc${uri}" \
    | $XMLSTARLET sel -t -m '//build' -v 'concat(
        @number,",",
        buildType/@projectName,",",
        buildType/@name,",",
        startDate,",",
        finishDate,",",
        @status)' -n \
    | egrep -i '(build|deploy)'
  done
