#!/bin/sh

# Script that will fetch data from sources that can then be used
# for indicator parsing.
# - PDF Reports
# - Blog Posts
# - Github Repos
# Author: Reuben Joseph <reubenej@gmail.com>
#
# Usage: fetch_data.sh
#
#
#=====================Message Colors=========================
FAIL=$(tput setaf 1) #red
PASS=$(tput setaf 2) #green
HEAD=$(tput setaf 5) #magenta
INFO=$(tput setaf 6) #cyan
END=$(tput sgr0)   #ends color
#============================================================

WORKBENCH_ROOT=$1
DATA_DIR="$WORKBENCH_ROOT/data"


usage()
{
	printf "${FAIL}Usage : fetch_data.sh [WORKBENCH_ROOT]${END}\n"
	printf "${FAIL}WORKBENCH_ROOT is the full path to the cti_workbench folder${END}\n"
	exit
}

if [ -z $1 ];
then
	usage
fi

echo "Fetching data"
cd $WORKBENCH_ROOT

# Download PDF reports
scripts/download_APTNotes.py -d $DATA_DIR/pdf_reports

# Download Blog Posts
scripts/blog.py
wget  -i $WORKBENCH_ROOT/conf/rssfeeds.txt -P $DATA_DIR/data/blogs

# Download Github data

