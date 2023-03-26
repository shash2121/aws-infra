resource "aws_iam_role" "eks-iam-role" {
  name = "${terraform.workspace}-Cluster-Role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}



resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
 role    = aws_iam_role.eks-iam-role.name
}
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly-EKS" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
 role    = aws_iam_role.eks-iam-role.name
}

resource "aws_eks_cluster" "eks" {
 name = "${terraform.workspace}-eks-cluster"
 role_arn = aws_iam_role.eks-iam-role.arn

 vpc_config {
  #subnet_ids = [var.subnet_id_1, var.subnet_id_2]
  subnet_ids = var.subnet_ids
 }

 depends_on = [
  aws_iam_role.eks-iam-role,
 ]
}

resource "aws_iam_role" "workernodes" {
  name = "${terraform.workspace}-workernode-role"
 
  assume_role_policy = jsonencode({
   Statement = [{
    Action = "sts:AssumeRole"
    Effect = "Allow"
    Principal = {
     Service = "ec2.amazonaws.com"
    }
   }]
   Version = "2012-10-17"
  })
 }
 
 resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role    = aws_iam_role.workernodes.name
 }
 
 resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role    = aws_iam_role.workernodes.name
 }
 
 resource "aws_iam_role_policy_attachment" "EC2InstanceProfileForImageBuilderECRContainerBuilds" {
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
  role    = aws_iam_role.workernodes.name
 }
 
 resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role    = aws_iam_role.workernodes.name
 }

 resource "aws_eks_node_group" "worker-node-group" {
  cluster_name  = aws_eks_cluster.eks.name
  node_group_name = "${terraform.workspace}-workernodes"
  node_role_arn  = aws_iam_role.workernodes.arn
  subnet_ids = var.subnet_ids
  #instance_types = ["t3.xlarge"]
  launch_template {
   name = aws_launch_template.your_eks_launch_template.name
   version = aws_launch_template.your_eks_launch_template.latest_version
  }
  scaling_config {
   desired_size = 1
   max_size   = 2
   min_size   = 1
  }
#  remote_access {
#    ec2_ssh_key = "${terraform.workspace}"
#    source_security_group_ids = [var.secgrp]
#  }


  depends_on = [
   aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
   aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
   #aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
 }


################################# Launch Template for worker node group##################################
resource "aws_launch_template" "your_eks_launch_template" {
  name = "${terraform.workspace}-launch-template"

  #vpc_security_group_ids = [var.your_security_group.id, aws_eks_cluster.your-eks-cluster.vpc_config[0].cluster_security_group_id]
  #vpc_security_group_ids = [var.secgrp]
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 10
      volume_type = "gp2"
    }
  }
  network_interfaces {
    associate_public_ip_address = false
  }
  instance_type = "t3a.small"
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${terraform.workspace}-EKS-MANAGED-NODE"
    }
  }
}