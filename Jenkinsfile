pipeline {
   agent any

    environment {
        DOCKER_IMAGE = 'noursoussia/ci-cd-pipeline'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build and test the app') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    // Authentification sur Docker Hub à l'aide des credentials
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKERHUB_USERNAME',
                        passwordVariable: 'DOCKERHUB_PASSWORD'
                    )]) {
                        sh "echo ${DOCKERHUB_PASSWORD} | docker login -u ${DOCKERHUB_USERNAME} --password-stdin"
                    }

                    // Construction de l'image Docker avec un tag basé sur le numéro de build
                    sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} ."

                    // Taguer l'image comme 'latest'
                    sh "docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest"

                    // Pousser les deux tags sur Docker Hub
                    sh "docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                    sh "docker push ${DOCKER_IMAGE}:latest"
                }
            }
        }
     stage('Fix Kubeconfig') {
            steps {
                sh 'sed -i "s/server: https:\\/\\/127.0.0.1:6443/server: https:\\/\\/k3s:6443/" /home/jenkins/.kube/kubeconfig.yaml'
            }
        }
     stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh 'kubectl apply -f k8s/deployment.yaml'
                    sh 'kubectl apply -f k8s/service.yaml'
                }
            }
        }
        stage('Clean up') {
            steps {
                sh "docker rmi ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest"
            }
        }
    }

    post {
        success {
            junit '**/target/surefire-reports/TEST-*.xml'
            archiveArtifacts artifacts: 'target/*.jar', allowEmptyArchive: true
        }
    }
}
