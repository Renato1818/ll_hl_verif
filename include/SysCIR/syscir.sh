#!/bin/bash

USAGE="usage: $0 -i input.ast.xml [-o output.syscir] [-b] [-a \"additional syscir args\"]

If -b is set, the script runs the *.class binaries instead of the jar file.
Example: $0 -i input.ast.xml -a \"-h\" # print SYSCIR's help msg"
TARGET="runjar" # ant target
ARGS=""

while getopts "i:o:ba:" OPTIONS; do
	case $OPTIONS in
		i)
			INPUT_FILE=`readlink -f $OPTARG`
			ARGS="${ARGS} -i ${INPUT_FILE}"
			;;
		o)
			OUTPUT_FILE=`readlink -f $OPTARG`
			ARGS="${ARGS} -o ${OUTPUT_FILE}"
			;;
		b)
			TARGET="run"
			;;
		a)
			ARGS="${ARGS} $OPTARG"
			;;
		\?)
			echo "$USAGE"
			exit 1;;
	esac
done
if [[ "${INPUT_FILE}" == "" ]]; then
	echo "$USAGE"
	exit 1
fi

CMD="ant -f ${SYSCIR_HOME}/build.xml ${TARGET} -Dargs=\"${ARGS}\""
echo $CMD
eval $CMD
