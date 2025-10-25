# my-flask-app-pipeline

Project containing a minimal Flask app + Dockerfile + Helm chart + Jenkinsfile
to demonstrate a CI/CD pipeline that builds a Docker image and deploys to Minikube via Helm.

Files:
- app.py
- requirements.txt
- Dockerfile
- Jenkinsfile
- chart/my-flask-app/...

Quick local test (on a VM with docker and minikube):
```
minikube start --driver=docker
eval $(minikube -p minikube docker-env)
docker build -t my-flask-app:local1 .
helm upgrade --install my-flask-app chart/my-flask-app --set image.repository=my-flask-app --set image.tag=local1
kubectl rollout status deployment/my-flask-app
minikube service my-flask-app --url
```
