pipeline {
   agent {
      label "default"
   }
   stages {
      stage('Checkout') {
         steps {
            script {
               git url: 'https://github.com/cass-cam/app-test.git'
            }
         }
      }
      stage('Build') {
         agent {
            label "maven"
         }
         steps {
            sh 'mvn clean compile'
         }
      }
      stage('Test') {
         agent {
            label "maven"
         }
         steps {
            sh 'mvn test'
         }
      }
      stage('Image') {
         agent {
            label "maven"
         }
         steps {
            sh 'mvn -P jib -Djib.to.auth.username=${DOCKER_LOGIN} -Djib.to.auth.password=${DOCKER_PASSWORD} compile jib:build'
         }
      }
      stage('Deploy on test') {
         steps {
            script {
               env.PIPELINE_NAMESPACE = "test"
               kubernetesDeploy kubeconfigId: 'docker-desktop', configs: 'k8s/deployment-template.yaml'
            }
         }
      }
      stage('Deploy on prod') {
         steps {
            script {
               env.PIPELINE_NAMESPACE = "prod"
               kubernetesDeploy kubeconfigId: 'docker-desktop', configs: 'k8s/deployment-template.yaml'
            }
         }
      }
   }
}


//node {
//   // ------------------------------------
//   // -- ETAPA: Compilar
//   // ------------------------------------
//   stage 'Compilar'
//   
//   // -- Configura variables
//   echo 'Configurando variables'
//   def mvnHome = tool 'maven-3.6.3'
//   env.PATH = "${mvnHome}/bin:${env.PATH}"
//   echo "var mvnHome='${mvnHome}'"
//   echo "var env.PATH='${env.PATH}'"
//   
//   // -- Descarga código desde SCM
//   echo 'Descargando código de SCM'
//   sh 'rm -rf *'
//   checkout scm
//   
//   // -- Compilando
//   echo 'Compilando aplicación'
//   sh 'mvn clean compile'
//   
//   // ------------------------------------
//   // -- ETAPA: Instalar
//   // ------------------------------------
//   stage 'Instalar'
//   echo 'Instala el paquete generado en el repositorio maven'
//   sh 'mvn install -Dmaven.test.skip=true'
//   
//   // ------------------------------------
//   // -- ETAPA: Archivar
//   // ------------------------------------
//   stage 'Archivar'
//   echo 'Archiva el paquete el paquete generado en Jenkins'
//   step([$class: 'ArtifactArchiver', artifacts: '**/target/*.jar, **/target/*.war', fingerprint: true])
//
//   steps {
//            sh 'mvn -Ddocker.skip=false -Ddocker.host=unix:///var/run/docker.sock docker:build' //example of how to build docker image with pom.xml and fabric8 plugin
//        }
//}