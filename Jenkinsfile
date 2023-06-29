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
          env.DOCKER_IMAGE = variables.docker_image
          env.DC_FILE = variables.dc_file
        }
      }
    }
        stage('Delete previous build') {
            steps {
                script {
                    def previousBuildExists = false
                    try {
                        sh "docker inspect $DOCKER_IMAGE"
                        previousBuildExists = true
                    } catch (Exception ignored) {
                        // Docker image does not exist, no need to delete
                    }

                    if (previousBuildExists) {
                        sh "docker rmi -f $DOCKER_IMAGE"
                    } else {
                        echo "No previous build found, skipping deletion."
                    }
                }
            }
        }

        stage('Build') {
            steps {
                    sh "docker build -t $DOCKER_IMAGE ."
                }
        }

        stage('Push to Docker Hub') {
            steps {
                // Log in to Docker Hub with token
                withDockerRegistry(url: 'https://index.docker.io/v1/', credentialsId: 'dockerhub') {
                // Push the Docker images to Docker Hub
                sh 'docker push $DOCKER_IMAGE'
                }
            }
        }
        
        stage('Deploy in local server') {
            steps {
                script {
                    sh """
                        docker-compose -f \${DC_FILE} down \${APP_NAME} || true
                        docker-compose -f \${DC_FILE} pull \${APP_NAME}
                        docker network create test-network || true
                        docker-compose -f \${DC_FILE} up -d \${APP_NAME}
                    """
                }
            }
        }

    }
}
