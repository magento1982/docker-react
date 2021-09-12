pipeline {

  agent none

  environment {
    DOCKER_IMAGE = "nguyenvantri1982/docker-react"
  }

  stages {
    stage("Test") {
      agent {
          docker {
            image 'node:lts-buster-slim'
            args '-u 0:0 -v /tmp:/root/.cache'
          }
      }
      steps {
        sh "yarn install"
      }
    }

    stage("build") {
      agent { node {label 'master'}}
      environment {
        DOCKER_TAG="${GIT_BRANCH.tokenize('/').pop()}-${GIT_COMMIT.substring(0,7)}"
      }
      steps {
        
        // sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
        //sh "docker image ls | grep ${DOCKER_IMAGE}"

        withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
            sh 'echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin'
        }
        sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} . "
        sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
        sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
        // 
        script{
            if(GIT_BRANCH ==~ /.*master.*/){
                sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
                sh "docker push ${DOCKER_IMAGE}:latest"
            }
        }
        //clean to save disk
        sh "docker image rm ${DOCKER_IMAGE}:${DOCKER_TAG}"
        //sh "docker image rm ${DOCKER_IMAGE}:latest"
        //sh "docker run ${DOCKER_IMAGE}:latest"
      }
    }
    stage("deploy") {
      withCredentials([sshKey(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
            sh 'echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin'
      }
    }


  }

  post {
    success {
      echo "SUCCESSFUL"
    }
    failure {
      echo "FAILED"
    }
  }
}