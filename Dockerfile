# 1. Use an official OpenJDK image
FROM openjdk:17-jdk-slim as build

# 2. Set the working directory
WORKDIR /app

# 3. Copy Maven files first (for dependency caching)
COPY pom.xml mvnw ./
COPY .mvn/ .mvn/

# 4. Make mvnw executable and download dependencies
RUN chmod +x mvnw
RUN ./mvnw dependency:go-offline

# 5. Copy the rest of the source code
COPY src/ src/

# 6. Package the app
RUN ./mvnw package -DskipTests

# 7. Use a smaller runtime image for final build
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy the packaged jar from the previous stage
COPY --from=build /app/target/*.jar app.jar

# 8. Expose port and run the app (Render will inject $PORT)
EXPOSE 8080
CMD ["sh", "-c", "java -jar app.jar --server.port=$PORT"]
