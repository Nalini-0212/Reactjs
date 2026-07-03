pipeline{
    agent any
    environment {
        DEV_REPO = "naliniselv/react-app-dev"
        PROD_REPO = "naliniselv/react-app-prod"
        EC2_IP = "54.160.167.129"
        CONTAINER_NAME = "react-app-container"
    }
    stages{
        stage('checkout to repository'){
            steps{
                git branch: "${env.BRANCH_NAME}", url: 'https://github.com/Nalini-0212/Reactjs.git'
            }
        }
        stage('build docker image'){
            steps{
                echo "Building docker image"
                sh "docker build -t react-app:${BUILD_NUMBER} ."
            }
        }
        stage('push to dev docker hub repo'){
                when{
                    branch 'dev'
                }
                steps{
                    echo "Building docker image for dev branch and pushing to docker hub..."
                    withCredentials([usernamePassword(credentialsId: 'dockerhubcred', usernameVariable:'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]){
                        sh """
                        echo "Logging into Docker Hub"
                        echo "${DOCKERHUB_PASSWORD}" | docker login -u "${DOCKERHUB_USERNAME}" --password-stdin
                        docker tag react-app:${BUILD_NUMBER} ${env.DEV_REPO}:${BUILD_NUMBER}
                        docker push ${env.DEV_REPO}:${BUILD_NUMBER}
                    """
                }

            }
        }
        stage('push to prod docker hub repo'){
                when{
                    branch 'main'
                }
                steps{
                    echo "Building docker image for main branch and pushing to docker hub.."
                    withCredentials([usernamePassword(credentialsId: 'dockerhubcred', usernameVariable:'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]){
                        sh """
                        echo "Logging into Docker Hub"
                        echo "${DOCKERHUB_PASSWORD}" | docker login -u "${DOCKERHUB_USERNAME}" --password-stdin
                        docker tag react-app:${BUILD_NUMBER} ${env.PROD_REPO}:${BUILD_NUMBER}
                        docker push ${env.PROD_REPO}:${BUILD_NUMBER}
                    """
                }
            }
        }
        stage('deploy to EC2 Server'){
            steps{
                when{
                    branch 'main'
                }
                echo "Deploying to EC2 server"
                sshagent(['ec2-ssh-key']){
                    withCredentials([usernamePassword(credentialsId: 'dockerhubcred', usernameVariable:'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]){
                    sh """
                    ssh -o StrictHostKeyChecking=no ubuntu@${env.EC2_IP} '
                    echo "Logging into Docker Hub"
                    echo "${DOCKERHUB_PASSWORD}" | docker login -u "${DOCKERHUB_USERNAME}" --password-stdin
                    ssh -o StrictHostKeyChecking=no ubuntu@${env.EC2_IP} '
                    docker pull ${env.PROD_REPO}:${BUILD_NUMBER}
                    docker stop ${env.CONTAINER_NAME}
                    docker rm ${env.CONTAINER_NAME}
                    docker run -d --name ${env.CONTAINER_NAME} -p 80:80 ${env.PROD_REPO}:${BUILD_NUMBER}
                    '
                    """
                }
            }
        }
    }

}