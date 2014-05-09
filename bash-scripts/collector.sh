#!/bin/bash

TEAMCITY=ampcity.smarttech.inc
LIST_CNT=100
OUT_FORM=json

PROGNAME=`basename $0`
PROGPATH=`dirname  $0`
cd "$PROGPATH"
PROGPATH=`pwd`

Usage() {
  [ -n "$1" ] && echo "$1"
  cat <<EOT
#
# Query teamcity for information about all builds and output data
# for status portal
#
# USAGE: $PROGNAME [options]
#
# Options
#
# -a url     TeamCity URL
# -c int     Number of most recent builds to list
# -o format  Select output format. Options: csv,json,insert
#
EOT
  exit 1
}

while getopts ha:c:o: opt; do
  case $opt in
    h) 
      Usage
      ;;
    a) 
      TEAMCITY="$OPTARG"
      ;;
    c) 
      LIST_CNT="$OPTARG"
      ;;
    o) 
      case "$OPTARG" in
        csv|json|insert) 
          OUT_FORM="$OPTARG"
          ;;
        *) 
          Usage
          ;;
      esac
      ;;
    *)
      Usage
      ;;
  esac
done
shift $(($OPTIND -1))

[[ -z "$XMLSTARLET" && -x /usr/local/bin/xml ]] && XMLSTARLET=/usr/local/bin/xml
[[ -z "$XMLSTARLET" && -x /opt/local/bin/xml ]] && XMLSTARLET=/opt/local/bin/xml
[[ -z "$XMLSTARLET" && -x /usr/bin/xmlstarlet ]] && XMLSTARLET=/usr/bin/xmlstarlet
[[ -z "$XMLSTARLET" ]] && Usage "Need XML starlet"

# Get all builds
curl -s -n -X GET  -H "Content-type: text/plain" "http://ampcity.smarttech.inc/httpAuth/app/rest/builds?${LIST_CNT}" \
| $XMLSTARLET sel -t -m '//build' -v '@href' -n \
| while read uri; do
    echo "# $uri"
    [ -z "$uri" ]     && echo "# ... skipping" && continue
    [ "$uri" == "/" ] && echo "# ... skipping" && continue

    curl -s -n -X GET -H "Content-type: text/plain" "http://ampcity.smarttech.inc${uri}" \
    | (
        case $OUT_FORM in
          json)
            $XMLSTARLET sel -t -m '//build' -v 'concat(
              "{",
              "|buildNumber| : |", @number,                "|,",
              "|projectName| : |", buildType/@projectName, "|,",
              "|taskName| : |",    buildType/@name,        "|,",
              "|startDate| : |",   startDate,              "|,",
              "|endDate| : |",     finishDate,             "|,",
              "|taskStatus| : |",  @status,                "|",
              "}")' -n \
            | sed 's/|/"/g' \
            | egrep -i ' (build|deploy)'
            ;;
          csv)
            $XMLSTARLET sel -t -m '//build' -v 'concat(
              "buildNumber,", @number,                ",",
              "projectName,", buildType/@projectName, ",",
              "taskName,",    buildType/@name,        ",",
              "startDate,",   startDate,              ",",
              "endDate,",     finishDate,             ",",
              "taskStatus,",  @status,                ","
              )' -n \
            | sed 's/|/"/g' \
            | egrep -i ' (build|deploy)'
            ;;
          insert)
            $XMLSTARLET sel -t -m '//build' -v 'concat(
              "INSERT INTO buildhistory (buildNumber,projectName,taskName,startDate,endDate,status) VALUES (",
              "|", @number,                "|,",
              "|", buildType/@projectName, "|,",
              "|", buildType/@name,        "|,",
              "|", startDate,              "|,",
              "|", finishDate,             "|,",
              "|", @status,                "|)",
              " ON DUPLICATE KEY UPDATE ",
              "taskName=|", buildType/@name, "|,",
              "startDate=|", startDate, "|,",
              "endDate=|", finishDate, "|,",
              "status=|", @status, "|",
              ";")' -n \
            | sed 's/|/"/g; s/\(T[0-9]*\)-0[67]00/\1/g;' \
            | egrep -i '[0-9][^"]*(build|deploy)'
            
            ;;
          *)
            Usage "Unkown outform $OUT_FORM"
            ;;
        esac
      )
  done
