resource "aws_elasticache_subnet_group" "redisgroup" {
  name       = "redisgroup"
  subnet_ids = [aws_subnet.public_subnet_1a.id,aws_subnet.public_subnet_1b.id]
}

resource "aws_elasticache_cluster" "redisdb" {
  cluster_id           = "redisdb"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.x"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redisgroup.name
  security_group_ids = [aws_security_group.private_security.id]
}