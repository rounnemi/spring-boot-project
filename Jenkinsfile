pipeline {
    // Use any available node for the overall pipeline
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
                // Build the application using Maven.
                // Ensure the Jenkins node used here has Maven installed, or consider using a docker agent with a Maven image.
                sh 'mvn clean install'
            }
        }

        stage('Docker Build & Push') {
            // Override the agent for this stage to use a Docker container with the Docker CLI installed.
            agent {
                docker {
                    // Using the official Docker image that includes the CLI.
                    image 'docker:20.10.8'
                    // Mount the host’s Docker socket into the container so Docker commands work.
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                script {
                    // Log in to Docker Hub using stored Jenkins credentials.
                    // It’s better to use single quotes for the sh step and environment variable interpolation to avoid warnings.
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKERHUB_USERNAME',
                        passwordVariable: 'DOCKERHUB_PASSWORD'
                    )]) {
                        sh 'echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin'
                    }
                    // Build the Docker image and tag it as "latest".
                    sh "docker build -t ${DOCKER_IMAGE}:latest ."
                    // Push the Docker image to Docker Hub.
                    sh "docker push ${DOCKER_IMAGE}:latest"
                }
            }
        }
    }

    post {
        always {
            // Wrap deleteDir() within a node block to ensure it has the required workspace context.
            node {
                deleteDir()
            }
        }
    }
}
