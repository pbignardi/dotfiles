#!/usr/bin/env bash
# 
## Author: Paolo Bignardi
## Github: pbignardi
##
## May 2024
##
## Create a backup of the Documents directory to Google Drive and OneDrive

NOW=$(date +"%d-%m-%Y@%H%M")
DIR="Documents"
SOURCE=$HOME
if [[ $1 == "--gdrive" ]]; then
	DEST="gdrive"
fi
if [[ $1 == "--onedrive" ]]; then
	DEST="onedrive"
fi
if [[ $2 == "--dry-run" ]]; then
	DRYRUN="--dry-run"
fi

rclone sync $SOURCE/$DIR $DEST:Backups/latest/$DIR --fast-list --drive-chunk-size=4M --progress -v $DRYRUN --backup-dir $DEST:Backups/back/$NOW/$DIR
