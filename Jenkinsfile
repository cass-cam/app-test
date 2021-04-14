node {
//    def gradle = tool name: 'Gradle-5.5', type: 'gradle'
    parameters {
        gitParameter name: 'BRANCH', type: 'PT_BRANCH', defaultValue: 'main'
     }
    withEnv([
        'REPO_URL=https://github.com/cass-cam/app-test.git'
        ]) {
            if(env.JOB_BASE_NAME.contains("test-job")) {
                stage('Git Checkout') {
                    checkout changelog: false, 
                    poll: false,
                    scm: [
                        $class: 'GitSCM',
                        branches: [[name: "${params.BRANCH}"]],
                        doGenerateSubmoduleConfigurations: false,
                        extensions: [
                            [$class: 'CleanBeforeCheckout'],
                        ],
                        submoduleCfg: [],
                        userRemoteConfigs: [
                            [
                                url: "${env.REPO_URL}"
                            ]
                        ]
                    ]
                }
                dir('IST000-3/Back-End/BackendPortal') {
                    stage('Build Docker image') {
                        sh label: '', script: 'sudo docker build -t gcr.io/podmaturity/backendportal-ssl . '
                    }
                    //stage('Push Docker image') {
                    //    sh label: '', script: 'sudo docker push gcr.io/podmaturity/backendportal-ssl:latest'
                    //}
                    // stage('Update Environment') {
                    //     // sh label: '', script: 'gcloud compute instances update-container dev-podmaturity-bkn-portal-w-ssl --container-image gcr.io/podmaturity/backendportal:latest'
                    // }
                }
                // stage('Unit Tests') {
                //     // todo - alll
                // }
        }
}
}


//pipeline {
//    agent {
//        docker {
//            image 'node:10-alpine'
//            args '-p 3000:3000'
//        }
//    }
//    environment {
//        CI = 'true'
//    }
//    stages {
//        stage('Build') {
//            steps {
//                sh 'npm install'
//            }
//        }
//        stage('Test') {
//            steps {
//                sh './jenkins/scripts/test.sh'
//            }
//        }
//        stage('Deliver') {
//            steps {
//                sh './jenkins/scripts/deliver.sh'
//                input message: 'Finished using the web site? (Click "Proceed" to continue)?'
//                sh './jenkins/scripts/kill.sh'
//            }
//        }
//    }
//}
//
//
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