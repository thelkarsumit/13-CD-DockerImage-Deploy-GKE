pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                // Use Maven to build the application
                sh 'mvn clean package'
            }
        }
        stage('sonarqube-analysis') {
           steps {
               // Perform SonarQube analysis
               withSonarQubeEnv('sonar-server') {
                   sh 'mvn clean verify sonar:sonar \
                       -Dsonar.projectKey=03-Docker-Container \
                       -Dsonar.host.url=http://35.228.202.17:9000 \
                       -Dsonar.login=sqp_e99f09f4ef01a6da391d903b0a9dd127ffa058aa'
               }
             }
        }
        stage('Docker Build') {
            steps {
                // Build the Docker image
                script {
                    dockerImage = docker.build("hello-world:latest")
                }
            }
        }
    }
    post {
        always {
            // Clean up the workspace
            cleanWs()
        }
    }
}
