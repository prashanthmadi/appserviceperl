FROM httpd:latest
ADD http://apache.claz.org/perl/mod_perl-2.0.10.tar.gz mod_perl-2.0.9.tar.gz
RUN tar -zxvf mod_perl-2.0.9.tar.gz
RUN apt-get update
RUN apt-get install -y libfile-spec-native-perl make gcc libperl-dev
RUN cd mod_perl-2.0.10 && perl Makefile.PL MP_APXS=/usr/local/apache2/bin/apxs && make install
