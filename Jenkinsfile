pipeline {
    agent any

    tools {
        maven 'maven-3.9'
    }

    environment {
        NEXUS_CREDS = credentials('nexus-creds')
        TOMCAT_HOST = '<tomcat-private-ip>'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Compile & Test') {
            steps {
                sh 'mvn clean verify'
            }
            post {
                always {
                    junit allowEmptyResults: true, testResults: '**/target/surefire-reports/*.xml'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:sonar'
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Deploy to Nexus') {
            steps {
                sh '''
                    mkdir -p .mvn
                    cat << 'EOF' > .mvn/settings.xml
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
  <servers>
    <server>
      <id>nexus-snapshots</id>
      <username>${env.NEXUS_CREDS_USR}</username>
      <password>${env.NEXUS_CREDS_PSW}</password>
    </server>
  </servers>
</settings>
EOF

                    mvn deploy -s .mvn/settings.xml -DskipTests \
                        -DaltSnapshotDeploymentRepository=nexus-snapshots::http://nexus:8081/repository/maven-snapshots/
                '''
            }
            post {
                always {
                    sh 'rm -f .mvn/settings.xml'
                }
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                sshagent(['tomcat-ssh-key']) {
                    sh '''
                        mkdir -p ~/.ssh
                        ssh-keyscan -H ${TOMCAT_HOST} >> ~/.ssh/known_hosts 2>/devool || true
                        scp -o StrictHostKeyChecking=no target/devops-demo.war ubuntu@${TOMCAT_HOST}:/opt/tomcat/webapps/ROOT.war
                    '''
                }
            }
        }
    }
}
