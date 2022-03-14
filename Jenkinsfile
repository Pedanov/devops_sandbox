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
        stage("Check Docker access"){
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
            steps {
                checkout scm
                // git 'https://github.com/Pedanov/devops_sandbox.git'
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
            steps{
                dir('./Task4/'){
                    withCredentials([string(credentialsId: 'encrypted_password', variable: 'PASSWORD')]) {
                        echo "Encrypted password is '${PASSWORD}'"
                        script {
                            dockerImage = docker.build(registry + ":$BUILD_NUMBER", "--build-arg PASSWORD=${PASSWORD}")                                      
                        }
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

        stage("Deploy image") {
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

        // stage("Clean up") {
        //     steps{
        //         sh "docker rmi $registry:$BUILD_NUMBER"
        //     }
        // }
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
