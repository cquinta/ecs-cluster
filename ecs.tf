resource "aws_ecs_cluster" "main" {
  name = var.project_name
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = [
    aws_ecs_capacity_provider.on_demand.name,
    aws_ecs_capacity_provider.spots.name,
    "FARGATE",
    "FARGATE_SPOT"
  ]
  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}