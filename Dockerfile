
FROM tomcat:8.0.20-jre8

RUN mkdir /usr/local/tomcat/webapps/mywebapp

COPY ./project-1.0-RAMA.war /usr/local/tomcat/webapps/Dockerdemo.war
