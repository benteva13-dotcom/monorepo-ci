pipeline {
    agent any

    stages {

        stage('Detect Changes') {
            steps {
                script {
                    def diff = sh(script: "git diff --name-only origin/main...HEAD", returnStdout: true).trim()
                    SERVICES = []

                    ["user-service", "transaction-service", "notification-service"].each { svc ->
                        if (diff.readLines().any { it.startsWith("${svc}/") }) {
                            SERVICES << svc
                        }
                    }

                    echo "Changed services: ${SERVICES}"
                }
            }
        }

        stage('Lint') {
            when { expression { SERVICES.size() > 0 } }
            steps {
                script {
                    parallel SERVICES.collectEntries { svc ->
                        ["Lint ${svc}": { sh "bash shared/ci/lint.sh ${svc}" }]
                    }
                }
            }
        }

        stage('Test') {
            when { expression { SERVICES.size() > 0 } }
            steps {
                script {
                    parallel SERVICES.collectEntries { svc ->
                        ["Test ${svc}": { sh "bash shared/ci/test.sh ${svc}" }]
                    }
                }
            }
        }

        stage('Security Scan') {
            when { expression { SERVICES.size() > 0 } }
            steps {
                script {
                    parallel SERVICES.collectEntries { svc ->
                        ["Scan ${svc}": { sh "bash shared/ci/scan.sh ${svc}" }]
                    }
                }
            }
        }

        stage('Docker Build') {
            when { expression { SERVICES.size() > 0 } }
            steps {
                script {
                    parallel SERVICES.collectEntries { svc ->
                        ["Build ${svc}": {
                            sh """
                                docker build -t ${svc}:ci-\$(git rev-parse --short HEAD) ${svc}
                            """
                        }]
                    }
                }
            }
        }
    }
}