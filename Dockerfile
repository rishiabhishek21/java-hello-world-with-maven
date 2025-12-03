FROM openjdk:26-ea-26-jdk
ARG JAR_FILE=target/jb-hello-world-maven-0.2.0.jar
# create app dir
RUN mkdir -p /app
COPY ${JAR_FILE} /app/app.jar
WORKDIR /app
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
