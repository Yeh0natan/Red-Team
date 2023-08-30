pipeline {
    agent any
	environment {
		DOCKERHUB_CREDENTIALS = credentials('dockerhub')
	}
    stages {
        stage('Build') {
            steps {
                sh 'docker build -t yehonatan111/reactapp_server ./server'
                sh 'docker build -t yehonatan111/reactapp_front ./frontend'
	    }
	}
        stage('Deploy Containers') {
            steps {
		sh 'docker run -p 3001:3001 --name reactapp_server yehonatan111/reactapp_server'
                sh 'sleep 15' // Give the containers some time to start up
		sh 'docker run -p 3000:3000 --name reactapp_front yehonatan111/reactapp_front'
                sh 'sleep 15' // Give the containers some time to start up
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
			    sh 'docker push yehonatan111/reactapp_server'
		    	sh 'docker push yehonatan111/reactapp_front'
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
