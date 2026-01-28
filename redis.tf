# ElastiCache Subnet Group
resource "aws_elasticache_subnet_group" "redisgroup" {
  name       = "redisgroup"
  subnet_ids = [aws_subnet.public_subnet_1a.id, aws_subnet.public_subnet_1b.id]

  tags = {
    Name = "redis-subnet-group"
  }
}

# ElastiCache Redis Cluster
resource "aws_elasticache_cluster" "redisdb" {
  cluster_id           = "redisdb"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  engine_version       = "7.1"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redisgroup.name
  security_group_ids   = [aws_security_group.private_security.id]

  tags = {
    Name = "redis-cluster"
  }
}