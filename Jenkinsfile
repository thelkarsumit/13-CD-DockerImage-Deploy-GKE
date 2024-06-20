pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                // Use Maven to build the application
                sh 'mvn clean package'
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
