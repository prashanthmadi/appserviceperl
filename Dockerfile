FROM httpd:2.4
COPY ./my-httpd.conf /usr/local/apache2/conf/httpd.conf

RUN   \
   rm -f /usr/local/apache2/logs/* \
   && chmod 777 /usr/local/apache2/logs \
   && rm -rf /usr/local/apache2/htdocs \
   && rm -rf /usr/local/apache2/logs \
   && mkdir -p /home \
   && mkdir -p /home/logs \
   && chown -R root:www-data /home \
   && ln -s /home /usr/local/apache2/htdocs \
   && ln -s /home/logs /usr/local/apache2/logs \
   && chmod 777 /home/logs \
   && mkdir -p /home/cpan \
   && apt-get update \
   && apt-get install -y curl \
   && apt-get install -y perl

RUN whereis perl

COPY ./cpanfile /home/cpan/cpanfile

ENV PATH="/usr/bin:/usr/share:${PATH}"

RUN cd /home/cpan \
   && curl -LO http://xrl.us/cpanm \
   && perl cpanm --installdeps .
