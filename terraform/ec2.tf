resource "aws_instance" "sample" {
  count                       = local.LENGTH
  ami                         = "ami-074df373d6bafa625"
  instance_type               = "t3.micro"
  vpc_security_group_ids      = ["sg-0db10ae5ed60c9988"]
  tags                        = {
    Name                      = "${element(var.COMPONENTS, count.index)}-${var.ENV}"
  }
}

resource "aws_route53_record" "records" {
  count                         = local.LENGTH
  name                          = "${element(var.COMPONENTS, count.index)}-${var.ENV}"
  type                          = "A"
  zone_id                       = "Z00947631JDBITKOLUVH1"
  ttl                           = 300
  records                       = [element(aws_instance.sample.*.private_ip, count.index )]
}


locals {
  LENGTH                        = length(var.COMPONENTS)
}

//COMPONENTS = ["mysql", "mongodb", "rabbitmq", "redis", "cart", "catalogue", "user", "shipping", "payment", "frontend"]

resource "local_file" "Inventory-file" {
  content                       = "[FRONTEND]\n${aws_instance.sample.*.private_ip[9]}\n[PAYMENT]\n${aws_instance.sample.*.private_ip[8]}\n[SHIPPING]\n${aws_instance.sample.*.private_ip[7]}\n[USER]\n${aws_instance.sample.*.private_ip[6]}\n[CATALOGUE]\n${aws_instance.sample.*.private_ip[5]}\n[CART]\n${aws_instance.sample.*.private_ip[4]}\n[REDIS]\n${aws_instance.sample.*.private_ip[3]}\n[RABBITMQ]\n${aws_instance.sample.*.private_ip[2]}\n[MONGODB]\n${aws_instance.sample.*.private_ip[1]}\n[MYSQL]\n${aws_instance.sample.*.private_ip[0]}\n"
  filename                      = "/tmp/inv-roboshop-${var.ENV}"
}