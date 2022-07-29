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
               withKubeConfig(caCertificate: 'LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeU1EY3lPREF6TURJME4xb1hEVE15TURjeU5UQXpNREkwTjFvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBSy9GClJ2dUlzV1lVUTh5NnFMQk94TTd1eFd0L0w4RFJKUHZna1NYd2pqamcraVV0U205cTJmQU1GQzM4WStRTFV3QSsKeXYzVURKd09FaGZIdnhBSStJTVFqRU9LZUZFVi96dTNqb0cyNTlLY3RDMEJ5N0pPYWhPVlpaTGZvTHRzamVwTgp2Slh4dmNkTjhRaTdiY2dDbllmYXEwc0pvL1IwZzM5Q3ZVR2JwS3BZYjY1VDRnenZTZkxXT3p2SGRSR3d5VENLCkR6ZmhnaTlmaUFrbFBmbzlQNGRMbXZzNFoydWNZbktPaElqRms5VWVqeUw4V0tnNjluQ05SRlVNeDFVcml2NlkKNEY0OU1Ic0FuRjRJWm9SWktpblZTM2V2Sms5dGdOWkF2VVRMaENSalR2bUJ1L0VzNmVhQ3MvRUk1QUV1eEVWeApqVUdKSTFrdWM5NW9hWHIzR1I4Q0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZCaTQ3SGZybjFwdk0rUXh4bUNHYkpoSFQ3YXVNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBSkdxazZkK1h2ZllLYXhpTDAwZAp1U1hzcW1MMHNhWXgrM3dnQnVzak1iRXVNMFc4cS84SFdDZ3JiVmJBeXhQaXpVZ2ZMSWlhajJhQ2Y3UU53SnZzCmxTQk1WdUswUS9CSW9laVdVWktEQ3Q4aUFjempmcEp3dlhKaXEwSFAxUzZJcDlySmVwREJjV2pVTFpKRUFwZmIKUytrdDBubkdUZ3h5OThKUHozV1NiVnE5QWNRNGVkOEhLZWFXZkZURWVXV3F0bURIY2c5Z1RhTVNOVHpHeEp3VgpwblZhOEhlYmpGQW15RHVKV1h3UGRjMU5DQ2VxUGowMUF3cEQ3WDVpbjZmSDJVdDRicXA4Q0NHN3orVGI5NG1nClZUWm9PMEJIQStRanhoRkZ6OWdKRWJVNWJsTlpMMWJic2ZqOHplTWhRdHRpVXV0Q3ZGWkRuV1k3ZC9CN252d0oKaGVJPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==', clusterName: 'my-cluster1.us-west-2.eksctl.io', contextName: 'iam-root-account@my-cluster1.us-west-2.eksctl.io', credentialsId: 'eks_credential', namespace: '', serverUrl: 'https://065035A405D83465D1E5735335834F25.sk1.us-west-2.eks.amazonaws.com') {
    // some block
               sh "kubectl apply -f eks-deploy-from-ecr.yaml"
                }  
            }
        }
    }
}
