# Docker-Joomla automated testing
Docker image with server configuration for testing Joomla CMS and Joomla extensions

This repository contains two Docker images for Joomla automated tests:

## joomla-automated-testing-server
Based on [docker-joomla](https://github.com/joomla/docker-joomla), it creates a multi-Joomla and multi-app environment based on several php versions to test Joomla-based applications with.

## joomla-automated-testing-client
Contains a Selenium-powered image with VNC, ready to receive the selenium and robo scripts, to execute Joomla tests with the help of [joomla-browser](https://github.com/joomla-projects/joomla-browser)
