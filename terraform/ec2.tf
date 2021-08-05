resource "aws_instance" "sample" {
  count                       = local.LENGTH
  ami                         = "ami-074df373d6bafa625"
  instance_type               = "t3.micro"
  vpc_security_group_ids      = ["sg-0db10ae5ed60c9988"]
  tags                        = {
    Name                      = element(var.COMPONENTS, count.index )
  }
}

resource "aws_route53_record" "records" {
  count                         = local.LENGTH
  name                          = element(var.COMPONENTS, count.index )
  type                          = "A"
  zone_id                       = "Z00947631JDBITKOLUVH1"
  ttl                           = 300
  records                       = [element(aws_instance.sample.*.private_ip, count.index )]
}


locals {
  LENGTH                        = length(var.COMPONENTS)
}

resource "local_file" "foo" {
  content                       = "[FRONTEND]\n${aws_instance.sample.*.private_ip[9]}"
  filename                      = "/tmp/inv-roboshop"
}