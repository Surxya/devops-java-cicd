pipeline {
    agent any

    tools {
        maven 'maven-3.9'
    }

    environment {
        NEXUS_CREDS = credentials('nexus-creds')
        TOMCAT_HOST = "${env.EC2_HOST}"
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
    <server>
      <id>nexus-releases</id>
      <username>${env.NEXUS_CREDS_USR}</username>
      <password>${env.NEXUS_CREDS_PSW}</password>
    </server>
  </servers>
</settings>
EOF

                    mvn deploy -s .mvn/settings.xml -DskipTests \
                        -DaltSnapshotDeploymentRepository=nexus-snapshots::http://nexus:8081/repository/maven-snapshots/ \
                        -DaltReleaseDeploymentRepository=nexus-releases::http://nexus:8081/repository/maven-releases/
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
                        if [ -z "$TOMCAT_HOST" ] || [ "$TOMCAT_HOST" = "null" ]; then
                            echo "TOMCAT_HOST is not set - define EC2_HOST in Manage Jenkins > System"
                            exit 1
                        fi

                        mkdir -p ~/.ssh
                        ssh-keyscan -H "$TOMCAT_HOST" >> ~/.ssh/known_hosts

                        scp target/devops-demo.war ubuntu@"$TOMCAT_HOST":/tmp/ROOT.war

                        ssh ubuntu@"$TOMCAT_HOST" '
                            sudo rm -rf /opt/tomcat/webapps/ROOT /opt/tomcat/webapps/ROOT.war &&
                            sudo mv /tmp/ROOT.war /opt/tomcat/webapps/ROOT.war &&
                            sudo chown tomcat:tomcat /opt/tomcat/webapps/ROOT.war
                        '
                    '''
                }
            }
        }
    }
}
