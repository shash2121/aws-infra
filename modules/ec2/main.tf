resource "aws_instance" "bastion" {
  instance_type = var.ec2.inst_type
  ami = var.ec2.ami_id
  vpc_security_group_ids = [var.ec2.sg_pub_id]
  key_name = "${terraform.workspace}-key"
  associate_public_ip_address = true
  user_data = "${data.template_file.jump-server.rendered}" 
  iam_instance_profile = var.ec2.iam_instance_profile
  subnet_id = "${element(var.ec2.pub_subnet_id,0)}"
    tags = {
    Name = "${terraform.workspace}-jump-server"
  }
}

resource "aws_instance" "app" {
  instance_type = var.app.inst_type
  ami           = var.app.ami_id
  vpc_security_group_ids = [var.app.sg_pub_id]
  key_name = "${terraform.workspace}-key"
  associate_public_ip_address = false
  iam_instance_profile = var.app.iam_instance_profile
  user_data = "${data.template_file.jenkins.rendered}" 
  subnet_id = "${element(var.app.priv_subnet_ids,0)}"
  tags = {
      Name = "${terraform.workspace}-jenkins"
  }
}