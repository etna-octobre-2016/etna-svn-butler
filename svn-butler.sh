#!/usr/bin/env bash

# Ticker configuration
TICKER_SVN_UP_MINUTES=32

# SVN repo informations
SVN_TMP_DIR="svn_butler_tmp"

# Git repo informations
GIT_BRANCH_NAME="master"
GIT_REPOSITORY_URL="https://github.com/itadakimas/etna-2-restful.git"

# Deletes existing temp directory
if [ -d $SVN_TMP_DIR ]; then
    rm $SVN_TMP_DIR
fi

# And...action !
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

        if ((MINUTES > 0)) && !((MINUTES % TICKER_SVN_UP_MINUTES)); then
            svn up &
            wait %1
        fi
    fi
    echo "- minutes: $TICKER_MINUTES      seconds: $TICKER_SECONDS"
done

# for commit in $(git rev-list --reverse $GIT_BRANCH_NAME)
# do
#     echo "tour de boucle"
#     echo $commit
# done
