pipeline {
  options {
    buildDiscarder(
      logRotator(
        numToKeepStr: '5',
        artifactNumToKeepStr: '3'
      )
    )
  }
  agent any
  environment {
    IMAGE_NAME = "test-image"
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
        | docker login --username AWS --password-stdin 264576910958.dkr.ecr.us-east-1.amazonaws.com
        docker tag ${IMAGE_NAME}:${BUILD_NUMBER} 264576910958.dkr.ecr.us-east-1.amazonaws.com/test-app:${IMAGE_NAME}.${BUILD_NUMBER}
        docker push 264576910958.dkr.ecr.us-east-1.amazonaws.com/test-app:${IMAGE_NAME}.${BUILD_NUMBER}
        """
      }


    }
    stage('Deploying To Dev ENV'){
      steps{
        sh """
        aws eks update-kubeconfig --name test-app
        export IMAGE_VERSION=${IMAGE_NAME}.${BUILD_NUMBER}
        kubectl --record deployment.apps/my-deployment set image deployment.v1.apps/my-deployment app=264576910958.dkr.ecr.us-east-1.amazonaws.com/test-app:${IMAGE_NAME}.${BUILD_NUMBER}
        """
      }
    }
     stage('Updating ECR list'){
      steps{
        sh"""
        source /var/lib/jenkins/pythonvenv/ECRworkspace_Dev/bin/activate
        python /var/lib/jenkins/pythonvenv/ECR_list.py
        """
      }
    }
  //}
}
}