pipeline {

    agent any

    tools {
        maven 'Maven'
    }

    stages {

        stage('Git Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/BuntyRaghani/spring-boot-hello-world.git'
            }
        }

        stage('Maven Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Maven Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh '''
                       mvn org.sonarsource.scanner.maven:sonar-maven-plugin:sonar \
                      -Dsonar.projectKey=maven-java \
                      -Dsonar.projectName=maven-java
                    '''
                }
            }
        }
        stage('Quality Gate') {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
        }
    }
}


        stage('Publish to Nexus') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'nexus',
                    usernameVariable: 'NEXUS_USER',
                    passwordVariable: 'NEXUS_PASS'
                )]) {

                    sh '''
                    cat > settings.xml <<EOF
<settings>
  <servers>
    <server>
      <id>nexus</id>
      <username>${NEXUS_USER}</username>
      <password>${NEXUS_PASS}</password>
    </server>
  </servers>
</settings>
EOF

                    mvn deploy \
                      -DskipTests \
                      -DaltDeploymentRepository=nexus::default::http://172.17.0.4:8081/repository/maven-snapshots/ \
                      --settings settings.xml
                    '''
                }
            }
        }
        
    }

    post {
        always {
            junit '**/target/surefire-reports/*.xml'
        }
    }
}
