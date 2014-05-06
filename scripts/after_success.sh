#!/bin/bash
set -e

echo '****************'
echo '** SUBMITTING **'
echo '****************'

SHA=`git rev-parse HEAD`

echo Cloning
rm -rf generated
git clone . -b generated generated
cd generated

echo Copying generated sity
git rm -rf ./app
cp -r ../site/_site ./app

echo Setting up credentials
git config credential.helper "store --file=.git/credentials"
# travis encrypt GITHUB_TOKEN_ANGULARDART_ORG=??? --repo=angular/angulardart.org
echo "https://${GITHUB_TOKEN_ANGULARDART_ORG}:@github.com" > .git/credentials
git config user.name "travis@travis-ci.org"

echo Committing changed files
git add .
git commit -m "Automated push of generated docs from SHA: https://github.com/angular/angulardart.org/commit/$SHA"

echo Pushing to github
git remote rm origin
git remote add origin https://github.com/angular/angulardart.org.git
git push origin HEAD:generated
