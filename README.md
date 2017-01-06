Azure has recently announced [App Services on Linux](https://docs.microsoft.com/en-us/azure/app-service-web/app-service-linux-intro). It supports running web apps natively on Linux. You can quickly create an app following [Link](https://docs.microsoft.com/en-us/azure/app-service-web/app-service-linux-how-to-create-a-web-app) and setup continuous deployment to publish the app.


Web Apps on Linux is built using [Docker](https://www.docker.com/). So you can use a Custom Docker image to deploy your web app to an application stack that is not already defined in Azure - [Link](https://docs.microsoft.com/en-us/azure/app-service-web/app-service-linux-using-custom-docker-image)

This Blog would provide an overview of Creating and running Custom Container to run perl application in web apps on Linux. 

####Creating Custom Perl Container
1. I would recommend to setup a local Docker dev environment for creating Custom container(makes it easy to debug). Refer my another blog [Running Docker on Azure VM](https://prmadi.com/running-docker-on-azure-vm/)
2. Make sure your Docker file is running as expected in development environment
3. Deploy your Docker files into Github. Ex: [appserviceperl](https://github.com/prashanthmadi/appserviceperl)
4. Create DockerHub account and Setup Continuous integration from Github

Below are list of steps my DockerFile has to create App Service Perl image
Github Repo : https://github.com/prashanthmadi/appserviceperl

* I have extended httpd official container and set custom httpd.conf file
```
FROM httpd:2.4
COPY ./my-httpd.conf /usr/local/apache2/conf/httpd.conf
```
* Established symlinks for below as all our site content would be in `/home/site/wwwroot` folder<br>
 /usr/local/apache2/htdocs -> /home/site/wwwroot<br>
 /usr/local/apache2/logs -> /home/LogFiles<br>
```
RUN  rm -f /usr/local/apache2/logs/* \
   && chmod 777 /usr/local/apache2/logs \
   && rm -rf /usr/local/apache2/htdocs \
   && rm -rf /usr/local/apache2/logs \
   && mkdir -p /home/site/wwwroot \
   && mkdir -p /home/LogFiles \
   && chown -R root:www-data /home \
   && ln -s /home/site/wwwroot /usr/local/apache2/htdocs \
   && ln -s /home/LogFiles /usr/local/apache2/logs
```
* Installed perl again as cpanm fails with default installation.
```
RUN apt-get update \
   && apt-get install make \
   && apt-get install -y perl
```
* Created a /home/cpan directory for temporary use and need to be deleted later
```
RUN mkdir -p /home/cpan
```
* Copied cpanfile to /home/cpan/cpanfile. this file has required perl dependencies. You can alter this as per your requirement.
```
COPY ./cpanfile /home/cpan/cpanfile
```
* Download cpanm inside /home/cpan folder and insall modules listed in cpanfile
```
RUN apt-get install -y curl \
   && cd /home/cpan \
   && curl -LO http://xrl.us/cpanm \
   && apt-get install -y libhtml-parser-perl \
   && perl cpanm --force --installdeps .
```

* deleting /home/cpan folder as we don't need it anymore
```
RUN rm -rf /home/cpan
```
####Installing Custom Container to run Perl App on Web Apps Linux

* Navigate to azure portal and select "Web App On Linux" option inside Web + Mobile
![Web App On Linux](https://prmadi.com/content/images/2017/01/portal.PNG)
* We need to Select "Configure container" option to use Custom Container
* Here you can use Built-in container or one from Docker Hub/Private registry
* I have my Perl Custom Container @ Docker Hub - [prashanthmadi/appserviceperl](https://hub.docker.com/r/prashanthmadi/appserviceperl/)
* So, I have selected Docker Hub and entered my Image name.
![Custom Container](https://prmadi.com/content/images/2017/01/portal2.PNG)
* Finish the process by pressing Create Button

####Testing App:
* Create a `index.pl` file with below content and deploy it using FTP/Git.
```
#!/usr/bin/perl -w
print "Content-type: text/html\n\n";
print "Hello, World.";
```
* Navigate to http://`<your_webapp_name>`.azurewebsites.net/ and it should show "Hello World"

![Custom Container hello World](https://prmadi.com/content/images/2017/01/helloworld.PNG)


####Extending Custom Container to install more Perl dependencies
For adding extra modules, make a fork of my github repo.
https://github.com/prashanthmadi/appserviceperl 

change content in cpanfile (samples available at below link)…
https://github.com/kraih/mojo/wiki/Installation-of-cpan-modules-by-cpanm-and-cpanfile

Publish your new project to dockerhub and use it while configuring container.
