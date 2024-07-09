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
        NAMESPACE = 'my-namespace'
      }
stages{
 stage('Authenticate to GCP') {
         steps {
        script {
                 sh 'gcloud auth activate-service-account --key-file="$GCLOUD_CREDS" ' 
                 sh 'gcloud config set project $PROJECT_ID'
                 sh 'gcloud config set compute/zone $CLUSTER_ZONE'
            }
         }
     }
stage('Artifact image validation') {
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
    stage('Namespace Creation') {
            steps {
                script {
                    def exists = sh(script: "kubectl get namespace ${NAMESPACE} -o yaml", returnStatus: true) == 0
                    if (exists) {
                        echo "Namespace '${NAMESPACE}' already exists."
                    } else {
                        sh(script: "kubectl create namespace ${NAMESPACE}", returnStatus: true)
                        echo "Namespace '${NAMESPACE}' created."
                    }
                }
            }
        }
stage('Deploy to GKE') {
            steps {
                script {
                        sh 'kubectl apply -f deployment.yaml -f ingress.yaml -n ${NAMESPACE}'
                }
            }
        }
}
    post {
          always {
                 cleanWs()
            }
         success {
            // Actions to take if the pipeline succeeds
            echo 'Pipeline succeeded!'
            // You can also send an email notification on success
            mail to: 'sumitthelkar30799@gmail.com',
                 subject: "Pipeline Succeeded: ${currentBuild.fullDisplayName}",
                 body: "The pipeline ${env.BUILD_URL} has successfully completed."
        }
        failure {
            // Actions to take if the pipeline fails
            echo 'Pipeline failed!'
            // You can also send an email notification on failure
            mail to: 'sumitthelkar30799@gmail.com',
                 subject: "Pipeline Failed: ${currentBuild.fullDisplayName}",
                 body: "The pipeline ${env.BUILD_URL} has failed. Check the logs for details."
            }
        } 
}
