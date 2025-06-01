#!/bin/bash

set -e

# Run pytest on the tests directory,
# which is assumed to be mounted somewhere in the docker image.

here=$(dirname $0)

testvenv=/tmp/testvenv 
/usr/bin/python3 -m venv $testvenv
$testvenv/bin/pip install -r $here/requirements.txt

export PATH=$here/../bin:$PATH

# Install enterprise addons and dependencies
if [ -f "enterprise_install_addons" ]; then
    echo "Executing enterprise_install_addons..."
    enterprise_install_addons
else
    echo "enterprise_install_addons not found, skipping."
fi

$testvenv/bin/pytest --color=yes --ignore $here/data $here "$@"
