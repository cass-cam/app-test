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
        # rm -rf ${IMAGE_NAME}.docker.tar.gz
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
    //stage('Deploying To Dev ENV'){
    //  steps{
    //    sh """
    //    export IMAGE_VERSION=${IMAGE_NAME}.${BUILD_NUMBER}
    //    /usr/local/bin/ecs-cli compose --project-name Dev_deploy --file ci/docker-compose.yml --ecs-params ci/ecs-params.yml -c Cluster-dev up --launch-type EC2
    //    aws ecs update-service --cluster Cluster-dev --service service-dev --task-definition Dev_deploy
    //    docker image ls | grep -v 4b0bbb0e6e32 | awk '{print "docker image rm -f "  \$3}'| sh
    //    aws ecr describe-images --repository-name app  --query 'sort_by(imageDetails,& imagePushedAt)[*].imageTags[0]' --output json | head -n 1 | sed 1d | sed 's/^[ ^t"]*//' | sed 's/[ ^",]*\$//' | awk '{print "aws ecr batch-delete-image --repository-name app --image-ids imageTag=" \$1}' | sh
    //    """
    //  }
    //}
    // stage('Updating ECR list'){
    //  steps{
    //    sh"""
    //    source /var/lib/jenkins/pythonvenv/ECRworkspace_Dev/bin/activate
    //    python /var/lib/jenkins/pythonvenv/ECR_list.py
    //    """
    //  }
    //}
  //}
}
}