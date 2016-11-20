FROM httpd:latest
RUN apt-get update
RUN -y apt-get install libapache2-mod-perl2
RUN -y apt-get install perl-debug
RUN -y apt-get install libapache2-mod-perl2-dev
RUN -y apt-get install  libapache2-request-perl libdatetime-perl
