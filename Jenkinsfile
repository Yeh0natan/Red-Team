pipeline {
    agent any
	environment {
		DOCKERHUB_CREDENTIALS = credentials('dockerhub')
	}
    stages {
        stage('Build') {
            steps {
                sh 'docker build -t yehonatan111/appserver ./server'
                sh 'docker build -t yehonatan111/appfront ./frontend'
	    }
	}
        stage('Deploy Containers') {
            steps {
		sh 'docker run -d -p 3201:3001 yehonatan111/appserver'
                sh 'sleep 5' // Give the container some time to start up
		sh 'docker run -d -p 3200:3000 yehonatan111/appfront'
                sh 'sleep 5' // Give the container some time to start up
            }
        }
//        stage('Run Tests') {
//            steps {
//                script {
//                    def pytestExitCode = sh(script: "docker run --rm yehonatan111/reactapp_pytest", returnStatus: true)
//                
//                    if (pytestExitCode != 0) {
//                        error("Pytest failed with exit code: ${pytestExitCode}")
//                    }
//                }
//            }
//        }
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
//	    stage('Remove images') {
//		steps {
//			sh 'docker kill $(docker ps -q)'
//			sh 'docker rmi -f yehonatan111/serverapp'
//			sh 'docker rmi -f yehonatan111/frontapp'
//		}
//	    }
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
