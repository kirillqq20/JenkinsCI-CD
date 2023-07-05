pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'git@github.com:kirillqq20/jenkinsCI-CD.git'
            }
        }
        
        stage('Load Variables') {
            steps {
                script {
                    def variableFile = readFile('./variables.yml')
                    def variables = readYaml(text: variableFile)

                    // Set the file-variable as an environment variable
                    env.APP_NAME = variables.app_name
                    env.DOCKER_USER = variables.docker_user
                    env.APP_VERSION = variables.app_version
                    env.DC_FILE = variables.dc_file
                    env.SERVICE_NAME = variables.service_name
                }
            }
        }
        
        stage('Build') {
            steps {
                sh "docker build -t ${env.DOCKER_USER}/${env.APP_NAME}:${env.APP_VERSION} ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                // Log in to Docker Hub with token
                withDockerRegistry(url: 'https://index.docker.io/v1/', credentialsId: 'dockerhub') {
                    // Push the Docker images to Docker Hub
                    sh "docker push ${env.DOCKER_USER}/${env.APP_NAME}:${env.APP_VERSION}"
                }
            }
        }
        
        stage('Deploy in local server') {
            steps {
                script {
                    sh """
                        docker-compose -f ${env.DC_FILE} down ${env.SERVICE_NAME} || true
                        docker-compose -f ${env.DC_FILE} pull ${env.SERVICE_NAME}
                        docker network create subaru-network || true
                        docker-compose -f ${env.DC_FILE} up -d ${env.SERVICE_NAME}
                    """
                }
            }
        }
    }
}
