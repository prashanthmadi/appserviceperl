FROM httpd:latest
RUN apt-get update
RUN apt-get -y install libapache2-mod-perl2
RUN apt-get -y install perl-debug
RUN apt-get -y install libapache2-mod-perl2-dev
RUN apt-get -y install  libapache2-request-perl libdatetime-perl
