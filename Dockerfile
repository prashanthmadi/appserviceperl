FROM httpd:2.4
COPY ./my-httpd.conf /usr/local/apache2/conf/httpd.conf

RUN   \
   rm -f /usr/local/apache2/logs/* \
   && chmod 777 /usr/local/apache2/logs \
   && rm -rf /usr/local/apache2/htdocs \
   && rm -rf /usr/local/apache2/logs \
   && mkdir -p /home/site/wwwroot \
   && mkdir -p /home/LogFiles \
   && ln -s /home/site/wwwroot /usr/local/apache2/htdocs \
   && ln -s /home/LogFiles /usr/local/apache2/logs
