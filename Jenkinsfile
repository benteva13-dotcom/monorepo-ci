pipeline {
    agent any

    environment {
        SHORT_SHA = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
    }

    // Removed pollSCM — using webhook instead
    triggers { }

    options {
        timestamps()
        ansiColor('xterm')
    }

    stages {

        stage('Detect Changes') {
            steps {
                script {
                    try {
                        CHANGED = sh(script: "ci/detect_changes.sh", returnStdout: true).trim().split("\n")
                        echo "Changed services: ${CHANGED}"
                    } catch (err) {
                        error("Failed to detect changes: ${err}")
                    }
                }
            }
        }

        stage('Lint') {
            when { expression { CHANGED.size() > 0 } }
            steps {
                script {
                    CHANGED.each { service ->
                        try {
                            if (fileExists("${service}/package.json")) {
                                sh "ci/lint_node.sh ${service}"
                            }
                            if (fileExists("${service}/requirements.txt")) {
                                sh "ci/lint_python.sh ${service}"
                            }
                            if (fileExists("${service}/go.mod")) {
                                sh "ci/lint_go.sh ${service}"
                            }
                        } catch (err) {
                            error("Lint failed for ${service}: ${err}")
                        }
                    }
                }
            }
        }

        stage('Unit Tests') {
            when { expression { CHANGED.size() > 0 } }
            steps {
                script {
                    CHANGED.each { service ->
                        try {
                            if (fileExists("${service}/package.json")) {
                                sh "ci/test_node.sh ${service}"
                            }
                            if (fileExists("${service}/requirements.txt")) {
                                sh "ci/test_python.sh ${service}"
                            }
                            if (fileExists("${service}/go.mod")) {
                                sh "ci/test_go.sh ${service}"
                            }
                        } catch (err) {
                            error("Unit tests failed for ${service}: ${err}")
                        }
                    }
                }
            }
        }

        stage('Security Scans') {
            when { expression { CHANGED.size() > 0 } }
            steps {
                script {
                    try {
                        sh "ci/scan_secrets.sh"
                    } catch (err) {
                        error("Secret scan failed: ${err}")
                    }

                    CHANGED.each { service ->
                        try {
                            if (fileExists("${service}/package.json")) {
                                sh "ci/scan_node.sh ${service}"
                            }
                            if (fileExists("${service}/requirements.txt")) {
                                sh "ci/scan_python.sh ${service}"
                            }
                            if (fileExists("${service}/go.mod")) {
                                sh "ci/scan_go.sh ${service}"
                            }
                        } catch (err) {
                            error("Security scan failed for ${service}: ${err}")
                        }
                    }
                }
            }
        }

        stage('Docker Build') {
            when { expression { CHANGED.size() > 0 } }
            steps {
                script {
                    CHANGED.each { service ->
                        try {
                            def imageName = "benteva/${service}"
                            sh "ci/build_docker.sh ${service} ${imageName} ${SHORT_SHA}"
                        } catch (err) {
                            error("Docker build failed for ${service}: ${err}")
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            when { expression { CHANGED.size() > 0 } }
            steps {
                script {
                    echo "Deploying updated services..."
                    // Future deployment logic goes here
                }
            }
        }
    }

    post {
        success {
            sh "ci/notify.sh https://example.com/webhook 'Pipeline SUCCEEDED for commit ${SHORT_SHA}'"
        }
        failure {
            sh "ci/notify.sh https://example.com/webhook 'Pipeline FAILED for commit ${SHORT_SHA}'"
        }
        always {
            echo "Pipeline finished."
        }
    }
}
