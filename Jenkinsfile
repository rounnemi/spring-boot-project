pipeline {
   agent {
       docker {
           image 'maven:3.8.6-openjdk-17'
           args '-v /var/run/docker.sock:/var/run/docker.sock'
       }
   }


    environment {
        // Définir le nom complet de l'image Docker à utiliser sur Docker Hub
        DOCKER_IMAGE = 'noursoussia/ci-cd-pipeline'
    }

    stages {
        stage('Checkout') {
            steps {
                // Vérifiez votre code depuis le SCM
                checkout scm
            }
        }
        stage('Build') {
            steps {
                // Construire l'application avec Maven
                // Veillez à ce que l'image Docker utilisée contienne Maven ou installez-le au préalable,
                // ou envisagez de séparer les builds Maven et Docker sur des agents différents.
                sh 'mvn clean install'
            }
        }
        stage('Docker Build & Push') {
            steps {
                script {
                    // Connexion à Docker Hub en utilisant les identifiants stockés dans Jenkins
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKERHUB_USERNAME',
                        passwordVariable: 'DOCKERHUB_PASSWORD'
                    )]) {
                        sh "echo ${DOCKERHUB_PASSWORD} | docker login -u ${DOCKERHUB_USERNAME} --password-stdin"
                    }
                    // Construire l'image Docker et la taguer comme "latest"
                    sh "docker build -t ${DOCKER_IMAGE}:latest ."
                    // Pousser l'image Docker sur Docker Hub
                    sh "docker push ${DOCKER_IMAGE}:latest"
                }
            }
        }
    }

  post {
      always {
          node('docker') {
              deleteDir()
          }
      }
  }

}
