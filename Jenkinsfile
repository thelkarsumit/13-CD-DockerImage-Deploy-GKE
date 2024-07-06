pipeline {
    agent any
    parameters {
        string(name: 'IMAGE_NAME') 
    }  
    environment {
        PROJECT_ID='peak-axiom-426310-b1'
        CLIENT_EMAIL='jenkins-vm-controller@peak-axiom-426310-b1.iam.gserviceaccount.com'
        GCLOUD_CREDS=credentials('GCP-service-key')
        CLUSTER_NAME = 'autopilot-cluster-1'
        CLUSTER_ZONE = 'us-central1'
      }
stages{
 stage('Login to GCP') {
         steps {
        script {
                 sh 'gcloud auth activate-service-account --key-file="$GCLOUD_CREDS" ' 
                 sh 'gcloud config set project $PROJECT_ID'
                 sh 'gcloud config set compute/zone $CLUSTER_ZONE'
            }
         }
     }
stage('Validate Image Existence') {
        steps {
                script {
                    def result = sh(returnStdout: true, script: "gcloud container images list-tags ${IMAGE_NAME}")
 
                    if (result.trim() != "") {
                        echo "Image ${IMAGE_NAME} exists in GCR!"
                    } else {
                        error "Image ${IMAGE_NAME} does not exist in GCR."
                    }
                }
            }
       } 
stage('Cluster Login') {
        steps {
        script {
               sh'gcloud container clusters get-credentials $CLUSTER_NAME'
            }
        }
    }
     
    //stage('Validate Namespace Existence') {
 
stage('Create Namespace') {
         steps {
                script {
                sh 'kubectl create namespace my-namespace1'
            }
       }
    }
stage('Deploy to GKE') {
            steps {
                script {
                        sh 'kubectl apply -f deployment.yaml'
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
