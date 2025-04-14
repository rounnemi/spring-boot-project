pipeline {
    agent any

    environment {
        // Define the complete Docker image name
        DOCKER_IMAGE = 'noursoussia/ci-cd-pipeline'
    }

    stages {
        stage('Checkout') {
            steps {
                // Check out your code from the SCM
                checkout scm
            }
        }
        stage('Build') {
            steps {
                // Build the application using Maven
                sh 'mvn clean install'
            }
        }
        stage('Docker Build & Push') {
            steps {
                // Build the Docker image and tag it as latest
                sh "docker build -t ${DOCKER_IMAGE}:latest ."
                // Push the Docker image to Docker Hub
                sh "docker push ${DOCKER_IMAGE}:latest"
            }
        }
    }
    post {
        always {
            // Clean up the workspace after the build
            cleanWs()
        }
    }
}
