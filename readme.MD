Local Development
1. git clone the repo
2. cd backend     
3. docker-compose up -d #it will spinup both front and backend livewire demo site
4. docker exec laravel_container php artisan migrate   # it will run the migration
5. docker exec laravel_container php artisan db:seed

CI/CD Deployments

Prerequisites
- Docker Desktop Latest Version 

1. A Terraform Cloud Account 
2. Create variables # variables can be found on variables.tf
3. A Github account
4. Create Environment Secrets

How the CI/CD Works is that 
there are 3 Environments Secrets in Github that holds 
the different Types of Environment.

Branch:
master=production
dev=development
uat=qa

Environment Secrets
DEV it will run on every commits
UAT it will run on every commits
PROD   # requires pipeline approval and MR request