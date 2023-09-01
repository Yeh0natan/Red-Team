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
		sh 'docker run -d -p 3001:3001 yehonatan111/appserver'
                sh 'sleep 5' // Give the container some time to start up
		sh 'docker run -d -p 3000:3000 yehonatan111/appfront'
                sh 'sleep 5' // Give the container some time to start up
            }
        }
//        stage('Run Tests') {
//            steps {
//                sh 'python3 -m pytest --junitxml==testresault.xml test/test.py'
//            }
//       }
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
            }
		}
        stage('TF init&plan') {
            steps {
                sh 'terraform init'
                sh 'terraform plan -var-file=linux.sh -out linux.sh'
            }
	    }
        stage('TF Approval') {
            steps {
                sh 'terraform apply --auto-approve'
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
