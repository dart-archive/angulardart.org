#!/bin/bash
set -e

echo '*******************'
echo '** BUILDING SITE **'
echo '*******************'

cd site
jekyll build
