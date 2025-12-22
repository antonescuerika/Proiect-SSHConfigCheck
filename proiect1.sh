#!/bin/bash

fisier="$1"

if [ -z "$fisier" ]; then
	echo "Fisierul nu a fost dat ca argument"
	exit 1
fi

if [ ! -e "$fisier" ]; then
	echo "Fisierul nu exista"
	exit 1
fi

if [ ! -r "$fisier" ]; then
	echo "Fisierul nu are permisiuni de citire"
	exit 1
fi
