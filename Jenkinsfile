pipeline {
    agent any
    
    environment {
        SCANNER_HOME=tool 'SonarQube-Scanner'
        PROJECT_ID='peak-axiom-426310-b1'
        CLIENT_EMAIL='jenkins-vm-controller@peak-axiom-426310-b1.iam.gserviceaccount.com'
        GCLOUD_CREDS=credentials('GCP-service-key')
        CLUSTER_NAME = 'autopilot-cluster-1'
        CLUSTER_ZONE = 'us-central1'
      }
    
tools {
        maven 'Maven'
    } 
stages {    
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
                    sh 'gcloud auth activate-service-account --key-file="$GCLOUD_CREDS" '
                    sh 'docker build -t us-central1-docker.pkg.dev/peak-axiom-426310-b1/docker-image-push-01/helloworld1 .'
                }
            }
        }
    
stage('Scan Docker Image') {
            steps {
                script {
                    sh "trivy image us-central1-docker.pkg.dev/peak-axiom-426310-b1/docker-image-push-01/helloworld1 > trivy_report.txt"
                }
            }
        }
    
stage('Docker Push') {
            steps {
                script {
                        sh 'gcloud auth configure-docker \
                            us-central1-docker.pkg.dev'
                        sh 'docker push us-central1-docker.pkg.dev/peak-axiom-426310-b1/docker-image-push-01/helloworld1'
                }
            }
        }
    stage('Deploy to GKE') {
            steps {
                script {
                        sh '''
                            gcloud auth activate-service-account --key-file="$GCLOUD_CREDS" 
                            gcloud config set project $PROJECT_ID
                            gcloud config set compute/zone $CLUSTER_ZONE
                            gcloud container clusters get-credentials $CLUSTER_NAME
                            kubectl set image deployment/(us-central1-docker.pkg.dev/peak-axiom-426310-b1/docker-image-push-01/helloworld1)
                            kubectl apply -f deployment.yaml
                        '''
                }
            }
        }
    }
      post {
            always {
                 cleanWs()
            }
        }  
}
