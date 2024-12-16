pipeline{
    agent{
        label "jenkins-agent"
    }
    tools {
        jdk 'Java17'
        maven 'Maven3'
    }
    environment {
        APP_NAME = "minhnhan548"
        RELEASE = "1.0.0"
        DOCKER_USER = "minhnhan548"
        DOCKER_PASS = 'dockerhub'
        IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
        //IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"

    }
    stages{
        stage("Cleanup Workspace"){
            steps {
                cleanWs()
            }

        }
        stage("Checkout from SCM"){
            steps {
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/nhanalvth/minhnhan548'
            }

        }
        stage("Build Application"){
            steps {
                sh "mvn clean package"
            }

        }

        stage("Test Application"){
            steps {
                sh "mvn test"
            }

        }
        stage("Sonarqube Analysis") {
            steps {
                script {
                    withSonarQubeEnv(credentialsId: 'jenkins-sonarqube-token') {
                        sh "mvn sonar:sonar"
                    }
                }
            }

        }
        /*stage("Quality Gate") {
            steps {
                script {
                    def qualityGateStatus = waitForQualityGate(credentialsId: 'jenkins-sonarqube-token')
                    if (qualityGateStatus == 'OK') {
                        echo "Quality Gate Passed"
                    } else {
                        echo "Quality Gate Failed"
                        currentBuild.result = 'FAILURE'
                        // Dừng pipeline nếu không đạt chất lượng
                        error("Quality Gate failed, stopping pipeline")
                    }
                }
            }
        }*/
        stage("Build & Push Docker Image") {
            steps {
                script {
                    def IMAGE_NAME = "${DOCKER_USER}/${APP_NAME}"
                    def IMAGE_TAG = "${RELEASE}-${env.BUILD_NUMBER}"
                    
                    docker.withRegistry('', DOCKER_PASS) {
                        def docker_image = docker.build("${IMAGE_NAME}")
                        docker_image.push("${IMAGE_TAG}")
                        docker_image.push('latest')
                    }
                }
            }
        }


    }
    
}