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
![Jenkins Pipeline](docs/screenshots/jenkins-pipeline-success.png)

### 2. Application Home Page
![DevOps Demo App - Home](docs/screenshots/app-v2-home.png)

### 3. Greeting Endpoint (`/hello?name=Surya`)
![Greeting Endpoint](docs/screenshots/app-hello-endpoint.png)

### 4. Health Check Endpoint (`/health`)
![Health Check Endpoint](docs/screenshots/app-health-endpoint.png)

---

## Tech Stack

- **Cloud Platform:** AWS EC2
- **Automation Server:** Jenkins (Declarative Pipeline)
- **Build Tool:** Apache Maven
- **Code Quality:** SonarQube Community
- **Artifact Management:** Sonatype Nexus OSS
- **Target Runtime:** Apache Tomcat 10.1 (Docker Container)
- **Language:** Java 17 (Jakarta Servlet 6.0)
