pipeline {
  options {
    buildDiscarder(
      logRotator(
        numToKeepStr: '5',
        artifactNumToKeepStr: '3'
      )
    )
  }
  agent {
  label 'master' }
  environment {
    IMAGE_NAME = "test-image"
    JOB_NAME = "${JOB_NAME}".replace("-deploy", "")
        REGISTRY = "my-docker-registry"
  }
  stages {
    // =================================================================================
    // BUILD IMAGE FROM DOCKERFILE
    // =================================================================================
    stage('build') {
      steps {
        sh """
        # Clean up any old image archive files
        rm -rf ${IMAGE_NAME}.docker.tar.gz
        docker build \
          -t ${IMAGE_NAME}:${BUILD_NUMBER} .
        docker save -o ${IMAGE_NAME}.docker.tar ${IMAGE_NAME}:${BUILD_NUMBER}
        gzip ${IMAGE_NAME}.docker.tar
        """

        archiveArtifacts artifacts: "${IMAGE_NAME}.docker.tar.gz", fingerprint: true

      }
    }
    stage('Artifact Upload'){
      steps{
        sh """
        aws ecr get-login-password --region us-east-1 \
        | docker login --username AWS --password-stdin 264576910958.dkr.ecr.us-east-1.amazonaws.com 2>/dev/null
        docker tag ${IMAGE_NAME}:${BUILD_NUMBER} 264576910958.dkr.ecr.us-east-1.amazonaws.com/test-app:${IMAGE_NAME}.${BUILD_NUMBER}
        docker push 264576910958.dkr.ecr.us-east-1.amazonaws.com/test-app:${IMAGE_NAME}.${BUILD_NUMBER}
        """
      }
    }
    stage('Deploy to dev'){
      steps{
        sh """
        aws eks update-kubeconfig --region us-east-1 --name test-app
        #export AWS_PROFILE=default
        export IMAGE_VERSION=${IMAGE_NAME}.${BUILD_NUMBER}
        curl -LO "https://storage.googleapis.com/kubernetes-release/release/v1.20.5/bin/linux/amd64/kubectl" 
        chmod u+x ./kubectl
        ./kubectl get all | grep my-service
        if [ "$?" -eq "0" ]; then echo app is running; else ./kubectl create -f ./app.yaml; fi
        ./kubectl --record deployment.apps/my-deployment set image deployment.v1.apps/my-deployment app=264576910958.dkr.ecr.us-east-1.amazonaws.com/test-app:${IMAGE_NAME}.${BUILD_NUMBER}
        """
      }
    }
}
}


