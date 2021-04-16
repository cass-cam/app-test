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
    stage('Deploy on Dev') {
        node('master'){
            withEnv(["KUBECONFIG=${JENKINS_HOME}/.kube/dev-config","IMAGE=264576910958.dkr.ecr.us-east-1.amazonaws.com/test-app:${IMAGE_NAME}.${BUILD_NUMBER}"]){
                sh "sed -i 's|IMAGE|${IMAGE}|g' k8s/deployment.yaml"
                sh "sed -i 's|ACCOUNT|264576910958|g' k8s/service.yaml"
                sh "sed -i 's|ENVIRONMENT|dev|g' k8s/*.yaml"
                sh "sed -i 's|BUILD_NUMBER|01|g' k8s/*.yaml"
                sh "kubectl apply -f k8s"
                DEPLOYMENT = sh (
                    script: 'cat k8s/deployment.yaml | yq -r .metadata.name',
                    returnStdout: true
                ).trim()
                echo "Creating k8s resources..."
                sleep 180
                DESIRED= sh (
                    script: "kubectl get deployment/$DEPLOYMENT | awk '{print \$2}' | grep -v DESIRED",
                    returnStdout: true
                ).trim()
                CURRENT= sh (
                    script: "kubectl get deployment/$DEPLOYMENT | awk '{print \$3}' | grep -v CURRENT",
                    returnStdout: true
                ).trim()
                if (DESIRED.equals(CURRENT)) {
                    currentBuild.result = "SUCCESS"
                    return
                } else {
                    error("Deployment Unsuccessful.")
                    currentBuild.result = "FAILURE"
                    return
                }
            }
        }
  }
}
    //stage('Deploying To Dev ENV'){
    //  steps {
    //            kubernetesDeploy(
    //                kubeconfigId: 'k8s-default-namespace-config-id',
    //                configs: 'app.yml',
    //                enableConfigSubstitution: true
    //            )
    //        }
      
      //steps{
      //  
      //  #sh """
      //  
      //  #aws eks update-kubeconfig --region us-east-1 --name test-app
      //  #export AWS_PROFILE=default
      //  #export IMAGE_VERSION=${IMAGE_NAME}.${BUILD_NUMBER}
//
      //  #curl -LO "https://storage.googleapis.com/kubernetes-release/release/v1.20.5/bin/linux/amd64/kubectl" 
      //  #chmod u+x ./kubectl
      //  #./kubectl --record deployment.apps/my-deployment set image deployment.v1.apps/my-deployment app=264576910958.dkr.ecr.us-east-1.amazonaws.com/test-app:${IMAGE_NAME}.${BUILD_NUMBER}
      //  #"""
      //}
    }
  //}
//}
