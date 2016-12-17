#!/bin/bash

#preset variables, exec redirects everything to outputfile
ROOT="./"
LABEL="foldername.txt"
MAXDEPTH=5
DEPTH=0
HTTP="http://www.somewhere.com"
exec > "$ROOT/Menu-test.html"

#functions for indentation, definition and printing tags
LI="<LI><SPAN class=plus><P>+</P></SPAN>"
ULecho() { Dent ; echo "<UL class='navlist$DEPTH'>"                    ;}
LIecho() { echo -n "$LI<A href='$HTTP${1/$ROOT/}/'>$( cat $LABEL)</A>" ;}
Indent() { for (( i=1 ; i < DEPTH ; ++i )); do Dent; Dent; done ; Dent ;}
Dent()   { echo -n "    "                                              ;}
LIstrt() { Indent; LIecho "$( pwd )" ; echo "</LI>"                    ;}
ULstrt() { Indent; LIecho "$( pwd )" ; echo; Indent; ULecho            ;}
TAGend() { Indent ; Dent ; echo "</UL>"; Indent; echo "</LI>"          ;}
DEPchk() { [ "$DEPTH" -gt "0" ] && ${1} ;}

:> $ROOT/$LABEL

Dive()
{
    local DPATH="$1"


    if [ "$( echo */$LABEL )" = "*/$LABEL" ] || [ $DEPTH -gt $MAXDEPTH ]
    then
        DEPchk LIstrt
    else
        DEPchk ULstrt
        for DPATH in */$LABEL
        do
            cd ${DPATH%/*}
              (( ++DEPTH ))
            Dive "$DPATH"
              (( --DEPTH ))
            cd ..
        done
        DEPchk TAGend
    fi
}

cd $ROOT
Dive "$ROOT"
echo "</UL>"
