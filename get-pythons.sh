#!/bin/sh

set -ex

cleanup_after_install () {
    find /usr/local -depth -type d -a  -name test -o -name tests -o  -type f -a -name '*.pyc' -o -name '*.pyo' -exec rm -rf '{}' +
    rm -rf /usr/src/python
}

get_install () {
    PY_VERSION=$1
    PY_DIR=${2:-$1}
    cd /tmp
    wget -q https://www.python.org/ftp/python/$PY_DIR/Python-$PY_VERSION.tgz
    tar xzf Python-$PY_VERSION.tgz
    cd /tmp/Python-$PY_VERSION
    ./configure && make && make altinstall
    cd /tmp
    rm Python-$PY_VERSION.tgz && rm -r Python-$PY_VERSION
}



get_install_beta () {
	DOWNLOAD_URL=https://www.python.org/ftp/python/3.7.0/Python-3.7.0b5.tgz
	cd /tmp
	wget $DOWNLOAD_URL
	tar xzf Python-3.7.0b5.tgz
	cd /tmp/Python-3.7.0b5
	./configure && make && make altinstall
	cd /tmp
	rm Python-3.7.0b5.tgz && rm -r Python-3.7.0b5
}


# First, get and install Python 3.7 from the latest git install.
cd  /tmp/
wget https://github.com/python/cpython/archive/master.zip
unzip master.zip
cd /tmp/cpython-master
./configure && make && make altinstall
# Remove the git clone.
rm -r /tmp/cpython-master && rm /tmp/master.zip

# Install Python 3.4, 3.5, 3.6, 2.7
get_install $PYTHON_34_VER
get_install $PYTHON_35_VER
get_install $PYTHON_36_VER
get_install $PYTHON_37_VER
get_install $PYTHON_38_VER 3.8.0

# After we have installed all the things, we cleanup tests and unused files
# like .pyc and .pyo
cleanup_after_install
