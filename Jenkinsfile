pipeline {
  environment {
    registry = "registry.myhomehub.de/fhem"
    registryCredential = ''
    dockerImage = ''
  }
  agent any
  triggers {
        cron('H H(0-3) * * 1-5')
  }
  stages {
   
    stage('Building image') {
      steps{
        script {
          sh "docker pull fhem/fhem:latest"
          dockerImage = docker.build(registry + ":latest",  "--no-cache .")
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
