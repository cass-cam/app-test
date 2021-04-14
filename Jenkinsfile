node {
    checkout scm
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
//   stage('Make Container') {
//      steps {
//      sh "docker build -t snscaimito/ledger-service:${env.BUILD_ID} ."
//      sh "docker tag snscaimito/ledger-service:${env.BUILD_ID} snscaimito/ledger-service:latest"
//      }
//    }
//}