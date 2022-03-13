pipeline{
    agent{
        label "CentOS-Agent1" // Change to internal docker agent
    }
    stages{
        stage("A"){
            steps{
                echo "Current date: ${(date)}"
                docker ps -a
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