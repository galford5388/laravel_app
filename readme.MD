Prerequisites
- Docker Desktop Latest Version # it will work on any platform
- Git
- Your favorite IDE

Local Development using docker compose # this will spin up a development webserver and mysql
#note: you can modify this on docker-compose.yml

1. git clone the repo
2. cd laravel_app and add your .env  
3. docker build -t ryanc-laravel . # this will build the image  
4. docker-compose up -d #it will spinup both front and backend livewire demo site
5. docker exec laravel_container php artisan migrate   # it will run the migration
6. docker exec laravel_container php artisan db:seed   # it will run the seeding

CI/CD Deployments

1. A Terraform Cloud Account and Create API Token
2. Create variables in Terraform Cloud # variables can be found on variables.tf
3. A Github account
4. Create Environment Secrets

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