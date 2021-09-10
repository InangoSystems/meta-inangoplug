LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE;md5=16604b00b964efab5ab040060bf08443"
SUMMARY = "Packet Processor Acceleration Module"

inherit module

SRCREV = "${INANGOPLUG_SRCREV}"
SRC_URI = "${INANGOPLUG_SRC_URI}"

S = "${WORKDIR}/git"

EXTRA_OEMAKE += "EXTRA_CFLAGS+='-Werror -Wall'"
EXTRA_OEMAKE += "DESTDIR='${D}'"
