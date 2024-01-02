resource "aws_db_subnet_group" "rds_db_subnet" {
  name       = "mydb-subnet-group"
  subnet_ids = [aws_subnet.private-subnet-1.id,aws_subnet.private-subnet-2.id]
}

resource "aws_db_parameter_group" "paragroup" {
  name   = "paragroup"
  family = "mysql8.0"

 parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}


resource "aws_db_instance" "hadiya" {
   allocated_storage   = 20
   storage_type        = "gp2"
   identifier          = "rdstf"
   engine              = "mysql"
   engine_version      = "8.0.33"
   instance_class      = "db.t2.micro"
   username            = "admin"
   password            = "Passw0rd!123"
   parameter_group_name = aws_db_parameter_group.paragroup.name
   vpc_security_group_ids = [aws_security_group.private-sg.id]
   db_subnet_group_name = aws_db_subnet_group.rds_db_subnet.name
   skip_final_snapshot = true

   tags = {
     Name = "MyRDS"
   }
 }
