pipeline{
    environment {
        registry = "pedanov/task6"
        registryCredential = 'dockerhub_id'
        dockerImage = ''        
    }
    
    agent any
    // {
    //     node{
    //         label "CentOS-Agent1"
    //     }
    // }

    stages{
        stage("Check Docker access in docker agent on the main node"){
            agent { 
                label 'local-docker'
            }
            steps{                
                sh "docker ps -a"                
            }
            post{
                always{
                    echo "========always========"
                }
                success{
                    echo "========A executed successfully========"
                }
                failure{
                    echo "========A execution failed========"
                }
            }
        }
        
        stage("Clone git repo"){
            agent { 
                label 'local-docker'
            }
            steps {
                checkout scm                
            }
            post{
                always{
                    echo "========always========"
                }
                success{
                    echo "========A executed successfully========"
                }
                failure{
                    echo "========A execution failed========"
                }
            }
        }

        stage("Build image") {
            agent { 
                label 'local-docker'
            }
            environment{
                encryptedPassword = credentials('encrypted_password')
            }
            steps{
                dir('./Task4/'){
                    echo "Encrypted password is '$encryptedPassword'"
                    script {
                        dockerImage = docker.build(registry + ":$BUILD_NUMBER", "--build-arg PASSWORD=$encryptedPassword .")
                    }
                }
            }
            post{
                always{
                    echo "========always========"
                }
                success{
                    echo "========A executed successfully========"
                }
                failure{
                    echo "========A execution failed========"
                }
            }
        }

        stage("Push image to docker registry") {
            agent { 
                label 'local-docker'
            }
            steps{
                script {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push()
                    }
                }
            }
            post{
                always{
                    echo "========always========"
                }
                success{
                    echo "========A executed successfully========"
                }
                failure{
                    echo "========A execution failed========"
                }
            }
        }

        stage("Clean up") {
            agent { 
                label 'local-docker'
            }
            steps{
                sh "docker rmi $registry:$BUILD_NUMBER"
            }
        }

        stage("Deploy image on CentOS VM") {
            agent { 
                label 'remote-centos'
            }
            environment{
                CONTAINER="task6"
                PORT=80
            }
            steps {
                sh "docker stop ${CONTAINER} || true && docker rm ${CONTAINER} || true"
                sh "docker run -d \
                    --name ${CONTAINER} \
                    --publish ${PORT}:80 \
                    ${registry}:${BUILD_ID}"
            }
        }
    }

    post{
        always{
            echo "========always========"
        }
        success{
            echo "========pipeline executed successfully ========"
        }
        failure{
            echo "========pipeline execution failed========"
        }
    }
}
