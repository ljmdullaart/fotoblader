#!/bin/bash
#INSTALL@ /usr/local/bin/make_fotoblader

COLS=3
TMP=/tmp/fotoblader.$$.$RANDOM
base=$(basename `pwd`)

output(){
	if [ -d www ] ; then
		echo $* >> www/fotoblader.html
	fi
	if [ -d html ] ; then
		echo $* >> html/fotoblader.htm
	fi
}

#                                 _     _      
#  _ __  _ __ ___  __ _ _ __ ___ | |__ | | ___ 
# | '_ \| '__/ _ \/ _` | '_ ` _ \| '_ \| |/ _ \
# | |_) | | |  __/ (_| | | | | | | |_) | |  __/
# | .__/|_|  \___|\__,_|_| |_| |_|_.__/|_|\___|
# |_|                                          

if [ ! -d images/blader ] ; then
	mkdir -p images/blader
fi

if [ -d www ] ; then
cat > www/fotoblader.html << EOF
<!DOCTYPE HTML>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
EOF
if [ -f stylesheet.css ] ; then
	echo "<LINK HREF=\"stylesheet.css\" REL=\"stylesheet\" TYPE=\"text/css\">" >> www/fotoblader.html
	cp stylesheet.css www
fi
cat >> www/fotoblader.html << EOF
<title>$base</title>
</head>
<body>
<div class=header>
EOF
cat photoheader >> www/fotoblader.html
cat >> www/fotoblader.html << EOF
</div>
<p>
EOF
fi

#                              _                            _ _     _   
#  _ __   __ _ _ __ ___  ___  (_)_ __ ___   __ _  __ _  ___| (_)___| |_ 
# | '_ \ / _` | '__/ __|/ _ \ | | '_ ` _ \ / _` |/ _` |/ _ \ | / __| __|
# | |_) | (_| | |  \__ \  __/ | | | | | | | (_| | (_| |  __/ | \__ \ |_ 
# | .__/ \__,_|_|  |___/\___| |_|_| |_| |_|\__,_|\__, |\___|_|_|___/\__|
# |_|                                            |___/    

output '<table class="phototable">'
prev=none
col=0

videofile(){
	ext=$1
	output "        <td class=\"photocell\"><a href=\"images/fullsize/$c.html\"><img src=\"$f\"><br>video</a></td>"
	echo "<html>" > images/fullsize/$c.html
	echo "<head>" >> images/fullsize/$c.html
	echo "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">" >> images/fullsize/$c.html
	echo "<LINK HREF=\"stylesheet.css\" REL=\"stylesheet\" TYPE=\"text/css\">" >> images/fullsize/$c.html
	echo "<title>$b</title>" >> images/fullsize/$c.html
	echo "</head>" >> images/fullsize/$c.html

	echo "	<body>" >> images/fullsize/$c.html
	echo "		<video  controls>" >> images/fullsize/$c.html
	echo "			<source src=\"$c.$ext\">" >> images/fullsize/$c.html
	echo "			Sorry, no video." >> images/fullsize/$c.html
	echo "		</video>" >> images/fullsize/$c.html
	echo "	</body>" >> images/fullsize/$c.html
	echo "</html>" >> images/fullsize/$c.html
	if [ -f stylesheet.css ] ; then
		cp stylesheet.css images/fullsize
	fi
}

name=(images/medium/*)
len=${#name[@]}
max=$((len-1))

for i in ${!name[@]} ; do 
	echo $i ${name[$i]}
	if [ $i -eq 0 ] ; then
		pr=$max
		nxt=1
	elif [ $i -eq $max ] ; then
		pr=$((max-1))
		nxt=0
	else
		pr=$((i-1))
		nxt=$((i+1))
	fi
	f=${name[$i]}
	fn=${name[$nxt]}
	fp=${name[$pr]}
	b=$(basename $f)
	c=${b%.*}
	bn=$(basename $fn)
	cn=${bn%.*}
	bp=$(basename $fp)
	cp=${bp%.*}
	display -geometry +10+10 images/medium/$b &
	tokill=$!
	sleep 0.1
	if [ $prev != none ] ; then
		kill $prev
	fi
	if [ $col = 0 ] ; then
		output '    <tr class="photorow">'
	fi
	#if [ -f  images/fullsize/$c.mov ] ; then videofile mov
	#elif [ -f  images/fullsize/$c.MOV ] ; then videofile MOV
	#elif [ -f  images/fullsize/$c.mp4 ] ; then videofile mp4
	#elif [ -f  images/fullsize/$c.MP4 ] ; then videofile MP4
	#elif [ -f  images/fullsize/$c.avi ] ; then videofile avi
	#elif [ -f  images/fullsize/$c.AVI ] ; then videofile AVI
	#else output "        <td class=\"photocell\"><a href=\"images/blader/$c.html\"><img src=\"$f\"></a></td>"
	#fi
	output "        <td class=\"photocell\"><a href=\"images/blader/$c.html\"><img src=\"images/thumb/$b\"></a></td>"
	col=$((col+1))
	if [ $col = $COLS ] ; then
		col=0
		output "    </tr>"
	fi
	sleep 0.3
	prev=$tokill
	imgsize=$(imageinfo $f)
	xsize=${imgsize%x*}
	ysize=${imgsize#*x}
	cat > images/blader/$c.html << EOF
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<LINK HREF="stylesheet.css" REL="stylesheet" TYPE="text/css">
<title>Untitled</title>
</head>
<body>
<div  style="text-align:center">
<img src="../medium/$b" usemap=#map1  alt="map">
<map name=map1>
<area shape=rect coords="0,0,$((xsize/3)),$ysize" href="$cp.html" alt="prev">
<area shape=rect coords="$((2*xsize/3)),0,$xsize,$ysize" href="$cn.html" alt="next">
<area shape=rect coords="$((xsize/3)),0,$((2*xsize/3)),$((ysize/3))" href="../../fotoblader.html" alt="next">
</map>
</div>
EOF

done

if [ $prev != none ] ; then
	kill $prev
fi
if [ $col != 0 ] ; then
	output "    </tr>"
fi

output '</table>'

cp  www/fotoblader.html .

rm -rf $TMP
