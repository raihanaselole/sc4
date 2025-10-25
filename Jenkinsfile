pipeline {
agent any


environment {
IMAGE = "${DOCKERHUB_USER}/demo-app"
IMAGE_TAG = "latest"
DOCKER_CRED_ID = 'dockerhub-credentials' // credential id in Jenkins (username/password)
KUBE_CONFIG_CREDENTIAL = 'kubeconfig' // optional: if you store kubeconfig as secret text file
HELM_RELEASE = 'demo-app'
HELM_CHART_DIR = 'chart'
NAMESPACE = 'default'
}


stages {
stage('Checkout') {
steps {
checkout scm
}
}


stage('Build Docker Image') {
steps {
script {
// use Docker available on Jenkins node (the container must have docker CLI + socket)
sh "docker build -t ${IMAGE}:${IMAGE_TAG} ."
}
}
}


stage('Push to DockerHub') {
steps {
withCredentials([usernamePassword(credentialsId: env.DOCKER_CRED_ID, passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
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
// two options: 1) mount kubeconfig into container and use it directly
// 2) use kubectl context already configured on the node
// below assumes kubeconfig available at $KUBECONFIG path inside agent
sh '''
helm repo update || true
helm upgrade --install ${HELM_RELEASE} ${HELM_CHART_DIR} \
--namespace ${NAMESPACE} --set image.repository=${IMAGE} --set image.tag=${IMAGE_TAG}
'''
}
}
}


post {
failure {
echo 'Build or deployment failed.'
}
success {
echo 'Pipeline finished successfully.'
}
}
}