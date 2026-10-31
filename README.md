# End-to-End Java CI/CD Pipeline on AWS EC2

An automated continuous integration and continuous deployment (CI/CD) pipeline built with Jenkins, Maven, SonarQube, Nexus Repository Manager, and Apache Tomcat deployed on AWS infrastructure.

---

## Architecture Overview


                  +-------------------+
                  |   GitHub (SCM)    |
                  +---------+---------+
                            | (Push / Polling)
                            v
                  +-------------------+
                  |      Jenkins      |
                  +---------+---------+
                            |
     +----------------------+----------------------+
     |                      |                      |
     v                      v                      v
+------------------+  +-------------------+  +-------------------+
|  Maven Compile   |  |     SonarQube     |  |       Nexus       |
|  & JaCoCo Tests  |  |   Quality Gate    |  | Snapshot Registry |
+------------------+  +-------------------+  +-------------------+
|
v (SSH / SCP Deploy)
+-------------------+
| Apache Tomcat 10  |
|   (Docker / EC2)  |
+-------------------+


---

## Features

- **Automated SCM Triggers:** Tracks changes on branch `main` using Git SCM triggers.
- **Continuous Integration:** Compiles Java 17 source code and runs unit tests via Apache Maven.
- **Code Coverage & Quality:** JaCoCo produces code coverage reports; SonarQube scans code and enforces quality gate compliance.
- **Artifact Archiving:** Packages and publishes versioned snapshot `.war` files to Sonatype Nexus OSS.
- **Continuous Deployment:** Uses SSH Agent to securely push artifacts to the remote target host and redeploy Tomcat webapps.
- **Jakarta EE 10:** Modernized for Apache Tomcat 10 runtime using the `jakarta.servlet` specification.

---

## Pipeline Stages

| Stage | Tool | Description |
| :--- | :--- | :--- |
| **Checkout SCM** | Git | Clones the latest commit from the GitHub repository |
| **Compile & Test** | Maven / JaCoCo | Runs unit test suites and packages the `.war` artifact |
| **SonarQube Analysis** | SonarScanner | Executes SAST checks and pushes metrics to SonarQube |
| **Quality Gate** | SonarQube | Blocks downstream execution if quality criteria fail |
| **Deploy to Nexus** | Nexus Repository | Publishes the `.war` snapshot to the artifact registry |
| **Deploy to Tomcat** | SSH / Docker | Transfers `ROOT.war` and serves the live application |

---

## Application Verification & Outputs

### 1. Automated Pipeline Execution
<img width="958" height="476" alt="jenkins-pipeline-success" src="https://github.com/user-attachments/assets/016b6e14-925e-4c5e-9fa8-5fee4d6cc841" />


### 2. Application Home Page
<img width="612" height="256" alt="app-v2-home" src="https://github.com/user-attachments/assets/553349ec-a0a1-4c49-a4c6-95630fec531c" />


### 3. Greeting Endpoint (`/hello?name=Surya`)
<img width="507" height="208" alt="app-hello-endpoint" src="https://github.com/user-attachments/assets/9070e6d9-04fd-4f88-879d-5211094b7e51" />


### 4. Health Check Endpoint (`/health`)
<img width="458" height="224" alt="app-health-endpoint" src="https://github.com/user-attachments/assets/c2e891bf-d2d2-41e3-99cb-a99cf19244e8" />


---

## Tech Stack

- **Cloud Platform:** AWS EC2
- **Automation Server:** Jenkins (Declarative Pipeline)
- **Build Tool:** Apache Maven
- **Code Quality:** SonarQube Community
- **Artifact Management:** Sonatype Nexus OSS
- **Target Runtime:** Apache Tomcat 10.1 (Docker Container)
- **Language:** Java 17 (Jakarta Servlet 6.0)
