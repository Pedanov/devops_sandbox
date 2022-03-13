pipeline{
    agent{
        label "CentOS-Agent1"
    }
    stages{
        stage("A"){
            steps{
                // echo "Current date: ${(date)}"
                // docker ps -a
                echo "here it is"
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