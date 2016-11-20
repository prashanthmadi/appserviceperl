FROM httpd:2.4
MAINTAINER Prasahnth madi<prashanthrmadi@gmail.com>

RUN apt-get update
RUN apt-get -y install perl
