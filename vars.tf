variable "regionDefault" {
  default = "us-east-1"
}

variable "accountId" {
  default = "431657365754"
}

variable "labRole" {
  default = "arn:aws:iam::431657365754:role/LabRole"
}

variable "projectName" {
  default = "nginx"
}

variable "subnetA" {
  default = "subnet-0522aebc6c9270936"
}

variable "subnetB" {
  default = "subnet-0638f66ef02622815"
}

variable "subnetC" {
  default = "subnet-050e35959c1e1661a"
}

variable "vpcId" {
  default = "vpc-02f59273b75e682a9"
}

variable "instanceType" {
  default = "t3a.medium"
}

variable "principalArn" {
  default = "arn:aws:iam::431657365754:role/voclabs"
}

variable "policyArn" {
  default = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
}

variable "accessConfig" {
  default = "API_AND_CONFIG_MAP"
}
