#!/bin/sh

# Script to install and set up the workbench
# Author: Reuben Joseph <reubenej@gmail.com>
#
# Usage: scripts/install.sh
#

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

install_dependencies()
{
	sudo pip3 install -r requirements.txt
}
