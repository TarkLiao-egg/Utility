#!/bin/sh
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
disr=$(dirname $SCRIPT_DIR)
replace=$(basename $SCRIPT_DIR)
echo ${replace}
ymlUri="${disr}/${replace}/bitrise.yml"
sed -i '' "s/REPLACE/${replace}/g" ${ymlUri}
