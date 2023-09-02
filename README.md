# Using Jenkins as Continuous Integration Azure DevOps
Using Jenkins as continuous integration on Azure. Note that we will run the pipeline in Jenkins Master, this is not recommended and will be done just for demonstration.

## Introduction

Here, we will see how to integrate jenkins into Azure; We will use Jenkins to build the code, generate artifacts that will be downloaded into Azure Pipelines and deploy it to an Azure App Service.

![](https://github.com/nokorinotsubasa/CI-jenkins-azure/blob/638046f3a426f8f5afe57b4c9c9eec48bbf911cc/images/Architecture.png)

We will use Terraform to deploy all the required resources. The code will be a simple C# application that displays a "Welcome" web page with a version number.

### Steps

- Terraform deploys the resouces, the Vm will run Jenkins in a cutom Docker Container with all dependencies installed. The Vm is configured to use Custom Script Extension.

- You can get the Vm password on the `terraform.tfstate` file

- Procede with the Jenkins setup; Use `sudo docker logs jenkins` to get the initial password.

![](https://github.com/nokorinotsubasa/CI-jenkins-azure/blob/638046f3a426f8f5afe57b4c9c9eec48bbf911cc/images/JenkinsSetup.png)

- Generate an API token, you can do this by going to `Manage Jenkins > Users > Configure`.

![](https://github.com/nokorinotsubasa/CI-jenkins-azure/blob/638046f3a426f8f5afe57b4c9c9eec48bbf911cc/images/APIToken.png)

- Remember to install GitHub plugin to fetch the code. 

- Create a new job, name it, and select the Pipeline type job.

- Set Pipeline code from SCM, set the github repository, branch name, and pipeline file name (in our case: "Jenkinsfile")

- On AzureDevOps, create a new Project and Pipeline, remember to setup GitHub and Azure Rm service Connection.

- Add Jenkins service connection, providing Jenkins Ip address and API token (remember to give permission to the pipeline)

![](https://github.com/nokorinotsubasa/CI-jenkins-azure/blob/638046f3a426f8f5afe57b4c9c9eec48bbf911cc/images/JenkinsServiceConnection.png)

>`You need to use the API token instead of password, or else it won't work`

- Click on Verify and safe

- On the Pipeline configuration, choose the classic editor. Select the source (in our case, GitHub).

- On templates, select the Jenkins template, specify the agent, set the service connection and job name.

![](https://github.com/nokorinotsubasa/CI-jenkins-azure/blob/638046f3a426f8f5afe57b4c9c9eec48bbf911cc/images/PipelineSetup.png)

>`The job name is the specific job name on jenkins.`

- Now, when we run the Pipeline from Azure DevOps, it will queue the Jenkins job, building the app and generating artifacts, which will be downloaded on Azure DevOps;

![](https://github.com/nokorinotsubasa/CI-jenkins-azure/blob/638046f3a426f8f5afe57b4c9c9eec48bbf911cc/images/JobLogs.png)

- Create a Release Pipeline to deploy the Web App; on "Artifacts" select source as "Build" and define the Project, Source(build pipeline), and version.

![](https://github.com/nokorinotsubasa/CI-jenkins-azure/blob/638046f3a426f8f5afe57b4c9c9eec48bbf911cc/images/ArtifactSetup2.png)

- On "Azure Web App Deploy" Job, set Subscription, App type, App name, and the path on which the artifact was published.

![](https://github.com/nokorinotsubasa/CI-jenkins-azure/blob/638046f3a426f8f5afe57b4c9c9eec48bbf911cc/images/WebAppPipelineSetup.png)

- The release pipeline will take the artifact and deploy the app on an Azure App Service.

![](https://github.com/nokorinotsubasa/CI-jenkins-azure/blob/638046f3a426f8f5afe57b4c9c9eec48bbf911cc/images/DownloadArtifactsJob.png)

- You can access the Web App link and check the app's web page:

![](https://github.com/nokorinotsubasa/CI-jenkins-azure/blob/638046f3a426f8f5afe57b4c9c9eec48bbf911cc/images/webpage.png)

This is how you integrate Jenkins into Azure DevOps to use it as Continuous Integration, queueing jobs and generating artifacts.