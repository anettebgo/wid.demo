#!/bin/bash

# turn on logging and exit on error
set -e -x

BOOTSTRAP_BUCKET_NAME='<your-bucket-name>'

# grab packages from S3
hadoop dfs -copyToLocal s3n://${BOOTSTRAP_BUCKET_NAME}/R_packages/* .
DEB_HOST_ARCH=`dpkg-architecture -qDEB_HOST_ARCH`

#upgrade R
sudo dpkg -i r-base-core_2.15.2-1~squeezecran.0_${DEB_HOST_ARCH}.deb r-recommended_2.15.2-1~squeezecran.0_all.deb r-base_2.15.2-1~squeezecran.0_all.deb

#some packages have trouble installing without this link
sudo ln -s /usr/lib/libgfortran.so.3 /usr/lib/libgfortran.so

# for the package update script to run the user hadoop needs to own the R library
sudo chown -R hadoop /usr/lib/R/library
sudo chown -R hadoop /usr/local/lib/R

# install packages
R CMD INSTALL getopt_1.17.tar.gz
R CMD INSTALL HadoopStreaming_0.2.tar.gz
