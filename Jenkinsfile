pipeline {
    triggers {
        pollSCM ('* * * * *')
    }
    agent any
    tools{
        maven 'M2_HOME'
    }
    stages{
        stage ('checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/nyfane/Geolocation.git'
            }
        }
        stage ('maven build') {
            steps {
                sh 'mvn clean install package'

            }
        }
        stage ('test') {
            steps {
                sh 'mvn test'
            }
        }
        //Upload artifact to nexus
        stage ('upload artifact to nexus') {
            steps {
                script{
                   def mavenPom = readMavenPom.xml: 'pom.xml'
                   nexusArtifactUploader artifacts: [[artifactId: '${mavenPom.artifactId}', classifier: '', file: 'target/${mavenPom.artifactorId}-${mavenPom.version}.${mavenPom.packaging}', type: '${mavenPom.packaging}']], credentialsId: 'NexusID', groupId: '${mavenPom.groupID}', nexusUrl: '172.105.109.189:8081/repository/biom/', nexusVersion: 'nexus3', protocol: 'http', repository: ' biom', version: ' ${mavenPom.version}'  
                }
               
            }
        }


    }
}