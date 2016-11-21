FROM httpd:latest
RUN apt-get update
RUN apt-get -y install libapache2-mod-perl2
RUN apt-get -y install perl-debug
RUN apt-get -y install libapache2-mod-perl2-dev
RUN apt-get -y install  libapache2-request-perl libdatetime-perl
RUN rm -rf /var/www/html
RUN rm -rf /var/log/apache2
RUN mkdir -p /home/site/wwwroot
RUN mkdir -p /home/LogFiles
RUN mkdir -p /var/www
RUN mkdir -p /var/log
RUN ln -s /home/site/wwwroot /var/www/html
RUN ln -s /home/LogFiles /var/log/apache2
RUN cpan install CGI

RUN { \
  echo '<Location /perl/>'\
  echo '      SetHandler perl-script'\
  echo '      PerlHandler ModPerl::PerlRun'\
  echo '    Options ExecCGI'\
  echo '    PerlSendHeader On'\
  echo '    allow from all'\
  echo '</Location>'\
} > /usr/local/apache2/conf/httpd.conf
