#Builder container
FROM maven:3.6.3-jdk-11-openj9 as builder
WORKDIR /app
COPY . /app
RUN mvn package

#Runtime container
FROM openjdk:11.0.7-slim
WORKDIR /app
COPY --from=builder /app/target/in4it-springboot-demo.jar .
CMD ["java", "-jar", "/app/in4it-springboot-demo.jar"]
