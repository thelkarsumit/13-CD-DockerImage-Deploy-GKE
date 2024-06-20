# Use an official Maven image to build the application
FROM maven:3.8.4-openjdk-8 AS build
 
# Set the working directory
WORKDIR /app
 
# Copy the pom.xml file and install dependencies
COPY pom.xml .
RUN mvn dependency:go-offline
 
# Copy the source code and build the application
COPY src ./src
RUN mvn package
 
# Use an official OpenJDK runtime image to run the application
FROM openjdk:8-jre
 
# Set the working directory
WORKDIR /app
 
# Copy the built JAR file
COPY --from=build /app/target/hello-world-1.0-SNAPSHOT.jar .
 
# Define the entry point for the container
ENTRYPOINT ["java", "-jar", "hello-world-1.0-SNAPSHOT.jar"]