pipeline {
  agent any
  environment {
        REGISTRY = 'victormongi'
        APPS = 'api-test'
  }
    stages{
      stage('Build with docker') {
        steps {
          sh "docker build -f Dockerfile -t ${REGISTRY}/${APPS}:${BUILD_NUMBER} -t ${REGISTRY}/${APPS}:latest ."
        }
      }
      stage('Publish to docker image') {
        steps {
          sh "docker push ${REGISTRY}/${APPS}:${BUILD_NUMBER}"
          sh "docker push ${REGISTRY}/${APPS}:latest"
        }
      }
      stage('Deploy to kubernetes') {
        steps {
          script {
            if ( env.GIT_BRANCH == 'staging' ) {
              sh "sed -i 's/IMAGE_TAG/${BUILD_NUMBER}/g' deployment.yaml"
              sh "kubectl apply -f deployment.yaml -n staging"
            }
            else if ( env.GIT_BRANCH == 'main' ) {
              sh "kubectl get nodes"
              sh "sed -i 's/IMAGE_TAG/${BUILD_NUMBER}/g' deployment.yaml"
              sh "kubectl apply -f deployment.yaml -n production"
            }
            else {
              sh "kubectl get nodes"
              sh "sed -i 's/IMAGE_TAG/${BUILD_NUMBER}/g' deployment.yaml"
              sh "kubectl apply -f deployment.yaml -n production"
            }
          }
        }
      }
    }
    post {
        always {
           echo 'One way or another, I have finished'
        }
        success {
            echo 'I succeeded!'
        }
        failure {
            echo 'I failed :('
        }
    }
}