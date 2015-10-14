#!/bin/bash

/opt/bin/entry_point.sh &

if [ -f /usr/src/scripts/entrypoint-specific.sh ]; then
	. /usr/src/scripts/entrypoint-specific.sh
fi;

if [ -n "$GITHUB_TOKEN" ]; then
	composer config -g github-oauth.github.com $GITHUB_TOKEN
fi;

cd /usr/src/app
composer install

vendor/bin/robo run:tests-from-docker-container

if [ -n "$SLACK_CHANNEL" ] && [ -n "$SLACK_TOKEN" ]; then
	vendor/bin/robo send:codeception-output-to-slack $SLACK_CHANNEL $SLACK_TOKEN
fi;
