pipeline {
    agent {
        docker {
            image 'node:10-alpine'
            args '-p 3000:3000'
        }
    }
    environment {
        CI = 'true'
    }
    stages {
        stage('Build') {
            steps {
                sh 'npm install'
            }
        }
        stage('Test') {
            steps {
                sh './jenkins/scripts/test.sh'
            }
        }
        stage('Deliver') {
            steps {
                sh './jenkins/scripts/deliver.sh'
                input message: 'Finished using the web site? (Click "Proceed" to continue)?'
                sh './jenkins/scripts/kill.sh'
            }
        }
    }
}


//pipeline {
//  options {
//    buildDiscarder(
//      logRotator(
//        numToKeepStr: '5',
//        artifactNumToKeepStr: '3'
//      )
//    )
//  }
//  agent any
//  environment {
//    IMAGE_NAME = "sw_latam_app_dev"
//  }
//  stages {
//      stage('build') {
//          steps {
//        sh """
//        # Clean up any old image archive files
//        rm -rf ${IMAGE_NAME}.docker.tar.gz
//        docker build marco/irock:1.0-snap .
//        """
//
//        archiveArtifacts artifacts: "${IMAGE_NAME}.docker.tar.gz", fingerprint: true
//
//      }
//    }
//  }
//}