resource "aws_db_subnet_group" "mountains" {
  name       = local.name
  subnet_ids = module.vpc.private_subnets
  tags       = local.tags
}

resource "aws_db_parameter_group" "mountains" {
  name   = local.name
  family = "mysql8.0"
}

resource "aws_db_instance" "mountains" {
  identifier             = local.name
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "8.0"
  username               = module.multiple.db_username.secure_value
  password               = module.multiple.db_password.secure_value
  db_name                = module.multiple.db_database.secure_value
  db_subnet_group_name   = aws_db_subnet_group.mountains.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.mountains.name
  publicly_accessible    = false
  skip_final_snapshot    = true
  tags                   = local.tags
}
