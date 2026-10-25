pipeline {
    agent any

    tools {
        maven 'maven-3.9'
    }

    environment {
        NEXUS_CREDS = credentials('nexus-creds')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Compile & Test') {
            steps {
                sh 'mvn clean test jacoco:report'
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh 'mvn sonar:sonar'
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

        stage('Deploy to Nexus') {
            steps {
                sh '''
                    mvn clean deploy -DskipTests \
                    -DaltDeploymentRepository=nexus-releases::default::http://${NEXUS_CREDS_USR}:${NEXUS_CREDS_PSW}@nexus:8081/repository/maven-releases/
                '''
            }
        }
    }
}
