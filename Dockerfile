FROM httpd:2.4
COPY ./my-httpd.conf /usr/local/apache2/conf/httpd.conf

# establising symlinks
# /usr/local/apache2/htdocs -> /home and
# /usr/local/apache2/logs -> /home/logs
RUN  rm -f /usr/local/apache2/logs/* \
   && chmod 777 /usr/local/apache2/logs \
   && rm -rf /usr/local/apache2/htdocs \
   && rm -rf /usr/local/apache2/logs \
   && mkdir -p /home \
   && mkdir -p /home/logs \
   && chown -R root:www-data /home \
   && ln -s /home /usr/local/apache2/htdocs \
   && ln -s /home/logs /usr/local/apache2/logs \
   && chmod 777 /home/logs


# installing perl again as cpanm fails with default installation. Could be env issue
RUN apt-get update \
   && apt-get install make \
   && apt-get install -y perl

#creating a /home/cpan directory for temporary use
RUN mkdir -p /home/cpan

# copying cpanfile to /home/cpan/cpanfile. this file has required perl dependencies
COPY ./cpanfile /home/cpan/cpanfile

# installing cpanm inside /home/cpan to insall modules listed in cpanfile
RUN apt-get install -y curl \
   && cd /home/cpan \
   && curl -LO http://xrl.us/cpanm \
   && perl cpanm --installdeps .
