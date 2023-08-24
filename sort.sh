#!/bin/bash

declare -A lines
git_dir="/home/remi/Documents/plateforme"
sorted_filename="sorted_$1"

echo '' > $sorted_filename

for line in $(cat $1); do
	timestamp=$(git --git-dir="$git_dir/.git" show $line --format="%at" -q)

	if [ "${lines[$timestamp]}" ]
	then
		echo "timestamp $timestamp already used for ${lines[$timestamp]} (tried to add $line)"
	fi

	lines[$timestamp]=$line
done

readarray -t sorted < <(printf '%s\0' "${!lines[@]}" | sort -zn | xargs -0n1)

for timestamp in "${sorted[@]}"; do
	echo "${lines[$timestamp]}" >> $sorted_filename
done
