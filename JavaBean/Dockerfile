FROM tomcat:latest
LABEL authors="sutang"

# Remove the default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the project to the webapps directory
COPY . /usr/local/tomcat/webapps/ROOT
