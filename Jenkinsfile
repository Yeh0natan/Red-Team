pipeline {
    agent any
	environment {
		DOCKERHUB_CREDENTIALS = credentials('dockerhub')
		AWS_SECRET_KEY = params.get('awsecret')
	}
    stages {
		stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build') {
            steps {
                sh 'docker build -t yehonatan111/appserver ./server'
                sh 'docker build -t yehonatan111/appfront ./frontend'
				// Build image for Pytest
                sh 'docker build -t yehonatan111/apptest ./test'
            }
	    }
	}
        stage('Deploy Containers') {
            steps {
			sh 'docker run -d -p 3001:3001 yehonatan111/appserver'
            sh 'sleep 5' // Give the container some time to start up
			sh 'docker run -d -p 3000:3000 yehonatan111/appfront'
            sh 'sleep 5' // Give the container some time to start up
            }
        }
		stage('Run tests') {
            steps {
                // Run the apptest container and capture its exit code
                script {
                    def exitCode = sh(script: 'docker run yehonatan111/apptest', returnStatus: true)
                    if (exitCode == 0) {
                        echo 'Tests passed! Pipeline succeeded.'
                    } else {
                        error 'Tests failed! Pipeline failed.'
                    }
                }
            }
        }
	    stage('Login') {
	    	steps {
		    	sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
		    }
	    }
	    stage('Push') {
		    steps {
			sh 'docker push yehonatan111/appserver'
		    sh 'docker push yehonatan111/appfront'
		    }
	    }
	    stage('Remove images') {
		    steps {
			    sh 'docker kill $(docker ps -q)'
			    sh 'docker rmi -f yehonatan111/appserver'
			    sh 'docker rmi -f yehonatan111/appfront'
				sh 'docker rmi -f yehonatan111/apptest'
            }
		}
        stage('TF init&plan') {
            steps {
                sh 'terraform init'
                sh "terraform plan -var=\'AWS_SECRET_KEY=${AWS_SECRET_KEY}\'"
            }
	    }
        stage('TF Approval') {
            steps {
                sh "terraform apply -var=\'AWS_SECRET_KEY=${AWS_SECRET_KEY}\' -auto-approve"
            }
        }
    }
post {
 	always {
 		sh 'docker logout'
 	}
//         success {
//             echo "Tests passed, pipeline succeeded!"
//             cleanUpContainers()
//         }
//         failure {
//             echo "Tests failed, pipeline failed!"
//             cleanUpContainers()
//         }
//     }
    }
}
