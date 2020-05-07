#!/bin/sh

activity_list=$(timew export from $(date +%Y-%m-%d) | jq '.')

get_activity() {
  start=$(date -u -d "$(echo $activity | jq -r '.start' | sed 's,\([0-9]\{4\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)\(T\)\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)\(Z\),\1-\2-\3 \5:\6:\7,')" +"%s")
  now=$(date -u +"%s")
  diff=$(date -u -d "0 $now seconds - $start seconds" +"%H:%M:%S")
  tags=$(echo "$activity" | jq -r '.tags | join(",")')
  echo $tags "|" $diff
}

get_state() {
  activity=$(echo "$activity_list" | jq '.[-1]')
  end=$(echo "$activity" | jq -er '.end')
  if [ "$end" = null ]; then
    get_activity
  else
    echo 'Not Tracking Time'
  fi
}

if [ $(echo "$activity_list" | jq '. | length') = 0 ]; then
  echo 'Not Tracking Time'
else
  get_state
fi
