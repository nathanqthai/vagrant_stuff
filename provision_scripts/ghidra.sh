#!/bin/sh
vagrant=$1
stage_dir=$2

install_dir="/opt"

apt-get update
apt-get install -y unzip

ghidra_url="https://ghidra-sre.org/"
ghidra_info=$(wget ${ghidra_url} -q -O - | grep "SHA-256 Hash" | sed -e 's/^[[:blank:]]*//g; s/<[^>]*>//g; s/[[:blank:]]\+/ /g')
ghidra_checksum=$(echo ${ghidra_info} | cut -d ' ' -f 1)
ghidra_zip=$(echo ${ghidra_info} | cut -d ' ' -f 2)
echo $ghidra_zip

if [ ! -f ${stage_dir}/${ghidra_zip} ]; then
    ghidra_staged=$(find ${vagrant} -type f -name "${ghidra_zip}" -print -quit)
    if [ -f "${ghidra_staged}" ]; then
        cp ${ghidra_staged} ${stage_dir}/
    else
        wget "${ghidra_url}${ghidra_zip}" -o - -P ${stage_dir}/
    fi
fi

ghidra_valid=$(echo -e "${ghidra_checksum} ${stage_dir}/${ghidra_zip}" | sha256sum --check)
if [[ $ghidra_valid != "${stage_dir}/${ghidra_zip}: OK" ]]; then
    >&2 echo $ghidra_valid
    >&2 echo "GHIDRA HAS INVALID CHECKSUM"
    exit -1 # force a failed exit
else
    echo $ghidra_valid
fi

unzip -o ${stage_dir}/${ghidra_zip} -d ${install_dir}

ghidra_path=$(find /opt -maxdepth 1 -type d -name "ghidra*" -print)
chown -hR vagrant:vagrant ${ghidra_path}

ghidra_run=$(find /opt -type f -name "ghidraRun" -print)
ln -sf ${ghidra_run} /usr/bin/ghidra

