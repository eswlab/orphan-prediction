#!/bin/bash
wget https://sourceforge.net/projects/splicebox/files/CLASS-2.1.7.tar.gz/download
tar -xvzf download

cd CLASS-2.1.7
sh build.sh

echo '#!/bin/bash' > class2_wrapper
echo 'perl '$(pwd)'/run_class.pl "$@"' >> class2_wrapper
chmod +x class2_wrapper

cd ..
PATH=$PATH:$(pwd)/CLASS-2.1.7

#alias class2='perl $(pwd)/CLASS-2.1.7/run_class.pl'

