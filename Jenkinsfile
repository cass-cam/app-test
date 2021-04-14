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
    IMAGE_NAME = "sw_latam_app_dev"
  }
  stages {
      stage('build') {
          steps {
        sh """
        # Clean up any old image archive files
        rm -rf ${IMAGE_NAME}.docker.tar.gz
        docker build \
          -t ${IMAGE_NAME}:${BUILD_NUMBER} \
          --label "jenkins.build=${BUILD_NUMBER}" \
          --label "jenkins.job_url=${JOB_URL}" \
          --label "jenkins.build_url=${JOB_URL}${BUILD_NUMBER}/" \
          .
        docker save -o ${IMAGE_NAME}.docker.tar ${IMAGE_NAME}:${BUILD_NUMBER}
        gzip ${IMAGE_NAME}.docker.tar
        """

        archiveArtifacts artifacts: "${IMAGE_NAME}.docker.tar.gz", fingerprint: true

      }
    }
  }
}