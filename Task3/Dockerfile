FROM java:8-jdk-alpine

COPY Profile-0.0.1-SNAPSHOT.jar /usr/app/

WORKDIR /usr/app

RUN sh -c 'touch Profile-0.0.1-SNAPSHOT.jar'

ENTRYPOINT ["java","-jar","Profile-0.0.1-SNAPSHOT.jar"]
