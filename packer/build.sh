#!/bin/bash

set -e

BUILDS_DIR="$(realpath "$(dirname "$0")")"
PREBUILD_LOG="${BUILDS_DIR}/prebuild.log"
build() {
	set +e
	pushd "${1}-packer" > /dev/null
	test -f build.err || \
		./build.sh > build.log 2>&1 || \
		touch build.err
	popd > /dev/null
}

init_prebuild() {
	date > $PREBUILD_LOG
}

prebuild_command() {
	echo "$@" >> $PREBUILD_LOG
	$@ 2>&1 >> $PREBUILD_LOG && rc=$? || rc=$?
	if [ $rc -ne 0 ]; then
		echo PREBUILD ERROR
		tail $PREBUILD_LOG
		exit 1
	fi
}

pushd "$BUILDS_DIR" > /dev/null
init_prebuild
prebuild_command wget -q https://git.local -O -
prebuild_command ping -c 1 deb.debian.org
build debian
prebuild_command wget -q https://git.local -O -
prebuild_command ping -c 1 us.archive.ubuntu.com
build ubuntu
popd > /dev/null


ls -1 ${BUILDS_DIR}/*-packer/build.err 2>/dev/null && exit 1 || exit 0
