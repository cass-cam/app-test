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
        docker build marco/irock:1.0-snap .
        """

        archiveArtifacts artifacts: "${IMAGE_NAME}.docker.tar.gz", fingerprint: true

      }
    }
  }
}