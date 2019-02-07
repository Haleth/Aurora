#!/bin/sh

# set git identity
git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis CI"

# clone the wiki repo
git clone "https://${GITHUB_OAUTH}@github.com/Haleth/Aurora.wiki.git" .wiki

# run the python script
python parse.py -o ".wiki"

# navigate to the output directory
cd .wiki

# stage changes
git add .

# commit using the last commit SHA as the message
git commit -m "$TRAVIS_BUILD_ID"

# push the wiki repo
git push "https://${GITHUB_OAUTH}@github.com/Haleth/Aurora.wiki.git" master > /dev/null 2>&1
