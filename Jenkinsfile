pipeline {
  agent any
  stages {
    stage('clean'){
      steps {
        //clean the workspace and build code
        sh 'dotnet clean /var/jenkins_home/workspace/jenkins-test/jenkins-web'
      }
    }
      stage('restore, publish and deploy to azure'){
        steps{
          //restore, publish and zip package
          sh '''
              dotnet restore /var/jenkins_home/workspace/jenkins-test/jenkins-web --packages .nuget/ --runtime win-x64
              dotnet publish /var/jenkins_home/workspace/jenkins-test/jenkins-web --no-restore --runtime win-x64 --no-self-contained -o ./tmp/publish
              cd tmp/publish
              zip -r publish.zip .
              '''
        }
      }
    }
    post {
        always {
          //archive artifacts to be download on azure
            archiveArtifacts artifacts: 'tmp/publish/publish.zip'
        }
    }
}
