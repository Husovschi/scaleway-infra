pipeline {
    agent {
        label 'terraform-docker-agent'
    }

    parameters {
        choice(name: 'Command', choices: ['plan', 'apply', 'destroy'], description: '')
    }

    stages {
        stage('Init') {
            steps {
                script {
                    withCredentials([[$class: 'VaultUsernamePasswordCredentialBinding', credentialsId: 'vault-scw', passwordVariable: 'SCW_SECRET_ACCESS_KEY', usernameVariable: 'SCW_ACCESS_KEY_ID']]) {
                        sh 'terraform init'
                    }
                }
            }
        }
        stage('Plan') {
            steps {
                script {
                    withCredentials([[$class: 'VaultUsernamePasswordCredentialBinding', credentialsId: 'vault-scw', passwordVariable: 'SCW_SECRET_ACCESS_KEY', usernameVariable: 'SCW_ACCESS_KEY_ID']]) {
                        sh 'terraform plan -no-color -out=tfplan'
                    }
                }
            }
        }

        stage('Approval') {
            when {
                not {
                    equals expected: 'plan', actual: params.Command
                }
            }
            steps {
                script {
                    input message: 'Do you want to apply the plan?'
                }
            }
        }

        stage('Run command') {
            when {
                not {
                    equals expected: 'plan', actual: params.Command
                }
            }
            steps {
                withCredentials([[$class: 'VaultUsernamePasswordCredentialBinding', credentialsId: 'vault-scw', passwordVariable: 'SCW_SECRET_ACCESS_KEY', usernameVariable: 'SCW_ACCESS_KEY_ID']]) {
                    sh 'terraform ' + params.Command + ' -no-color -auto-approve'
                }
            }
        }
    }
}
