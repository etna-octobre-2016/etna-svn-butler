#!/usr/bin/env bash

# Ticker configuration
TICKER_SVN_COMMITS_MINUTES=2
TICKER_SVN_UP_MINUTES=32

# SVN repo informations
SVN_TMP_DIR="svn_butler_tmp"

# Git repo informations
GIT_BRANCH_NAME="master"
GIT_REPOSITORY_DIR="restful"
GIT_REPOSITORY_URL="https://github.com/itadakimas/etna-2-restful.git"

# And...action !
echo -e "\n#### SVN BUTLER [ON] ####\n"
# svn up
if [ -d $SVN_TMP_DIR ]; then
    echo -e "[DEBUG]\tRemoves old temporary directory"
    rm -rf $SVN_TMP_DIR
fi
echo -e "[DEBUG]\tCreates temporary directory"
mkdir $SVN_TMP_DIR && cd $SVN_TMP_DIR
echo -e "[INFO]\tInitializes Git repository cloning\n"
git clone $GIT_REPOSITORY_URL $GIT_REPOSITORY_DIR && cd $GIT_REPOSITORY_DIR
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

        # if ((MINUTES > 0)); then

            if !((MINUTES % TICKER_SVN_UP_MINUTES)); then

                # svn up

                echo "SVN UP !!!!"
            fi
            if !((MINUTES % TICKER_SVN_COMMITS_MINUTES)); then
                for commit in $(git rev-list --reverse $GIT_BRANCH_NAME)
                do
                    echo "tour de boucle"
                    echo $commit
                done
            fi
        # fi
    fi
    echo -e "[DEBUG]\tActive from $TICKER_MINUTES minute(s) and $TICKER_SECONDS second(s)"
done
