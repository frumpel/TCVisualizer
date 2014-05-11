i#!/bin/bash

STEP=100
MAX=100000

ii=0
while [ $ii -lt $MAX ]; do
  echo ============================================================
  echo Get $STEP entries starting at $ii
  bash collector.sh -s $ii -c $STEP \
  | tee /tmp/data
  cat /tmp/data \
  | mysql tc
  ii=$(($ii+$STEP))
done
