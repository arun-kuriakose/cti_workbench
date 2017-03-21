#!/bin/sh

# Script to install and set up the workbench
# Author: Reuben Joseph <reubenej@gmail.com>
#

#=====================Message Colors=========================
FAIL=$(tput setaf 1) #red
PASS=$(tput setaf 2) #green
HEAD=$(tput setaf 5) #magenta
INFO=$(tput setaf 6) #cyan
END=$(tput sgr0)   #ends color
#============================================================

INSTALLATION_DIR=$1
USER=`whomai`

usage()
{
	printf "${FAIL}Usage : install.sh [INSTALLATION_DIR]${END}\n"
	printf "${FAIL}INSTALLATION_DIR is the full path to the cti_workbench folder${END}\n"
	exit
}

check()
{
    printf "${INFO}Testing Computer's Architecture${END}\n"
    ARCH=$(uname -m | sed 's/x86_//;s/amd//;s/i[3-6]86/32/')
    if [ "$ARCH" -ne '64' ];
    then
        printf "${FAIL}Non 64-bit system detected${END}\n"
        exit
    else
        printf "${PASS}Architecure 64-bit Passed${END}\n"
    fi
    printf "${INFO}Testing the distro type${END}\n"
    # Using lsb-release because os-release not available on Ubuntu 10.04
    if [ -f /etc/redhat-release ];
    then
        OS=$(cat /etc/redhat-release | sed 's/ [Enterprise|release|Linux release].*//')
        VER=$(cat /etc/redhat-release | sed 's/.*release //;s/ .*$//')
        #Redhat/CentOS release version
        if [ "$OS" != 'Fedora' ]
        then
            REL=$(echo $VER | sed 's/.[0-9].[0-9]*//;s/.[0-9]$//')
            if [ "$REL" -lt '7' ];
            then
                #change for RHEL/CentOS < Release 7 
                PIP='pip2.7'
            fi
         fi
    elif command -v lsb_release >/dev/null 2>&1
    then
        OS=$(lsb_release -is)
        VER=$(lsb_release -rs)
    else
        OS=$(uname -s)
        VER=$(uname -r)
    fi
    OS="$(echo "$OS" | tr "[:upper:]" "[:lower:]")"
    VER="$(echo "$VER" | tr "[:upper:]" "[:lower:]")"
}

install_ubuntu()
{
	printf "${INFO} Beginning installation of ioc_parser dependencies${END}\n"
	
	pip2 install -r requirements/python2.txt
	printf "${PASS} Installation of ioc_parser dependencies completed..${END}\n"
	
	printf "${INFO} Beginning installation of other dependencies${END}\n"
	pip3 install -r requirements/python3.txt
	printf "${PASS} Dependencies installed${END}\n"
	printf "${INFO} Beginning installation of IOC Parser ${END}\n"
	pip2 install ioc_parser
	printf "${PASS} IOC Parser installed ${END}\n"
}


create_dirs()
{
	printf "${INFO}Creating directory structure${END}\n"
	mkdir -p $INSTALLATION_DIR/indicators
	mkdir -p $INSTALLATION_DIR/data/pdf_reports
	mkdir -p $INSTALLATION_DIR/data/blogs
	mkdir -p $INSTALLATION_DIR/data/github
	printf "${INFO}Settings Permissions${END}\n"
	chown $USER:$USER -R $INSTALLATION_DIR/data/
	chown $USER:$USER -R $INSTALLATION_DIR/indicators
	printf "${PASS}Directory Structure created${END}\n"
}

# Beginning of script
if [ -z $1 ];
then
	usage
fi

check
if [ "$OS" = 'ubuntu' ] || [ "$OS" = 'linuxmint' ]
then
	printf "${PASS} Ubuntu system detected!${END}\n"
	install_ubuntu;create_dirs
fi

