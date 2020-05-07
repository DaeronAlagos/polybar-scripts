#!/bin/sh

activity=$(timew export from $(date +%Y-%m-%d) | jq '.[-1]')
end=$(echo "$activity" | jq -er '.end')

get_activity() {
  start=$(date -u -d "$(echo $activity | jq -r '.start' | sed 's,\([0-9]\{4\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)\(T\)\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)\(Z\),\1-\2-\3 \5:\6:\7,')" +"%s")
  now=$(date -u +"%s")
  diff=$(date -u -d "0 $now seconds - $start seconds" +"%H:%M:%S")
  tags=$(echo "$activity" | jq -r '.tags | join(",")')
  echo $tags "|" $diff
}

if [ "$end" = null ]; then
  get_activity
else
  echo 'Not Tracking Time'
fi

# TODO: If jq array is empty then error occurs
