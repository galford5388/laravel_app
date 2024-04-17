Prerequisites
- Docker Desktop Latest Version # it will work on any platform
- Git
- Your favorite IDE

Local Development using docker compose # this will spin up a development webserver and mysql
#note: you can modify this on docker-compose.yml the location of the app can be found on the Dockerfile
       within this directory the mysql container only mounts the volume but the app itself is not as the
       Dockerfile holds the volume and builds.

1. git clone the repo
2. cd laravel_app and add your .env  
3. docker build -t ryanc-laravel . # this will build the image came from Dockerfile
4. docker-compose up -d #it will spinup both front and backend livewire demo site
5. docker exec laravel_container php artisan migrate   # it will run the migration
6. docker exec laravel_container php artisan db:seed   # it will run the seeding
7. Access your app to http://localhost
8. docker ps # this will check if the app is running it must be a 2 container running locally
9. docker compose down  # to stop the app
10. docker logs -f (container_id) to check the container logs
11. docker exec -ti (container_id) bash    # this is where you can find the location of the app and navigate within the container 

CI/CD Deployments   #see attached pdf

1. Create Terraform Cloud Account and Create API Token
2. In your AWS account create secret key and access key and paste it in your Terraform Cloud variables as hidden secrets.
3. Create variables in Terraform Cloud # variables can be found on variables.tf
4. Create a Github account
5. Create Environment Secrets according to your specific Terraform cloud environment workspace.

How the CI/CD Works is that 
there are 3 Environments Secrets in Github that holds 
the different Types of Environment.

Branch:
master=production
dev=development
uat=qa

Environment Secrets  #testing is on the last part of pipeline to check the status code
DEV it will run on every commits
UAT it will run on every commits
PROD   # requires pipeline approval and MR request