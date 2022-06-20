pipeline {
    agent any
    tools{
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
        //Building Docker images
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
              withkubeconfig (caCertificate: 'LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeU1EWXdPVEU1TVRZeE4xb1hEVE15TURZd05qRTVNVFl4TjFvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTDhmCjNHNEVCRW9jT1JUN1BZZWFlL2F0aGFyK0l0MHVLNVJUeWxRdlo1aEhGQ0FpRUpjVWxvbWJCM2dLSFVQK2xEbzcKK1pVV05wTDdQWnFpNHh4SVRvTmZSWWlDRVVCRUROUkdJMnpEakh5MHptcXhsVEJSK0I5eFpmWkI0Sitrd1Npawp4MWtZTlFUbnFCYXY2SzZnblFvY1o5Qi9hVjZOMyt0dkhGSnp0UHNyMkVJdUZ5MVhVczRFTzEvYU45M1lPT0VBCksvaSsvekhCQXB1TmkvYzc4MjRRSUYvUTcvN2ZiRmVFVVBnc1FHTGI4RFNlS3NseGQwNnpTN0xBNnkvbUhnM1cKYk9YdituL0pQdk1yY3ZxcXBibWFRMG95UkNSTkRQQURkOVFBTGxVUUNzTWVZemlNRGxPckpwOHZkK3U3OHliTApUaHBjUnlZVS9GNktnNU5nNnFVQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZNcUNLZnAwb1FvSzBud21wTUl6UmFEL1JPZ21NQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBRUdYNW43ZjRPTklqcUtjUHc5UApBUWg4dFM4MVY4eENHdUVBazdMZ1VkY2xtSXNvVWw1Nzg1N3Y0UnBrZkM1KzAyMXdueWQ0QkYrRlVPUTAxZmU1Cnd3WVROOW03cW9ZdW1iZmJua3l0WnVMWnJpNGg4Z0ExTEEwVVovZk9YQUVJVlEvTGhxei8zTHRRY3VhSlJaU1oKNzBySElhYkNPWTVnSkVKSjg3THJONENNOVBGQUtPbzUrbGhwbjRQeXBDbkVQK2d5bit5bXlnNWtiMGNJWW5jaQpyRjNHKzcveDBHZFNvS3VGcVJYVFZOYS82QjlXNGpQcGVJdk1ITy91dWcrdlhxMUZDTG5ZQ0dSQnhJb3FpNjh0CkpDQng5TEZRVmRhNGZkOFJ1b2lYWDJVUDdIZ3FZSmRKMXhXb1RsczhtaW84L0pzR09Od1FndFVrNElNM0pBMXQKaVlnPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==', contextName: 'arn:aws:eks:us-west-2:823008317281:cluster/my-cluster', credentialId: 'eks_credential', namespace: 'production', serverUrl: 'https://56EB7BC1822914D4C1A3DE75B0A9256E.gr7.us-west-2.eks.amazonaws.com ')  {
                  sh "kubectl apply -f eks-deploy-from-ecr.yaml"
              }
            }
        }
    }
} 
          
