pipeline {
    agent any

    environment {
        // Define the complete Docker image name to be used in Docker Hub
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
                script {
                    // Log in to Docker Hub using stored Jenkins credentials
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKERHUB_USERNAME',
                        passwordVariable: 'DOCKERHUB_PASSWORD'
                    )]) {
                        // Use your Docker Hub personal access token as the password
                        sh "echo ${DOCKERHUB_PASSWORD} | docker login -u ${DOCKERHUB_USERNAME} --password-stdin"
                    }
                    // Build the Docker image and tag it as "latest"
                    sh "docker build -t ${DOCKER_IMAGE}:latest ."
                    // Push the Docker image to Docker Hub
                    sh "docker push ${DOCKER_IMAGE}:latest"
                }
            }
        }
    }

    post {
        always {
            // Clean up the workspace after the build using deleteDir()
            deleteDir()
        }
    }
}
