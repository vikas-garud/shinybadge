#!/usr/bin/env bash
set -x
OLD_COVERAGE=0
COVERAGE=0
RESULT_MESSAGE=""

BADGE_COLOR=red
GREEN_THRESHOLD=85
YELLOW_THRESHOLD=50
PAGES_BRANCH="master"

COMMIT_RANGE=(${TRAVIS_COMMIT_RANGE//.../ })
CURRENT_COMMIT=${COMMIT_RANGE[1]}

#--  ------------ creating code coverage reports ------------ 
# clone and prepare code coverage and create code coverage reports
# primary purpose is to create code coverage for all subfolders in key-protect
#--  ------------ creating code coverage reports ------------ 
git clone -b $PAGES_BRANCH https://vikas-garud:$GIT_TOKEN@github.com/$TRAVIS_REPO_SLUG.git tmp
cd tmp
open .
if [ ! -d "./coverage-report" ]; then
	mkdir "coverage-report"
fi

if [ ! -d "./coverage-report/$TRAVIS_BRANCH" ]; then
	mkdir "./coverage-report/$TRAVIS_BRANCH"
fi

COVERAGE=$(cat $TRAVIS_BUILD_DIR/cover_percent.out | cut -d "." -f1)
echo "NEW COVERAGE" $COVERAGE

if (( $(echo "$COVERAGE > $GREEN_THRESHOLD" | bc -l) )); then
	BADGE_COLOR="green"
elif (( $(echo "$COVERAGE > $YELLOW_THRESHOLD" | bc -l) )); then
	BADGE_COLOR="yellow"
fi

if [[ ! -f $TRAVIS_BUILD_DIR/cover_percent.out  ]]; then
	COVERAGE=0
fi

curl https://img.shields.io/badge/Coverage-$COVERAGE%-$BADGE_COLOR.svg > ./coverage-report/$TRAVIS_BRANCH/badge.svg
git config --global user.name "vikas-garud"
git config --global user.email "vg9288@gmail.com"
git add ./
git commit -m "Coverage result ...for commit $CURRENT_COMMIT from build $TRAVIS_BUILD_NUMBER"
git push -u origin master
#--  ------------ END creating code coverage reports ------------ 





#--  ------------ deploying pages, badges ------------ 
# deploying to pages, copying file coverage_badge.png to pages repo
# primary purpose is to deploy badges for all subfolders in key-protect
#--  ------------ deploying pages, badges ------------ 
git clone -b $PAGES_BRANCH https://vikas-garud:$GIT_TOKEN@github.com/vikas-garud/vikas-garud.github.io.git deploypages
cd deploypages
git config --global user.name "vikas-garud"
git config --global user.email "vg9288@gmail.com"

touch abdf.asdf
git status
git add ./
git commit -m "Travis build $TRAVIS_BUILD_NUMBER , deploy coverage pages"
git push origin
#--  ------------ END deploying pages, badges ------------ 
