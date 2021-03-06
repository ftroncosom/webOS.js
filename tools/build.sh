#!/bin/bash

TOOLS="$(cd `dirname "$0"`; pwd)"
WEBOSJS="`dirname "$TOOLS"`"
SRC="$WEBOSJS/src"
OUTPUT="$WEBOSJS/webOS.js"
STATUS=0

# functions
writeFile() {
	# Parameters: srcFilepath, srcFilename
	if [ $STATUS -eq 0 ] ; then
		echo "// $2" >> "$OUTPUT"	
		node "$WEBOSJS/node_modules/uglify-js/bin/uglifyjs" "$1" -e -v >> "$OUTPUT" 2>&1
		echo " " >> "$OUTPUT"
		echo " " >> "$OUTPUT"
		RET=$?
		if [ $RET -ne 0 ] ; then
			echo " "
			echo "** Error processing $2 **"
			STATUS=$RET
		fi
	fi
}

# mainline

if command -v node >/dev/null 2>&1; then
	if [ ! -f "$WEBOSJS/node_modules/uglify-js/bin/uglifyjs" ]  ; then
		echo "Installing prerequisite UglifyJS..."
		if [ ! -e "$WEBOSJS/node_modules" ] ; then
			mkdir -p "$WEBOSJS/node_modules"
		fi
		npm install uglify-js --prefix "$WEBOSJS/node_modules"
		echo " "
	fi
	
	
	echo "Building webOS.js..."
	
	if [ "$1" == "--api" ] ; then
		node "$TOOLS/util/util.js" "$SRC" "$OUTPUT"
		STATUS=$?
	else
		echo "window.webOS = window.webOS || {};" > "$OUTPUT"
		echo " " >> "$OUTPUT"

		# device.js and platform.js have priority, so process them before the other files
		if [ -f "$SRC/device.js" ] ; then
			writeFile "$SRC/device.js" device.js
		fi
		if [ -f "$SRC/platform.js" ] ; then
			writeFile "$SRC/platform.js" platform.js
		fi

		# Process all the rest of the javascript files in the src directory
		for f in "$SRC"/*.js ;	do
			if [ "$f" != "$SRC/device.js" ] ; then
				if [ "$f" != "$SRC/platform.js" ] ; then
					writeFile "$f" "$(basename "$f")"
				fi
			fi
		done
	fi
	
	if [ $STATUS -eq 0 ] ; then
		echo "Successfully built to $OUTPUT"
	fi
	exit $STATUS
else
	echo "No node found in path"
	exit 1
fi
