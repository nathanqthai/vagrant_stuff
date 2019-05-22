#!/bin/sh

VAGRANT_SHARE=$1
STAGING_DIR=$2


CROSSTOOL_VERSION="1.24.0"
CROSSTOOL_NAME="crosstool-ng-${CROSSTOOL_VERSION}"
CROSSTOOL_ARCHIVE="${CROSSTOOL_NAME}.tar.xz"
CROSSTOOL_SIG="${CROSSTOOL_ARCHIVE}.sig"
CROSSTOOL_URL="http://crosstool-ng.org/download/crosstool-ng"

apt-get update
apt-get install -y gcc flex bison make texinfo unzip help2man libtool-bin pkg-config libncurses5-dev libncursesw5-dev

rm ${STAGING_DIR}/${CROSSTOOL_ARCHIVE}
rm -rf ${STAGING_DIR}/${CROSSTOOL_NAME}
rm ${STAGING_DIR}/${CROSSTOOL_SIG}

if [ ! -f ${VAGRANT_SHARE}/${CROSSTOOL_ARCHIVE} ] ;
then
	wget ${CROSSTOOL_URL}/${CROSSTOOL_ARCHIVE} -P ${STAGING_DIR}/ -o -
fi

gpg --keyserver http://pgp.surfnet.nl --recv-keys 35B871D1 11D618A4
wget ${CROSSTOOL_URL}/${CROSSTOOL_SIG} -P ${STAGING_DIR}/ -o -
gpg --verify ${STAGING_DIR}/${CROSSTOOL_SIG}

cd ${STAGING_DIR}
tar xvf ${CROSSTOOL_ARCHIVE}
cd ${CROSSTOOL_NAME}
./configure
make
make install

cd ..
rm ${STAGING_DIR}/${CROSSTOOL_ARCHIVE}
rm -rf ${STAGING_DIR}/${CROSSTOOL_NAME}
rm ${STAGING_DIR}/${CROSSTOOL_SIG}
