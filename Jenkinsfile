pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                // Checkout the source code from the repository
                git 'https://github.com/your-repository/hello-world.git'
            }
        }
        stage('Build') {
            steps {
                // Use Maven to build the application
                sh 'mvn clean package'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                // Perform SonarQube analysis
                withSonarQubeEnv('SonarQube-server') {
                    sh 'mvn sonar:sonar'
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