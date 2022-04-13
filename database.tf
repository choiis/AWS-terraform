resource "aws_db_subnet_group" "db_subnet" {
  name       = "db_subnet_group"
  subnet_ids = [aws_subnet.public_subnet_1a.id,aws_subnet.public_subnet_1b.id]
}

resource "aws_db_instance" "mysql_rds" {
  allocated_storage = 8
  engine = "mysql"
  engine_version = "5.7.37"
  instance_class = "db.t2.micro"
  name = "mysql_rds"
  username = "users"
  password = "12345678"
  db_subnet_group_name = "db_subnet_group"
  vpc_security_group_ids = [aws_security_group.terra_security.id]
  publicly_accessible    = true
  skip_final_snapshot    = true
}