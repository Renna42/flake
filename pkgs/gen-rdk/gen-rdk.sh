#!/bin/bash

# -----------------------------------------------------------------------------
#
#	App Title:		Generate RDK
#	Author:			Jared Breland <jbreland@legroom.net>
#	Homepage:		http://www.legroom.net/software
#	License:		GNU Lesser General Public License, v3.0
#						http://www.gnu.org/licenses/lgpl.html
#
#	Script Function:
#		Automate extraction of RDK and VID from blu-ray, using MakeMKV
#
#	Instructions:
#		Run 'gen-rdk.sh -h' for usage information; without any CLI parameters,
#			it will begin ripping the blu-ray inserted in /dev/sr0
#
#	Requirements:
#		The following programs must be installed and available:
#		makemkvcon (https://www.makemkv.com/)
#			used to extract discatt.dat from blu-ray
#		hexdump, from util-linux (https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/)
#			used to extract VID and RDK
#		udisksctl, from udisks (https://www.freedesktop.org/wiki/Software/udisks/)
#			used to mount/unmount blu-ray
#		openssl (https://www.openssl.org/)
#			used to generate checksums
#
#	Release History:
#		1.0 (11/26/2022):
#			Initial release
#
# -----------------------------------------------------------------------------

# Static variables
readonly VERSION='1.0'
readonly TITLE='Generate RDK'
readonly PROG=$(basename $0)
readonly PROGDIR=$(dirname $0)

# Setup environment
BRDEV=/dev/sr0
AACS=~/.cache/aacs
TEMPDIR=$(mktemp -u -p /tmp -t genrdk-XXXXX)

# Function to display correct usage information
function warning() {
  echo -e "Usage: ${PROG} [-d <dev>]"
  echo -e "Automate extraction of blu-ray RDK and VID, using MakeMKV\n"
  echo -e "Options:"
  echo -e "  -d  device to use for ripping; eg., /dev/sr0"
  echo -e "         if not specified, defaults to ${BRDEV}"
  exit
}

# Function to determine if variable is an integer
function is_int() {
  return $(test "$1" -eq "$1" >/dev/null 2>&1)
}

# Function to verify required binaries
#	$@ = list of binaries
function bincheck() {
  for i in "$@"; do
    if [ -z "$(which "$1" 2>/dev/null)" ]; then
      cwarn "Error: cannot find the following binaries: ${1}"
      exit 1
    fi
    shift
  done
}

# Verify necessary binaries can be found
bincheck makemkvcon hexdump udisksctl openssl

# Process arguments
while [ $# -ne 0 ]; do
  if [ "$1" == "-h" -o "$1" == "--help" -o "$1" == "-?" ]; then
    warning
  elif [ "$1" == "-V" -o "$1" == "--version" ]; then
    echo "${TITLE} $VERSION"
    exit
  elif [ "$1" == "-d" ]; then
    shift
    if [ -b "$1" ]; then
      BRDEV="${1}"
    else
      cwarn -e "Error: '${1}' does not appear to be a valid blu-ray device\n"
      warning
    fi
  fi
  shift
done

# Get real drive path
TEMPDEV=$(readlink -e ${BRDEV})
if [ $? -ne 0 ]; then
  echo "Error: '${BRDEV}' does not appear to be a valid blu-ray device"
  exit 1
else
  BRDEV="${TEMPDEV}"
fi

# Identify drive label
OUTPUT="$(makemkvcon f --list | grep -A1 "${BRDEV}")"
if [ $(echo "${OUTPUT}" | wc -l) -ne 2 ]; then
  echo "Error: Unique device for '${BRDEV}' not found in makemkvcon output"
else
  BRNUM=$(echo "${OUTPUT}" | sed -ne 's/^0*\([0-9]\+\): dev.*$/\1/p')
  BRLABEL=$(echo "${OUTPUT}" | tail -n 1 | tr -d ' ')
fi

# Disable libredrive
export SDF_STOP=${BRLABEL}

# Create and validate temp directory
mkdir -p "${TEMPDIR}"
if [ $? -ne 0 ]; then
  echo "Error: Temp directory '${TEMPDIR}' could not be created"
  exit 1
fi

# Output summary before starting
echo "Properties:"
echo "Device    = ${BRDEV}"
echo "Label     = ${BRLABEL}"
echo "Disc num  = ${BRNUM}"
echo "Temp dir  = ${TEMPDIR}"

# Rip discatt.dat
#	Launch makemkvcon in background, wait for DAT file, then kill PID
echo -e "\nBegin discatt.dat extraction..."
DAT="${TEMPDIR}/discatt.dat"
makemkvcon backup disc:${BRNUM} ${TEMPDIR} &
CONPID=${!}
until [ -f "${DAT}" ]; do
  sleep 0.2
done
kill ${CONPID}

# Mount blu-ray
echo -e "\nMount blu-ray disc..."
OUTPUT="$(udisksctl mount -b ${BRDEV})"
BRPATH="$(echo "${OUTPUT}" | sed -e 's/^Mounted .* at \(.*\)$/\1/')"
if [ ! -d "${BRPATH}" ]; then
  echo "Error: Blu-ray could not be mounted"
  exit 1
else
  KEY="${BRPATH}/AACS/Unit_Key_RO.inf"
fi

# Get offset of and contents of VID
echo -e "\nExtract RDK and VID..."
#VIDOFFSET=$(LC_ALL=C grep -aobP "\x04\x00\x00\x80\x00\x00\x00\x10" "${DAT}" | tail -n 1 | cut -f1 -d:)
VIDOFFSET=$(LC_ALL=C grep -m1 -aobP "\x04\x00\x00\x80\x00\x00\x00\x10" "${DAT}" | cut -f1 -d:)
is_int "${VIDOFFSET}"
if [ $? -ne 0 ]; then
  echo "Error: VID could not be located."
  exit 2
fi
#echo "VID offset = '$VIDOFFSET'"
VID=$(hexdump -e '16/1 "%02x"' -s $((VIDOFFSET + 8)) -n 16 "${DAT}")
echo "VID     = '$VID'"

# Get offset of and contents of RDK
#RDKOFFSET=$(LC_ALL=C grep -aobP "\x04\x00\x00\x84\x00\x00\x00\x20" "${DAT}" | tail -n 1 | cut -f1 -d:)
RDKOFFSET=$(LC_ALL=C grep -m1 -aobP "\x04\x00\x00\x84\x00\x00\x00\x20" "${DAT}" | cut -f1 -d:)
is_int "${RDKOFFSET}"
if [ $? -ne 0 ]; then
  echo "Error: RDK could not be located."
  exit 3
fi
#echo "RDK offset = '$RDKOFFSET'"
RDK=$(hexdump -e '16/1 "%02x"' -s $((RDKOFFSET + 8)) -n 16 "${DAT}")
echo "RDK     = '$RDK'"

# Get offset and drive ID checksum
DCOFFSET=$(LC_ALL=C grep -aobP "\x01\x03\x00\x38\x00\x00\x00\x5c" "${DAT}" | tail -n 1 | cut -f1 -d:)
is_int "${DCOFFSET}"
if [ $? -ne 0 ]; then
  echo "Error: Dev ID could not be located."
  exit 4
fi
#echo "DC offset = '$DCOFFSET'"
DCSUM=$(head -c $((DCOFFSET + 8 + 92)) "${DAT}" | tail -c 92 | openssl dgst -sha1 -binary | hexdump -e '1/1 "%02x"')
echo "Dev ID  = '$DCSUM'"

# Get disc ID checksum
KEYSUM=$(openssl dgst -sha1 -binary "${KEY}" | hexdump -e '1/1 "%02x"')
echo "Disc ID = '$KEYSUM'"

# Write RDK
echo -e "\nWrite RDK and VID..."
mkdir -p "${AACS}/rdk/${DCSUM}"
echo -n "${RDK}" >"${AACS}/rdk/${DCSUM}/${KEYSUM}"

# Write VID
mkdir -p "${AACS}/vid"
echo -n "${VID}" >"${AACS}/vid/${KEYSUM}"

# Unmount disk and clean up temp files
echo -e "\nUnmounting blu-ray disc and deleting temp files..."
udisksctl unmount -b ${BRDEV}
rm -rf "${TEMPDIR}"
