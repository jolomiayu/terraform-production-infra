resource "aws_security_group" "db_sg" {
  name        = "terraform-db-sg"
  description = "Allow PostgreSQL traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "PostgreSQL"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"

    cidr_blocks = ["10.0.0.0/16"]

    security_groups = [var.web_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-db-sg"
  }
}

resource "aws_db_subnet_group" "db_subnets" {
  name = "terraform-db-subnet-group"

  subnet_ids = [
    var.private_subnet_id,
    var.private_subnet_2_id
  ]

  tags = {
    Name = "terraform-db-subnet-group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier = "salonhub-postgres"

  engine         = "postgres"
  engine_version = "17.4"

  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type       = "gp3"

  db_name  = "salonhub"
  username = "postgres"
  password = "SalonHubPassword123!"

  publicly_accessible = false

  vpc_security_group_ids = [
    aws_security_group.db_sg.id
  ]

  db_subnet_group_name = aws_db_subnet_group.db_subnets.name

  skip_final_snapshot = true

  tags = {
    Name = "salonhub-postgres"
  }
}
