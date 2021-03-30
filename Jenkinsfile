pipeline {
    agent any
    tools { 
        maven 'Maven' 
        jdk 'jdk' 
    }
    stages {
        stage('Git Clone') {
            steps {
                git 'https://github.com/srikantakapuri/DevOps-Demo-WebApp.git'
            }
        }
        stage('Code compile') {
            steps {
               sh "mvn compiler:compile"
            }
        }
        stage('Code Package') {
            steps {
               sh "mvn clean install"
            }
        }
        stage ('artifactory & Dockerhub upload') {
    parallel {
       stage("artifactory upload"){
    	    steps{
    		      
                rtMavenDeployer (
                    id: 'deployer-unique-id',
                    serverId: 'artifactory',
                    releaseRepo: 'libs-release-local',
                    snapshotRepo: 'libs-snapshot-local'
                )
                rtMavenRun (
                    pom: 'pom.xml',
                    goals: 'clean install',
                    deployerId: 'deployer-unique-id'
                )
    	       rtPublishBuildInfo (
                    serverId: "artifactory"
                )
                slackSend channel: '#alerts', message: 'Artifactory upload completed' 
    	    }
    	}
    	stage('Push test image to DockerHub') {
            steps {
                sshPublisher(publishers: [sshPublisherDesc(configName: 'Test-env', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'ansible-playbook -i /etc/ansible/hosts /home/ansadmin/Devops_case_study/create-simple-docker-project.yml', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '//home//ansadmin//Devops_case_study', remoteDirectorySDF: false, removePrefix: 'target', sourceFiles: 'target/*.war')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
            
                slackSend channel: '#alerts', message: 'Test Image is  pushed to Dockerhub' 
            }
            
        }
    	
               
    }
 }
        
        stage('Deploying in Test from Dockerhub') {
            steps {
                sshPublisher(publishers: [sshPublisherDesc(configName: 'Test-env', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'ansible-playbook -i /etc/ansible/hosts /home/ansadmin/Devops_case_study/simple-docker-project.yml', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
            
                slackSend channel: '#alerts', message: 'Test deployment completed' 
            }
            
        }
stage ('Unit & Performance test') {
        parallel {
        stage("UI Test"){
    		steps{
    		   sh "mvn -B -f /var/lib/jenkins/workspace/Test-Project/functionaltest/pom.xml install"
    		}
            post {
                success {
                   publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '\\functionaltest\\target\\surefire-reports', reportFiles: 'index.html', reportName: 'UI Test', reportTitles: ''])
                }
            }
    	}
    	//stage('Performance test') {
               // steps {
                 // blazeMeterTest credentialsId: 'Blazemeter', testId: '9018223.taurus', workspaceId: '757349'
                //}
        //}
    }
}
       
    }
    
}
