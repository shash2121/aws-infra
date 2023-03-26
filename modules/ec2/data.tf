data "template_file" "jump-server" {
  template = "${file("./user-data/jump-server.tpl")}"
  vars = {
    ENV     = "${terraform.workspace}"
    REGION  = "ap-south-1"
  }
}

data "template_file" "jenkins" {
  template = "${file("./user-data/jenkins.tpl")}"
}