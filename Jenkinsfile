pipeline {
    agent any
	environment {
		DOCKERHUB_CREDENTIALS = credentials('dockerhub')
	}
    stages {
        stage('Build') {
            steps {
                sh 'docker build -t yehonatan111/serverapp ./server'
                sh 'docker build -t yehonatan111/frontapp ./frontend'
	    }
	}
        stage('Deploy Containers') {
            steps {
		sh 'docker run -d -p 3001:3001 yehonatan111/serverapp'
                sh 'sleep 5' // Give the container some time to start up
		sh 'docker run -d -p 3000:3000 yehonatan111/frontapp'
                sh 'sleep 5' // Give the container some time to start up
            }
        }
        stage('Run Tests') {
            steps {
                script {
                    def pytestExitCode = sh(script: "docker run --rm yehonatan111/reactapp_pytest", returnStatus: true)
                
                    if (pytestExitCode != 0) {
                        error("Pytest failed with exit code: ${pytestExitCode}")
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
			sh 'docker push yehonatan111/serverapp'
		    	sh 'docker push yehonatan111/frontapp'
		    }
	    }
	    stage('Remove images') {
		steps {
			sh 'docker kill $(docker ps -q)'
			sh 'docker rmi -f yehonatan111/serverapp'
			sh 'docker rmi -f yehonatan111/frontapp'
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
def cleanUpContainers() {
    script {
        sh "docker stop reactapp_server reactapp_front"
        sh "docker rm reactapp_server reactapp_front"
    }
}
