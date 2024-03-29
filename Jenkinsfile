pipeline {
    agent any
    tools {
        maven 'M2_HOME'
    }
    environment {
        registry = "823008317281.dkr.ecr.us-west-2.amazonaws.com/geolocation_ecr_rep"
        registrycredential = 'eks-credential'
        dockerimage = ''
    }
    stages {
        stage ('checkout') {
            steps{
                git branch: 'main', url: 'https://github.com/nyfane/Geolocation.git'
            }
        }
        stage ('Code Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage ('Test') {
            steps {
                sh 'mvn test'
            }
        }
        // Build docker image
         stage ('Building image') {
            steps{
                script {
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                }
            }
        }
        // Uploading Docker images into AWS ECR
        stage ('Pushing to ECR') {
            steps {
                sh 'aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 823008317281.dkr.ecr.us-west-2.amazonaws.com'
                sh 'docker build -t geolocation_ecr_rep .'
                sh 'docker tag geolocation_ecr_rep:latest 823008317281.dkr.ecr.us-west-2.amazonaws.com/geolocation_ecr_rep:latest'
                sh 'docker push 823008317281.dkr.ecr.us-west-2.amazonaws.com/geolocation_ecr_rep:latest'

            }
        }
        // Deploy the image that is in ECR to our EKS cluster
        stage ('Deploy to EKS') {
            steps { 
                script {
                    eksDeploy(configs: 'eks-deploy-from-ecr.yaml', credentialsId: 'eks-credentials' )
                     sh "kubectl apply -f eks-deploy-from-ecr.yaml"
                }
              
            }
        }
    }
}
