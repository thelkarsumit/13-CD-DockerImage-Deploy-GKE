pipeline {
    agent any
    
    environment {
        SCANNER_HOME=tool 'SonarQube-Scanner'
        PROJECT_ID='peak-axiom-426310-b1'
        CLIENT_EMAIL='jenkins-vm-controller@peak-axiom-426310-b1.iam.gserviceaccount.com'
        GCLOUD_CREDS=credentials('GCP-service-key')
        IMAGE_NAME = 'hello-world'
        DOCKER_IMAGE = ''
      }
    
  tools {
        maven 'Maven'
    }
    
 stages {
        stage('sonarqube-analysis') {
            steps {
                withSonarQubeEnv('SonarQube-server') {
                 sh 'mvn clean verify sonar:sonar \
                    -Dsonar.projectKey=07-HelloWorld-DockerImage-Push-DockerHub \
                    -Dsonar.host.url=http://35.228.47.4:9000 \
                    -Dsonar.login=sqp_e611d75bac5dd6996b48a9ba69fdaaa51bd17f3c'
                }
            }
        }
        
     stage('Test') {
            steps {
                // Define steps for the Test stage
                echo 'Running tests...'
                sh  'mvn test'
            }
        }
     
    stage('Build') {
            steps {
                // Define steps for the Build stage
                echo 'Building the project...'
                sh 'mvn clean package'
            }
        }
     
    stage('Docker Build') {
            steps {
                script {
                    // Build the Docker image
                    DOCKER_IMAGE = "gcr.io/${env.PROJECT_ID}/${env.IMAGE_NAME}:latest"
                    docker.build(DOCKER_IMAGE)
                }
            }
        }
     
    stage('Docker Push') {
            steps {
                script {
                        sh 'gcloud auth activate-service-account --key-file=${GCLOUD_CREDS}'
                        sh 'docker push us-central1-docker.pkg.dev/peak-axiom-426310-b1/docker-image-push-01/${env.DOCKER_IMAGE}'
                }
            }
        }
    }
    post {
        success {
            // Actions to take if the pipeline succeeds
            echo 'Pipeline succeeded!'
            // You can also send an email notification on success
            mail to: 'thelkarsc@gmail.com',
                 subject: "Pipeline Succeeded: ${currentBuild.fullDisplayName}",
                 body: "The pipeline ${env.BUILD_URL} has successfully completed."
        }
        failure {
            // Actions to take if the pipeline fails
            echo 'Pipeline failed!'
            // You can also send an email notification on failure
            mail to: 'thelkarsc@gmail.com',
                 subject: "Pipeline Failed: ${currentBuild.fullDisplayName}",
                 body: "The pipeline ${env.BUILD_URL} has failed. Check the logs for details."
        }
    }
}
