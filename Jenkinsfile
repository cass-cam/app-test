//node {
  //  checkout scm
    //stage ('Build') {
    //git url: 'https://github.com/cyrille-leclerc/multi-module-maven-project'
    //withMaven {
      //sh "mvn clean verify"
      //} // withMaven will discover the generated Maven artifacts, JUnit Surefire & FailSafe reports and FindBugs reports
   // }

    //stage('Build Docker Image') {
      //  docker.build("${env.JOB_NAME}:${env.BUILD_NUMBER}")
    //}
    //stage('Push to AWS'){
      //  sh "./scripts/aws-ecr-push.sh ${env.JOB_NAME}:${env.BUILD_NUMBER} /home/.aws/credentials"
    //}
//}
pipeline {
       agent any
       tools {
                 maven 'maven-3.6.3'
     }   
}