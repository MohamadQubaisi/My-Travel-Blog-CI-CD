pipeline {
    agent any
    stages {
        stage('build') {
            steps {
                echo 'building'
                script{
                        withCredentials([usernamePassword(credentialsId: 'docker-login', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                            sh '''
                                docker login -u ${USERNAME} -p ${PASSWORD}
                                docker build -t mohamadqubaisi/hello-app:v${BUILD_NUMBER} .
                                docker push mohamadqubaisi/hello-app:v${BUILD_NUMBER}
                                echo ${BUILD_NUMBER} > ../build.txt
                            '''
                        
                    }

                }
            }
        }
        stage('deploy') {
            steps {
                echo 'deploying'
                script {
                        withCredentials([file(credentialsId: 'hello-app-kubeconfig', variable: 'KUBECONFIG') ,
                        usernamePassword(credentialsId: 'aws_credentials', usernameVariable: 'aws_access_key_id', passwordVariable: 'aws_secret_access_key')]) {
                            sh '''
                                export AWS_ACCESS_KEY_ID=${aws_access_key_id}
                                export AWS_SECRET_ACCESS_KEY=${aws_secret_access_key}
                                export BUILD_NUMBER=$(cat ../build.txt)
                                mv Deployment/deploy.yaml Deployment/deploy.yaml.tmp
                                cat Deployment/deploy.yaml.tmp | \
                                sed "s|{BUILD_NUMBER}|${BUILD_NUMBER}|g" > Deployment/deploy.yaml
                                rm -f Deployment/deploy.yaml.tmp
                                kubectl apply -f Deployment --kubeconfig "${KUBECONFIG}" 

                            '''
                        }
                    
                }
            }
        }
    }
}