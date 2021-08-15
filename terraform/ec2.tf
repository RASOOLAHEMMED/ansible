resource "aws_instance" "app-sample" {
  count                       = length(var.APP_COMPONENTS)
  ami                         = "ami-074df373d6bafa625"
  instance_type               = "t3.micro"
  vpc_security_group_ids      = ["sg-0db10ae5ed60c9988"]
  tags                        = {
    Name                      = "${element(var.APP_COMPONENTS, count.index)}-${var.ENV}"
    Monitor                   = "yes"
  }
}

resource "aws_instance" "db-sample" {
  count                       = length(var.DB_COMPONENTS)
  ami                         = "ami-074df373d6bafa625"
  instance_type               = "t3.micro"
  vpc_security_group_ids      = ["sg-0db10ae5ed60c9988"]
  tags                        = {
    Name                      = "${element(var.DB_COMPONENTS, count.index)}-${var.ENV}"
  }
}

resource "aws_route53_record" "app-records" {
  count                         = length(var.APP_COMPONENTS)
  name                          = "${element(var.APP_COMPONENTS, count.index)}-${var.ENV}"
  type                          = "A"
  zone_id                       = "Z00947631JDBITKOLUVH1"
  ttl                           = 300
  records                       = [element(aws_instance.app-sample.*.private_ip, count.index )]
}

resource "aws_route53_record" "db-records" {
  count                         = length(var.DB_COMPONENTS)
  name                          = "${element(var.DB_COMPONENTS, count.index)}-${var.ENV}"
  type                          = "A"
  zone_id                       = "Z00947631JDBITKOLUVH1"
  ttl                           = 300
  records                       = [element(aws_instance.db-sample.*.private_ip, count.index )]
}


//locals {
//  LENGTH                        = length(var.COMPONENTS)
//}

//COMPONENTS = ["mysql", "mongodb", "rabbitmq", "redis", "cart", "catalogue", "user", "shipping", "payment", "frontend"]

//resource "local_file" "Inventory-file" {
//  content                       = "[FRONTEND]\n${aws_instance.sample.*.private_ip[9]}\n[PAYMENT]\n${aws_instance.sample.*.private_ip[8]}\n[SHIPPING]\n${aws_instance.sample.*.private_ip[7]}\n[USER]\n${aws_instance.sample.*.private_ip[6]}\n[CATALOGUE]\n${aws_instance.sample.*.private_ip[5]}\n[CART]\n${aws_instance.sample.*.private_ip[4]}\n[REDIS]\n${aws_instance.sample.*.private_ip[3]}\n[RABBITMQ]\n${aws_instance.sample.*.private_ip[2]}\n[MONGODB]\n${aws_instance.sample.*.private_ip[1]}\n[MYSQL]\n${aws_instance.sample.*.private_ip[0]}\n"
//  filename                      = "/tmp/inv-roboshop-${var.ENV}"
//}

locals {
  COMPONENTS = concat(element(aws_instance.db-sample.*.private_ip, aws_instance.app-sample.*.private_ip)
}

resource "local_file" "Inventory-file" {
  content                       = "[FRONTEND]\n${local.COMPONENTS[9]}\n[PAYMENT]\n${local.COMPONENTS[8]}\n[SHIPPING]\n${local.COMPONENTS[7]}\n[USER]\n${local.COMPONENTS[6]}\n[CATALOGUE]\n${local.COMPONENTS[5]}\n[CART]\n${local.COMPONENTS[4]}\n[REDIS]\n${local.COMPONENTS[3]}\n[RABBITMQ]\n${local.COMPONENTS[2]}\n[MONGODB]\n${local.COMPONENTS[1]}\n[MYSQL]\n${local.COMPONENTS[0]}\n"
  filename                      = "/tmp/inv-roboshop-${var.ENV}"
}