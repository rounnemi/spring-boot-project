# Stage 1: Build the application
FROM openjdk:17-jdk-slim AS build
WORKDIR /app
COPY . .
RUN chmod +x mvnw
ARG SKIP_TESTS=true
RUN if [ "$SKIP_TESTS" = "true" ]; then \
      ./mvnw clean package -DskipTests; \
    else \
      ./mvnw clean package; \
    fi
# Stage 2: Create the runtime image
FROM openjdk:17-jdk-slim
WORKDIR /app
# Copy the repackaged JAR (without the .original suffix)
COPY --from=build /app/target/project-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
