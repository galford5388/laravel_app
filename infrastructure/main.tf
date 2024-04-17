# Define resources

resource "aws_ecr_repository" "my_repository" {
  name = "my-laravel-app" # Change to your desired repository name
}

resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_lb" "my_alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_ids
}

resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}

resource "aws_lb_target_group" "my_target_group" {
  name        = "my-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_ecs_task_definition" "my_task_definition" {
  family                = "my-task"
  container_definitions = <<DEFINITION
[
  {
    "name": "my-app",
    "image": "${aws_ecr_repository.my_repository.repository_url}:latest",  # Use the ECR repository URL
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80,
        "protocol": "tcp"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.ecs_logs.name}",
        "awslogs-region": "${var.aws_region}",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
DEFINITION
}

resource "aws_ecs_service" "my_service" {
  name            = "my-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task_definition.arn
  desired_count   = 2

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.my_target_group.arn
    container_name   = "my-app"
    container_port   = 80
  }
}

resource "aws_db_instance" "my_rds_instance" {
  identifier          = "my-rds-instance"
  allocated_storage   = 20
  storage_type        = "gp2"
  engine              = "mysql"
  engine_version      = var.db_engine_version
  instance_class      = var.db_instance_class
  username            = var.db_username
  password            = var.db_password
  publicly_accessible = false
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/aws/ecs/${aws_ecs_cluster.my_cluster.name}"
  retention_in_days = 7 # Adjust retention as needed
}

resource "aws_cloudwatch_log_stream" "ecs_stream" {
  name           = "ecs"
  log_group_name = aws_cloudwatch_log_group.ecs_logs.name
}

resource "aws_cloudwatch_log_group" "rds_logs" {
  name              = "/aws/rds/${aws_db_instance.my_rds_instance.identifier}/audit"
  retention_in_days = 7 # Adjust retention as needed
}

resource "aws_cloudwatch_log_stream" "rds_stream" {
  name           = "rds"
  log_group_name = aws_cloudwatch_log_group.rds_logs.name
}

# Add AWS VPN Client
resource "aws_ec2_client_vpn_endpoint" "my_vpn_endpoint" {
  client_cidr_block      = "10.50.0.0/16"                                          # Specify your client CIDR block
  server_certificate_arn = "arn:aws:acm:us-west-2:123456789012:certificate/abc123" # Replace with your ACM certificate ARN
  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = "arn:aws:acm:us-west-2:123456789012:certificate/def456" # Replace with your root certificate ARN
  }
  connection_log_options {
    enabled                    = true
    cloudwatch_log_group_name  = "my_vpn_logs" # Specify your CloudWatch log group name
    cloudwatch_log_stream_name = "vpn_stream"  # Specify your CloudWatch log stream name
  }
  client_connection_logging = "enabled"
}


