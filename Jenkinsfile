pipeline {
    agent any

    environment {
        SHORT_SHA = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
    }

    triggers {
        pollSCM('* * * * *')
    }

    stages {

        stage('Detect Changes') {
            steps {
                script {
                    CHANGED = sh(script: "ci/detect_changes.sh", returnStdout: true).trim().split("\n")
                    echo "Changed services: ${CHANGED}"
                }
            }
        }

        stage('Lint') {
            steps {
                script {
                    CHANGED.each { service ->
                        if (fileExists("${service}/package.json")) {
                            sh "ci/lint_node.sh ${service}"
                        }
                        if (fileExists("${service}/requirements.txt")) {
                            sh "ci/lint_python.sh ${service}"
                        }
                        if (fileExists("${service}/go.mod")) {
                            sh "ci/lint_go.sh ${service}"
                        }
                    }
                }
            }
        }

        stage('Unit Tests') {
            steps {
                script {
                    CHANGED.each { service ->
                        if (fileExists("${service}/package.json")) {
                            sh "ci/test_node.sh ${service}"
                        }
                        if (fileExists("${service}/requirements.txt")) {
                            sh "ci/test_python.sh ${service}"
                        }
                        if (fileExists("${service}/go.mod")) {
                            sh "ci/test_go.sh ${service}"
                        }
                    }
                }
            }
        }

        stage('Security Scans') {
            steps {
                script {
                    sh "ci/scan_secrets.sh"

                    CHANGED.each { service ->
                        if (fileExists("${service}/package.json")) {
                            sh "ci/scan_node.sh ${service}"
                        }
                        if (fileExists("${service}/requirements.txt")) {
                            sh "ci/scan_python.sh ${service}"
                        }
                        if (fileExists("${service}/go.mod")) {
                            sh "ci/scan_go.sh ${service}"
                        }
                    }
                }
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    CHANGED.each { service ->
                        def imageName = "benteva/${service}"
                        sh "ci/build_docker.sh ${service} ${imageName} ${SHORT_SHA}"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploy step placeholder"
            }
        }
    }

    post {
        always {
            script {
                echo "Sending notification..."
                sh "ci/notify.sh https://example.com/webhook 'Pipeline finished for commit ${SHORT_SHA}'"
            }
        }
    }
}
