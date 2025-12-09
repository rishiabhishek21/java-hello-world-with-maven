pipeline {
  agent any
  parameters {
    choice(name: 'DEPLOY_ENV', choices: ['dev', 'qa', 'staging', 'prod'], description: 'Select environment to deploy to')
    choice(name: 'IMAGE_TAG', choices: ['v1', 'v2', 'latest'], description: 'Select Docker image tag')
    booleanParam(name: 'RUN_DEPLOY', defaultValue: false, description: 'If true, run the Deploy stage after push')
  }
  environment {
    GROUP_ID      = 'com.example'
    ARTIFACT_ID   = 'jb-hello-world-maven'
    VERSION       = '0.2.0'
    JAR_FILE      = 'jb-hello-world-maven-0.2.0.jar'
    NEXUS_BASE    = 'http://172.31.45.93:8081'
    NEXUS_REPO    = 'maven-releases'
    NEXUS_CREDS   = 'nexus-admin-creds'
    DOCKER_CREDS  = 'docker_creds'
  }

  stages {
    stage('Checkout') {
      steps {
        deleteDir()
        sh 'git clone https://github.com/rishiabhishek21/java-hello-world-with-maven.git'
      }
    }

    stage('Build') {
      steps {
        dir('java-hello-world-with-maven') {
          sh 'mvn -B clean package -DskipTests'
        }
      }
    }

    stage('Upload to Nexus (using env variable JAR_FILE)') {
      steps {
        dir('java-hello-world-with-maven/target') {

          withCredentials([usernamePassword(credentialsId: env.NEXUS_CREDS, usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASS')]) {

            sh """
              echo "Uploading ${JAR_FILE} to ${NEXUS_REPO}..."
              curl -v -u "${NEXUS_USER}:${NEXUS_PASS}" -X POST "${NEXUS_BASE}/service/rest/v1/components?repository=${NEXUS_REPO}" \\
                -F "maven2.groupId=${GROUP_ID}" \\
                -F "maven2.artifactId=${ARTIFACT_ID}" \\
                -F "maven2.version=${VERSION}" \\
                -F "maven2.asset1=@${JAR_FILE}" \\
                -F "maven2.asset1.extension=jar"
            """
          }
        }
      }
    }
    stage('Docker build'){
        steps{
             withCredentials([usernamePassword(credentialsId: env.DOCKER_CREDS, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
              sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
            dir('java-hello-world-with-maven'){
            sh 'docker build . -t rishiabhishek88/java-hello-world:${BUILD_NUMBER}'
            sh 'docker push rishiabhishek88/java-hello-world:v1'
            }
             }
        }
  }
 
  }
  
  post {
    success { echo "Upload successful." }
    failure { echo "Upload failed — check logs." }
  }
}
