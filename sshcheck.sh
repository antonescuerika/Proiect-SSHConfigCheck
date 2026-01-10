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

optiuni=$(grep '^[A-Za-z]' "$fisier" | awk '{print $1}' | sort)

optiuni_duplicate=$(echo "$optiuni" | uniq -d)

if [ -z "$optiuni_duplicate" ]; then
    echo "Nu au fost gasite optiuni duplicate"
else
    echo "Au fost gasite optiuni duplicate. Acestea sunt:"
    echo "$optiuni_duplicate"
fi

verificare() {
    optiune=$1
    recomandat=$2
    mesaj=$3

    setare_curenta=$(grep "^$optiune" "$fisier" | awk '{print $2}' | tail -n 1)

    if [ -z "$setare_curenta" ]; then
        echo "$optiune nu este setat."
    elif [ "$setare_curenta" != "$recomandat" ]; then
        echo "$mesaj"
    else
        echo "$optiune setat corect"
    fi
}

verificare "PermitRootLogin" "no" \
	"Accesul root prin SSH trebuie dezactivat pentru securitate"

verificare "PasswordAuthentication" "no" \
	"Autentificarea prin parola este vulnerabila,se recomanda folosirea cheilor"

verificare "X11Forwarding" "no" \
	"Redirectionarea X11 poate fi exploatata"

if ! grep -q '^AllowUsers' "$fisier"; then
	echo "Nu există lista AllowUsers, accesul este permis oricărui utilizator local."
else
	echo "Lista AllowUsers configurata"
fi


protocol=$(grep -i '^Protocol' "$fisier" | awk '{print $2}')
if [ ! -z "$protocol" ] && [ "$protocol" != "2" ]; then
    echo "Protocolul 1 este nesigur, trebuie setat protocolul 2 "
else
    echo "Protocol 2 (implicit)"
fi

permisiuni=$(stat -c %a "$fisier")

if [ "$permisiuni" -gt 644 ]; then
	echo "Permisiuni prea permisive, se recomanda 600 sau 640."
else
	echo "Permisiuni adecvate"
fi
