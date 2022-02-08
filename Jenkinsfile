pipeline {
  environment {
    registry = "registry.myhomehub.de/fhem"
    registryCredential = ''
    dockerImage = ''
  }
  agent any
  stages {
   
    stage('Building image') {
      steps{
        script {
          sh "docker pull fhem/fhem:latest"
          dockerImage = docker.build registry + ":latest"
        }
      }
    }

  
    stage('Deploy Image') {
      steps{
        script {
          docker.withRegistry( 'https://registry.myhomehub.de/fhem', '' ) {
            dockerImage.push()
          }
        }
      }
    }
  }
}
