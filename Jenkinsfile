pipeline{
    agent any
    stages {
        stage('build') {
            steps{
                sh 'mvn clean install'
            }
        }

        stage('release') {
            steps{
                rtUpload (
                serverId: 'artifactory-1',
                spec: '''{
                    "files": [
                        {
                        "pattern": "target/*.jar",
                        "target": "maven-artifacts/"
                        }
                    ]
                    }'''
                )
                rtPublishBuildInfo (
                    serverId: 'artifactory-1'
                )
            }
        }

        stage('deploy'){
            steps{
                //deploy to app-vm
                withCredentials([usernamePassword(credentialsId:'454d90a2-8cbb-4de7-9d13-6e470cb90ff9', passwordVariable: 'PASSWORD', usernameVariable: 'SSH_CRED')]) {
                    // step all the containers
                    script{
                        containers = sh(returnStdout: true, script: 'sshpass -p ${PASSWORD} ssh ${SSH_CRED} /usr/bin/docker ps -aq').replaceAll("\n", " ")
                    }
                    sh ("sshpass -p ${PASSWORD} ssh ${SSH_CRED} docker stop $containers")
                    sh 'sshpass -p ${PASSWORD} scp Dockerfile target/*.jar ${SSH_CRED}:~'
                    sh 'sshpass -p ${PASSWORD} ssh ${SSH_CRED} "docker build . -t spring-app:v1"'
                    sh 'sshpass -p ${PASSWORD} ssh ${SSH_CRED} "docker  run -itd -p 8080:8080 spring-app:v1"'
                }
            }
        }
    }
}
