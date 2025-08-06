# 1. Use an official OpenJDK 21 image for build
FROM openjdk:21-jdk-slim as build

# 2. Set the working directory
WORKDIR /app

# 3. Copy Maven files first (for dependency caching)
COPY pom.xml mvnw ./
COPY .mvn/ .mvn/

# 4. Make mvnw executable and download dependencies offline
RUN chmod +x mvnw
RUN ./mvnw dependency:go-offline

# 5. Copy the rest of the source code
COPY src/ src/

# 6. Package the app (skip tests)
RUN ./mvnw package -DskipTests

# 7. Use a smaller runtime image for final build with JDK 21
FROM openjdk:21-jdk-slim

# 8. Set working directory
WORKDIR /app

# 9. Copy the packaged jar from build stage
COPY --from=build /app/target/*.jar app.jar

# 10. Expose port (Spring Boot default 8080)
EXPOSE 8080

# 11. Run the app with dynamic port
CMD ["sh", "-c", "java -jar app.jar --server.port=$PORT"]