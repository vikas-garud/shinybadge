#!/usr/bin/env bash
set -x
OLD_COVERAGE=0
COVERAGE=0
RESULT_MESSAGE=""

BADGE_COLOR=red
GREEN_THRESHOLD=85
YELLOW_THRESHOLD=50
PAGES_BRANCH="master"

FILENAME_TO_DEPLOY="coverage_badge.png"

COMMIT_RANGE=(${TRAVIS_COMMIT_RANGE//.../ })
CURRENT_COMMIT=${COMMIT_RANGE[1]}

echo "PAGES_BRANCH      :"$PAGES_BRANCH
echo "GIT_TOKEN         :"$GIT_TOKEN
echo "TRAVIS_REPO_SLUG  :"$TRAVIS_REPO_SLUG
echo "TRAVIS_BRANCH     :"$TRAVIS_BRANCH
echo "TRAVIS_BUILD_DIR  :"$TRAVIS_BUILD_DIR

# clone and prepare gh-pages branch
git clone -b $PAGES_BRANCH https://vikas-garud:$GIT_TOKEN@github.com/$TRAVIS_REPO_SLUG.git tmp
cd tmp

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
git config user.name "vikas-garud"
git config user.email "vg9288@gmail.com"
git status
git add -A
git commit -m "Coverage result for commit $CURRENT_COMMIT from build $TRAVIS_BUILD_NUMBER"
git push origin

#deploying to pages, copying file coverage_badge.png to pages

MYPAGES_TOKEN=$GIT_TOKENPAGES

curl -H 'Authorization: token $MYPAGES_TOKEN' https://github.com/vikas-garud/vikas-garud.github.io.git
git clone -b $PAGES_BRANCH https://github.com/vikas-garud/vikas-garud.github.io.git deploypages

cd deploypages
git config user.name "vikas-garud"
git config user.password $MYPAGES_TOKEN
git config user.email "vg9288@gmail.com"
git status
git add $FILENAME_TO_DEPLOY
git commit -m "deply coverage pages"
git push origin
