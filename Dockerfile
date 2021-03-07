
FROM tomcat:latest

RUN mkdir /usr/local/tomcat/webapps/mywebapp

COPY ./AVNCommunication-1.0.war /usr/local/tomcat/webapps/QAWebapp.war
