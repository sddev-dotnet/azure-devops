# Overview
This is an azure devops agent built off `ubuntu:20.04` base image. It is designed to be run in a K8 cluster (or any other container orchestrator) and autoscale up and down. On startup, the container downloads the lastest devop agent and then configures it to run in a particular agent pool. This means, you can update to the latest agent version by simply starting up a new container instance. 

I will be publishing a helm chart as well that uses this image and makes it very easy to configure and deploy the agent in Kubernetes. 

# Starting up the container
## Prequisites
You will need to retrieve a PAT from Azure Devops service before you run this template. To run the build agent, simply execute `docker run --rm -it -e AZP_Token={your PAT} sddevnet/azure-devops-agent:latest `

## Environment Variables
Below are the environment variables that you can set:
- AZP_TOKEN - your Personal Access Token from Azure Devops  **required*
- AZP_URL - the url to your azure devops instance. i.e. "https://dev.azure.com/foo" **required*
- AZP_AGENT_NAME - the name of the agent you are running. Highly recommend you leave this empty and autoset the name or you can easily run into collisions
- AZP_POOL - the pool you want to deploy the agent to. Defaults to *Default*
- AZP_WORK - the working directory for the agent to use. You may not want to mess with this either because, if you host multiple instances on the same server, you could end up sharing a working directory and causing problems. Defaults to *_work/{A random string}*