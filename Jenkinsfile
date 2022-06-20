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
              withkubeconfig ( Cacertificate: 'LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeU1EWXlNREEwTURReE5Gb1hEVE15TURZeE56QTBNRFF4TkZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTGNmCmJ3UjhaUnFVTWJKSVVONDdMekZ6THBTVDNVUXBXSVk0OUt1S0tJcmRTVzdXbUtsamxZRS9ENGFLTy85SnZJdEoKYVJZbE0ybjYzNXFnTCsxVnZ4OXdvQkhCdmpVeVRrSWlJajRkckhGcUlNN09HUGdlajg1dm5ZVzB4Rldzc1FFZworcW5Uc0dHSHNuZ0pkaXZwL3hwMGk3QXRqQUVUSmFxMk5FOEY0SWNVTExNbXdGV09uOUhtd0k2aFZ5Y2xNZGNxCm81d25KWlRQZ3A0NWRsSmlnRStiNk56K1ZXN3JIS3Fnb085aEZMOFZmU2t6SG92MUlhcmZXZkt0NlR4QzV0K2sKK1RnUkk5NE0xQ0I1UTYveGFmZXFDTmFUbGtLclQ5NWRXc3hOdng1MTFQWld6aWhLbXlLeGdTbGd5Yy90SWlaYgpaWnBCdDlNRjlaN2hIRnNQRGRFQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZFU1NiOGtGTlhYQ1dPSXUxalFISGI5ZyszT3lNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBQ1ppcUhBNTdqVmxMR1JYeU1MVQpDWnV2MmZhNUY5aHkrL2hkM3k2bytpVUxIQXd3V1RuSTFTNUVoRWdiZXdFdDVLVkkydTc0N1BWdGw5b3M3Nmk5CjhoZUFPUnBMTlNmUjJDT0xrM0h1ODB4WDFmMjQvU0VFdFFxeGc3Zk91ZmZmemxnaW1NZDYzbUpuODNYRkd4bHAKK0oxdXN4SEdmNFhFUUxOTnp3S3c1WW1GaG05bEZjOHYyVTVkTC8wMG1vMWtWbmM1Y202SkIrbVZRSzJEOXJaYwpBSkNvQzk2UmtIaHJsM0VKVy9jMk0yakVkNzlVUjRhWFc1OFE1OUI5TzVZNmVOL1VPYU9kVHZHMjhvVEVCdStiCkcwNy8wb3BYcU1ZdUIvV084VTRjSUN1MlExY1BhaUlFL0ROdm5LajdmeS9XUWdybHlvOG5XejVWaXJwK09KYjQKd2JFPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==' credentialId: 'eks_credential', namespace: 'dev', serverUrl: 'https://oidc.eks.us-west-2.amazonaws.com/id/56EB7BC1822914D4C1A3DE75B0A9256E ')  {
                  sh "kubectl apply -f eks-deploy-from-ecr.yaml"
              }
            }
        }
    }
} 
          
