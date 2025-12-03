FROM openjdk:17-jdk-slim
ARG JAR_FILE=java-hello-world-with-maven/target/jb-hello-world-maven-0.2.0.jar
# create app dir
RUN mkdir -p /app
COPY ${JAR_FILE} /app/app.jar
WORKDIR /app
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
