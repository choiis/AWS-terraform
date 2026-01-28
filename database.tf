resource "aws_db_subnet_group" "db_subnet" {
  name       = "db_subnet_group"
  subnet_ids = [aws_subnet.public_subnet_1a.id,aws_subnet.public_subnet_1b.id]
}

resource "aws_db_instance" "mysql_rds" {
  allocated_storage = 8
  engine = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name = "mysql_rds"
  username = "users"
  password = "12345678"
  db_subnet_group_name = "db_subnet_group"
  vpc_security_group_ids = [aws_security_group.db_security.id]
  publicly_accessible    = true
  skip_final_snapshot    = true

  # 자동 백업 설정
  backup_retention_period  = 7              # 7일간 백업 보관
  backup_window            = "03:00-04:00"  # UTC 03:00-04:00 (한국시간 12:00-13:00)
  delete_automated_backups = false          # 인스턴스 삭제 시 백업 유지
}