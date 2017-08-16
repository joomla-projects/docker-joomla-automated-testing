#!/bin/bash

sed -i -e "s/{SE_OPTS}/{SE_OPTS} >> \/var\/log\/selenium.log 2>\&1/g" /opt/bin/entry_point.sh

/opt/bin/entry_point.sh &

if [ -f /usr/src/scripts/entrypoint-specific.sh ]; then
	. /usr/src/scripts/entrypoint-specific.sh
fi;

if [ -n "$GITHUB_TOKEN" ]; then
	composer config -g github-oauth.github.com $GITHUB_TOKEN
fi;

cd /usr/src/tests/tests

composer install --prefer-dist
vendor/bin/robo run:container-test-preparation
tail -f /dev/null