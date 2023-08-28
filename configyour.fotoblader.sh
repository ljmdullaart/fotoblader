#!/bin/bash
#INSTALL@ /usr/local/bin/configyour.fotoblader

WD=`pwd`
BASE=`basename $WD`
LOG=configyour.log
echo "Configyour.fotoblader starting" >>$LOG
if [ -x /usr/local/bin/my_banner ] ; then
    banner=/usr/local/bin/my_banner
else
    banner=banner
fi

not_applicable(){
	$banner fotoblader n/a >> Makefile
	echo "No 'FOTOBLADER' in imagelist"
	echo "No 'FOTOBLADER' in imagelist" >>$LOG
	echo "tag/upload.fotoblader: |tag" >> Makefile
	echo "	touch tag/upload.fotoblader" >> Makefile
	echo "tag/fotoblader: |tag" >> Makefile
	echo "	touch tag/fotoblader" >> Makefile
	echo "tag/clean.fotoblader: |tag" >> Makefile
	echo "	touch tag/clean.fotoblader" >> Makefile
	echo "Not applicable" >>$LOG
	echo "Configyour.fotoblader finishing" >>$LOG
	exit 0
}


# Check if applicable
if [ ! -f imagelist ] ; then
	not_applicable
	echo "No imagelist found" >>$LOG
fi
if grep -q FOTOBLADER imagelist ; then
	$banner fotoblader >> Makefile
	echo "FOTOBLADER found in imagelist" >>$LOG
else
	not_applicable
fi

NOW=`date`

$banner fotoblader >> Makefile
bladerhtml=$(sed -n 's/TYPE *//p' imagelist | head -1)

NOW=`date`
mkdir -p www

if [ $bladerhtml = FOTOBLADER ] ; then
	echo "tag/fotoblader: www/fotoblader.html www/stylesfb.css www/index.html  html/fotoblader.htm |tag" >> Makefile
else
	echo "tag/fotoblader: www/fotoblader.html www/stylesfb.css html/fotoblader.htm |tag" >> Makefile
fi


echo "	touch tag/fotoblader" >> Makefile
echo "html/fotoblader.htm: tag/photo /usr/local/bin/make_fotoblader photoheader" >> Makefile
echo "	make_fotoblader" >> Makefile
echo "www/fotoblader.html: tag/photo /usr/local/bin/make_fotoblader photoheader" >> Makefile
echo "	make_fotoblader" >> Makefile
echo "www/stylesfb.css: stylesfb.css" >> Makefile
echo "	cp stylesfb.css www/stylesfb.css" >> Makefile
echo "stylesfb.css:" >> Makefile
echo "	touch stylesfb.css" >> Makefile
if [ "$bladerhtml" =  'FOTOBLADER' ] ; then
    echo "www/index.html: www/fotoblader.html" >> Makefile
    echo "	cp www/fotoblader.html www/index.html" >> Makefile
fi

echo "tag/clean.fotoblader: |tag" >> Makefile
echo "	- rm -f fotoblader.html" >> Makefile
echo "	- rm -f www/fotoblader.html" >> Makefile
echo "	- rm -f html/fotoblader.htm" >> Makefile
echo "	- rm -rf tag/fotoblader.*" >> Makefile
echo "	touch tag/clean.fotoblader" >> Makefile
echo "Configyour.fotoblader finishing" >>$LOG
