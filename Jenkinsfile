node {
    checkout scm
    stages {

         stage('build Dockerfile') {

            steps {
                sh '''echo "FROM maven:3-alpine
                          RUN apk add --update docker openrc
                          RUN rc-update add docker boot" >/var/lib/jenkins/workspace/Dockerfile'''

            }
         }

         stage('run Dockerfile') {
             agent{
                 dockerfile {
                            filename '/var/lib/jenkins/workspace/Dockerfile'
                            args '--user root -v $HOME/.m2:/root/.m2  -v /var/run/docker.sock:/var/run/docker.sock'
                        }
             }

             steps {
                 sh 'docker version'
                 sh 'mvn -version'
                 sh 'java -version'
             }

         }

    }
    stage('Build Maven') {
        docker.image('maven:3-alpine').inside('-v $HOME/.m2:/root/.m2') {
            sh './scripts/build-maven.sh'
        }
    }
    stage('Build Docker Image') {
        docker.build("${env.JOB_NAME}:${env.BUILD_NUMBER}")
    }
    stage('Push to AWS'){
        sh "./scripts/aws-ecr-push.sh ${env.JOB_NAME}:${env.BUILD_NUMBER} /home/.aws/credentials"
    }
}