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
                    withCredentials([
                        [$class: 'VaultUsernamePasswordCredentialBinding', credentialsId: 'vault-scw', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID'],
                        [$class: 'VaultStringCredentialBinding', credentialsId: 'vault-swc-project-id', variable: 'SCW_DEFAULT_PROJECT_ID']
                    ]) {
                        sh 'terraform init'
                    }
                }
            }
        }
        stage('Plan') {
            steps {
                script {
                    withCredentials([
                        [$class: 'VaultUsernamePasswordCredentialBinding', credentialsId: 'vault-scw', passwordVariable: 'SCW_SECRET_KEY', usernameVariable: 'SCW_ACCESS_KEY'],
                        [$class: 'VaultStringCredentialBinding', credentialsId: 'vault-swc-project-id', variable: 'SCW_DEFAULT_PROJECT_ID']
                    ]) {
                        sh '''
                        export AWS_ACCESS_KEY_ID=$SCW_ACCESS_KEY
                        export AWS_SECRET_ACCESS_KEY=$SCW_SECRET_KEY
                        terraform plan -no-color -out=tfplan
                        '''
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
                withCredentials([
                    [$class: 'VaultUsernamePasswordCredentialBinding', credentialsId: 'vault-scw', passwordVariable: 'SCW_SECRET_KEY', usernameVariable: 'SCW_ACCESS_KEY'],
                    [$class: 'VaultStringCredentialBinding', credentialsId: 'vault-swc-project-id', variable: 'SCW_DEFAULT_PROJECT_ID']
                ]) {
                        sh '''
                        export AWS_ACCESS_KEY_ID=$SCW_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=$SCW_SECRET_ACCESS_KEY
                        terraform ${params.Command} -no-color -auto-approve
                        '''
                }
            }
        }
    }
}
