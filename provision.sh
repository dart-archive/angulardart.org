#!/bin/sh

echo "Installing rubygems and bundler..."
apt-get -qq update
apt-get -y install rubygems
gem install bundler

echo "Running site..."
cd /home/angulardart
bundle install
cd site
jekyll serve --watch --detach