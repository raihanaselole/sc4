pipeline {
  agent any

  environment {
    IMAGE_NAME = "demo-app"
    IMAGE_TAG  = "latest"
    DOCKER_CRED_ID = 'dockerhub-credentials' // ganti sesuai ID di Jenkins
    HELM_RELEASE = 'demo-app'
    HELM_CHART_DIR = 'chart'
    NAMESPACE = 'default'
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Prepare Image Name') {
      steps {
        script {
          // ambil username dari credential dan set IMAGE_FULL
          withCredentials([usernamePassword(credentialsId: env.DOCKER_CRED_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
            env.IMAGE = "${DOCKER_USER}/${IMAGE_NAME}"
            echo "Image will be: ${env.IMAGE}:${IMAGE_TAG}"
          }
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          sh "docker build -t ${env.IMAGE}:${IMAGE_TAG} ."
        }
      }
    }

    stage('Push to DockerHub') {
      steps {
        withCredentials([usernamePassword(credentialsId: env.DOCKER_CRED_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh '''
            echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
            docker push ${IMAGE}:${IMAGE_TAG}
            docker logout
          '''
        }
      }
    }

    stage('Deploy to Minikube with Helm') {
      steps {
        // Asumsi helm & kubeconfig tersedia di agent/container Jenkins
        sh """
          helm upgrade --install ${HELM_RELEASE} ${HELM_CHART_DIR} \
            --namespace ${NAMESPACE} --set image.repository=${IMAGE} --set image.tag=${IMAGE_TAG}
        """
      }
    }
  }

  post {
    always { echo "Pipeline finished." }
    success { echo "Success." }
    failure { echo "Failed." }
  }
}
