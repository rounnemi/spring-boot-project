pipeline {
    agent {
        docker {
            // Use an image that has docker CLI installed, e.g., docker:20.10.8
            image 'docker:20.10.8'
            // Mount the host's Docker socket into the container
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

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
                // Make sure the docker container image used has Maven installed or install it before your build,
                // or consider splitting the Maven build and Docker build into separate agents.
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
                        // Note: The warning about Groovy string interpolation is only advisory.
                        // You may consider using a different method to pass the secret if desired.
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
