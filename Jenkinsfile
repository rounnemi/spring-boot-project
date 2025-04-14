pipeline {
    agent {
        docker {
            image 'maven:3.8.6-openjdk-17'
            // Permet à l'agent d'accéder au démon Docker
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        // Nom de l'image Docker à utiliser sur Docker Hub
        DOCKER_IMAGE = 'noursoussia/ci-cd-pipeline'
    }

    stages {
        stage('Checkout') {
            steps {
                // Récupération du code source depuis le SCM configuré
                checkout scm
            }
        }

        stage('Build and test the app') {
            steps {
                // Construction et tests avec Maven
                sh 'mvn clean package'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    // Authentification sur Docker Hub en utilisant le bloc withCredentials
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

        stage('Clean up') {
            steps {
                // Nettoyage des images locales pour libérer de l'espace
                sh "docker rmi ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest"
            }
        }
    }

    post {
        success {
            // Publication des rapports de tests et archivage des artefacts (ex : .jar)
            junit '**/target/surefire-reports/TEST-*.xml'
            archiveArtifacts artifacts: 'target/*.jar', allowEmptyArchive: true
        }
    }
}
