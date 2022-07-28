pipeline (
    agent any
    tools (
        maven 'M2_HOME'
    )
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
    }
)