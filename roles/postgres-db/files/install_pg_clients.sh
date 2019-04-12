#!/bin/bash
#==============================================================================
# Copyright (c) 2018 Amigos Library Services
# Project Manager: Christine Peterson <peterson@amigos.org>
# Programmer: Robert L. Williams <williams@amigos.org>
# All rights reserved. For any commercial use, inquire at <support@amigos.org>.
#------------------------------------------------------------------------------
# Purpose: 
#   This script installs postgresql utilities matching server version
#==============================================================================

# Requires version from server (9.5, 9.6, 10) and the RedHat/CentOS version as
# CLI parameters
PG_VERSION=$1
OS_VERSION=$2
ADMIN_USER=$3
DOWNLOAD_PATH="https://download.postgresql.org/pub/repos/yum/$PG_VERSION/redhat/rhel-$OS_VERSION-x86_64"
echo "Path/package to download: $DOWNLOAD_PATH"

# Capture current directory and move temporarily to admin's home directory
CURR_DIR=$(pwd)
mkdir -p /home/$ADMIN_USER/temp
cd /home/$ADMIN_USER/temp

# Download RedHat Postgres package list (by version) and parse for latest RPM package
curl -s $DOWNLOAD_PATH/ | grep "pgdg-centos" | awk '{printf "%s\n", $3}' > centos_list.tmp

while read LINE; do
  LASTLINE=$LINE
done < centos_list.tmp
# Parse unnecessary HTML code to right of package name (bounded by '">')
T1=${LASTLINE%%\">*}
# Parse unnecessary HTML code to the left of package name (bounded by '="')
TEMPFILE=${T1##*=\"}
echo "RPM Repository Package: $TEMPFILE"
FLAT_VERSION="${PG_VERSION//./}"

# Clean up temp files
rm centos_list.tmp

# Download client utility package
echo "Download Postgres client utilities...."
wget -q $DOWNLOAD_PATH/$TEMPFILE
echo "Installing Postgres client repository...."
yum install -y --nogpgcheck ./$TEMPFILE
echo "Installing Postgres client utilities...."
yum install -y --nogpgcheck postgresql$FLAT_VERSION

# Return to previous directory
cd $CURR_DIR
echo "Done."
