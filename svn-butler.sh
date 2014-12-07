#!/usr/bin/env bash

# Ticker configuration
TICKER_SVN_COMMITS_MINUTES=1
TICKER_SVN_UP_MINUTES=32

# SVN repo informations
SVN_TMP_DIR="svn_butler_tmp"

# Git repo informations
GIT_BRANCH_NAME="master"
GIT_REPOSITORY_DIR="restful"
GIT_REPOSITORY_URL="https://github.com/itadakimas/etna-2-restful.git"

# And...action !
echo -e "\n#### SVN BUTLER [ON] ####\n"
svn up
if [ -d $SVN_TMP_DIR ]; then
    echo -e "[DEBUG]\tRemoves old temporary directory"
    rm -rf $SVN_TMP_DIR
fi
echo -e "[DEBUG]\tCreates temporary directory"
mkdir -p "$SVN_TMP_DIR/$GIT_REPOSITORY_DIR"
echo -e "[INFO]\tInitializes Git repository cloning\n"
git clone $GIT_REPOSITORY_URL "$SVN_TMP_DIR/$GIT_REPOSITORY_DIR"
cd "$SVN_TMP_DIR/$GIT_REPOSITORY_DIR"
GIT_FIRST_COMMIT=$(git rev-list $GIT_BRANCH_NAME | tail -1)
GIT_LAST_COMMIT=$(git rev-list --reverse $GIT_BRANCH_NAME | tail -1)
git checkout $GIT_FIRST_COMMIT
cd ../../
svn add --depth infinity $SVN_TMP_DIR
svn commit -m "first commit"
cd "$SVN_TMP_DIR/$GIT_REPOSITORY_DIR"
echo -e "\n[INFO]\tTimer start !\n"
TICKER_MINUTES=0
TICKER_SECONDS=0
TICKER_START_TIMESTAMP=$(date +%s)
while true; do
    sleep 1;
    TICKER_CURRENT_TIMESTAMP=$(date +%s)
    TICKER_SECONDS=$((TICKER_SECONDS + 1))
    SECONDS=$(( (TICKER_CURRENT_TIMESTAMP - TICKER_START_TIMESTAMP) ))
    MINUTES=$((SECONDS / 60))
    if ((MINUTES > TICKER_MINUTES)); then
        TICKER_MINUTES=$((TICKER_MINUTES + 1))
        TICKER_SECONDS=0
        if !((MINUTES % TICKER_SVN_UP_MINUTES)); then
            svn up
        fi
        if !((MINUTES % TICKER_SVN_COMMITS_MINUTES)); then
            GIT_NEXT_COMMIT=$(git rev-list --topo-order HEAD..$GIT_LAST_COMMIT | tail -1)
            GIT_NEXT_COMMIT_MSG=$(git rev-list --topo-order --pretty=oneline --abbrev-commit HEAD..$GIT_LAST_COMMIT | tail -1 | cut -d" " -f 2-)
            git checkout $GIT_NEXT_COMMIT
            GIT_DIFF_ARRAY=$(git diff --name-status HEAD^ HEAD)
            GIT_DIFF_ARRAY_INDEX=0
            for value in $GIT_DIFF_ARRAY; do
                if !((GIT_DIFF_ARRAY_INDEX % 2)); then
                    GIT_DIFF_STATUS=$value
                else
                    GIT_DIFF_FILE=$value
                    echo "- status: $GIT_DIFF_STATUS | file: $GIT_DIFF_FILE"
                    if [ "$GIT_DIFF_STATUS" == "A" ]; then
                        echo "svn add --parents $GIT_DIFF_FILE"
                        # svn add --parents "$GIT_DIFF_FILE"
                    elif [ "$GIT_DIFF_STATUS" == "D" ]; then
                        echo "svn rm $GIT_DIFF_FILE"
                        # svn rm "$GIT_DIFF_FILE"
                    fi
                fi
                GIT_DIFF_ARRAY_INDEX=$((GIT_DIFF_ARRAY_INDEX + 1))
            done
            echo "-- commit: $GIT_NEXT_COMMIT_MSG"
            # svn commit -m "$GIT_NEXT_COMMIT_MSG"
        fi
    fi
    echo -e "[DEBUG]\tActive from $TICKER_MINUTES minute(s) and $TICKER_SECONDS second(s)"
done
