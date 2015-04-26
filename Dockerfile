FROM maven:3.3.1-jdk-7

RUN mkdir /root/.m2
COPY settings.xml /root/.m2/settings.xml

RUN mkdir /var/m2repo

RUN mkdir /slack-plugin
WORKDIR /slack-plugin

CMD ["bash"]
