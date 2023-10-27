resource "aws_ecr_repository" "hostspaceUi" {
  name                 = "ui"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "hostspaceBackend" {
  name                 = "backend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecs_cluster" "hostspaceCluster" {
  name = "theyemihostspacecluster"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}



resource "aws_ecs_task_definition" "theyemihostspaceTaskDefinition" {
  family= "theyemihostspaceTaskDefinition"
  requires_compatibilities= ["FARGATE"]
      cpu= "1024"
    memory= "3072"
    runtime_platform {
        cpu_architecture = "X86_64"
        operating_system_family = "LINUX"    
    }
    # task_role_arn =   "arn:aws:iam::568305562431:role/ecsTaskExecutionRole"
    # "executionRoleArn": "arn:aws:iam::568305562431:role/ecsTaskExecutionRole",
  container_definitions = jsonencode([
           {
            "name": "ui",
            "image": "568305562431.dkr.ecr.ca-central-1.amazonaws.com/ui",
            "cpu": 512,
            "memory": 1024,
            "portMappings": [
                {
                    "name": "ui-80-tcp",
                    "containerPort": 80,
                    "hostPort": 80,
                    "protocol": "tcp",
                    "appProtocol": "http"
                }
            ],
            "essential": true,
            "environment": [],
            "environmentFiles": [],
            "mountPoints": [],
            "volumesFrom": [],
            "ulimits": [],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-create-group": "true",
                    "awslogs-group": "/ecs/theyemihostspaceTaskDefinition",
                    "awslogs-region": "ca-central-1",
                    "awslogs-stream-prefix": "ecs"
                },
                "secretOptions": []
            }
        },
        {
            "name": "backend",
            "image": "568305562431.dkr.ecr.ca-central-1.amazonaws.com/backend",
            "cpu": 512,
            "memory": 1024,
            "portMappings": [],
            "essential": false,
            "environment": [],
            "environmentFiles": [],
            "mountPoints": [],
            "volumesFrom": []
        }
  ])
  task_role_arn = "arn:aws:iam::568305562431:role/ecsTaskExecutionRole"
execution_role_arn = "arn:aws:iam::568305562431:role/ecsTaskExecutionRole"
network_mode =  "awsvpc"

}



resource "aws_ecs_service" "theyemihostspaceService" {
  name            = "theyemihostspaceservice"
  cluster         = aws_ecs_cluster.hostspaceCluster.id
  task_definition = aws_ecs_task_definition.theyemihostspaceTaskDefinition.arn
  desired_count   = 1

  network_configuration {
    subnets = [ "subnet-02cb571218d81d7ee", "subnet-0049ab68963350a8c", "subnet-07f653468f06b14ff" ]
    security_groups = ["sg-0596a34e33519c972"]
  }

}