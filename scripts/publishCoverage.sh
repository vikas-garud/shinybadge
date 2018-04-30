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

GIT_TOKENNEW=$GIT_TOKEN

echo "PAGES_BRANCH      :"$PAGES_BRANCH
echo "GIT_TOKEN         :"$GIT_TOKENNEW
echo "TRAVIS_REPO_SLUG  :"$TRAVIS_REPO_SLUG
echo "TRAVIS_BRANCH     :"$TRAVIS_BRANCH
echo "TRAVIS_BUILD_DIR  :"$TRAVIS_BUILD_DIR

# clone and prepare gh-pages branch
#git clone -b $PAGES_BRANCH https://vikas-garud:$GIT_TOKENNEW@github.com/$TRAVIS_REPO_SLUG.git tmp
git clone -b $PAGES_BRANCH git@github.com:vikas-garud/shinybadge.git tmp
#git clone -b master git@github.com:vikas-garud/shinybadge.git tmp
#git clone -b master https://vikas-garud:198fa57627b3f612bcb9efe9f8b001a37371c38e@github.com/vikas-garud/shinybadge.git tmp
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
git config --global user.name "vikas-garud"
git config --global user.email "vg9288@gmail.com"
git status
#git add -A
git add ./
git commit -m "Coverage result .....for commit $CURRENT_COMMIT from build $TRAVIS_BUILD_NUMBER"
#git commit -m "Coverage result ...for commit CURRENT_COMMIT from build TRAVIS_BUILD_NUMBER"
#git push origin
git push origin master

#deploying to pages, copying file coverage_badge.png to pages



curl -H 'Authorization: token $GIT_TOKENPAGES' https://github.com/vikas-garud/vikas-garud.github.io.git
#git clone -b $PAGES_BRANCH https://vikas-garud:$GIT_TOKENNEW@github.com/vikas-garud/vikas-garud.github.io.git deploypages
git clone -b $PAGES_BRANCH git@github.com:vikas-garud/vikas-garud.github.io.git deploypages
#git clone -b master git@github.com:vikas-garud/vikas-garud.github.io.git deploypages

#git clone -b master https://vikas-garud:6f4cdb1334a865e9ed7cad397e0c9a6d32b97352@github.com/vikas-garud/vikas-garud.github.io.git deploypages

cd deploypages
git config --global user.name "vikas-garud"
git config --global user.email "vg9288@gmail.com"

#git remote -v 
#git remote remove origin 
#git remote add origin git@github.com:vikas-garud/vikas-garud.github.io.git

#git remote add origin https://vikas-garud:$GIT_TOKEN@github.com/vikas-garud/vikas-garud.github.io.git


#git remote set-url origin git@github.com:vikas-garud/vikas-garud.github.io.git
#git remote add origin https://github.com:vikas-garud/vikas-garud.github.io.git

touch abdf.asdf
git status
git add ./
#git add $FILENAME_TO_DEPLOY....
git commit -m "Travis build $TRAVIS_BUILD_NUMBER , deply coverage pages"
#git push --set-upstream origin master
git push origin master

