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
                        withCredentials([file(credentialsId: 'hello-app-kubeconfig', variable: 'KUBECONFIG')]) {
                            sh '''
                                export BUILD_NUMBER=$(cat ../build.txt)
                                mv Deployment/deploy.yaml Deployment/deploy.yaml.tmp
                                cat Deployment/deploy.yaml.tmp | \
                                sed "s|\${KUBECONFIG}|${KUBECONFIG}|g; s|\${ENV}|${ENV}|g" > Deployment/deploy.yaml
                                rm -f Deployment/deploy.yaml.tmp
                                kubectl apply -f Deployment --kubeconfig "${KUBECONFIG}" -n "${ENV}"

                            '''
                        }
                    
                }
            }
        }
    }
}