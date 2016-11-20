FROM httpd:latest
RUN apt-get install libapache2-mod-perl2
RUN apt-get install perl-debug
RUN apt-get install libapache2-mod-perl2-dev
RUN apt-get install  libapache2-request-perl libdatetime-perl 
