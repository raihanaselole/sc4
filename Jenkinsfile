pipeline {
  agent any

  environment {
    // Ganti dengan Docker Hub user/repo yang ingin kamu pakai
    IMAGE_NAME = "raihan08/demo-app"
    IMAGE_TAG  = "latest"
    CHART_DIR  = "chart/my-flask-app"
    APP_NAME   = "my-flask-app"
    // Masukkan ID credential Jenkins di sini (lihat instruksi di bawah)
    DOCKERHUB_CREDENTIALS_ID = "dockerhub-credentials"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker image') {
      steps {
        script {
          // Build image and tag with latest
          sh """
            docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
          """
        }
      }
    }

    stage('Docker Login & Push') {
      steps {
        // uses Jenkins credential 'dockerhub-creds' (username/password)
        withCredentials([usernamePassword(credentialsId: env.DOCKERHUB_CREDENTIALS_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh """
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            docker push ${IMAGE_NAME}:${IMAGE_TAG}
            docker logout
          """
        }
      }
    }

    stage('Helm Deploy') {
      steps {
        script {
          // Deploy/upgrade helm chart using image repo:tag (latest)
          sh """
            helm upgrade --install ${APP_NAME} ${CHART_DIR} \
              --set image.repository=${IMAGE_NAME} \
              --set image.tag=${IMAGE_TAG}
            kubectl rollout status deployment/${APP_NAME} --namespace default --timeout=120s || true
          """
        }
      }
    }

    stage('Smoke Test / Info') {
      steps {
        sh '''
          echo "Kubernetes pods:"
          kubectl get pods -l app.kubernetes.io/instance=${APP_NAME} --show-labels || true
          echo "Service URL (minikube):"
          minikube service ${APP_NAME} --url || true
        '''
      }
    }
  }

  post {
    success { echo "Pipeline finished: image pushed -> helm deployed." }
    failure { echo "Pipeline failed." }
  }
}
