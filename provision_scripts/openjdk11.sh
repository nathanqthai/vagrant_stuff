#!/bin/sh

vagrant=$1
stage_dir=$2

jvm_path="/usr/lib/jvm"
openjdk11_tarball="openjdk-11.0.2_linux-x64_bin.tar.gz"
openjdk11_url="https://download.java.net/java/GA/jdk11/9/GPL/"
openjdk11_checksum=$(wget "${openjdk11_url}/${openjdk11_tarball}.sha256" -q -O -)

if [ ! -f ${stage_dir}/${openjdk11_tarball} ]; then
    openjdk11_staged=$(find ${shared_dir} -type f -name "${openjdk11_tarball}" -print -quit)
    if [ -f "${openjdk11_staged}" ]; then
        cp ${openjdk11_staged} ${stage_dir}/
    else
        wget "${openjdk11_url}/${openjdk11_tarball}" -o - -P ${stage_dir}/
    fi
fi

openjdk11_valid=$(echo -e "${openjdk11_checksum} ${stage_dir}/${openjdk11_tarball}" | sha256sum --check)
if [[ $openjdk11_valid != "${stage_dir}/${openjdk11_tarball}: OK" ]]; then
    >&2 echo $openjdk11_valid
    >&2 echo "OPENJDK11 HAS INVALID CHECKSUM"
    exit -1 # force a failed exit
else
    echo $openjdk11_valid
fi

mkdir -p ${jvm_path} # make folder if doesnt exist
tar xfpvz ${stage_dir}/${openjdk11_tarball} --directory ${jvm_path}

openjdk11_path=$(find ${jvm_path} -type d -name "*jdk*11*" -print -quit)
echo -e "export JAVA_HOME=${openjdk11_path}" >> /home/vagrant/.bashrc
echo "export PATH=\\$PATH:\\$JAVA_HOME/bin" >> /home/vagrant/.bashrc

