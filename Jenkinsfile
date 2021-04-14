pipeline {
   agent { label 'master' } 
        stages { 
            stage { 'Build app' }
            steps {
                git 'https://github.com/cass-cam/app-test.git'
                sh 'mvn clean install -Dmaven.test.skip=true'
            }
        }
}
