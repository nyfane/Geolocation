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
                nexusArtifactUploader artifacts:
                 [[artifactId: '${POM_ARTIFACTID}',
                  classifier: '',
                   file: 'target/${POM_ARTIFACTID}-${POM_VERSION}.${POM_PACKAGING}',
                    type: '${POM_PACKAGING}']],
                     credentialsId: 'NexusID',
                      groupId: '${POM_GROUPID}',
                       nexusUrl: '172.105.109.189:8081/repository/biom/', 
                       nexusVersion: 'nexus3',
                       protocol: 'http', 
                       repository: ' maven-release',
                        version: ' ${POM_VERSION}'
            }
        }


    }
}