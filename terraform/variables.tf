variable "private_key_path" {}
variable "aws_key_name" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "agent_nodes" {
    default = "2"
}
variable "cloud_provider" {
    default = "aws"
}
variable "aws_region" {
    default = "us-east-1"
}
variable "aws_availability_zone" {
    default = "us-east-1a"
}
variable "aws_ubuntu_amis" {
    # HVM EBS Ubuntu 14.04 AMIs from
    # http://cloud-images.ubuntu.com/locator/ec2/ as of 15th September 2015
    default = {
        ap-northeast-1 = "ami-0841ca08"
        ap-southeast-1 = "ami-96c2c8c4"
        eu-central-1 = "ami-6265657f"
        eu-west-1 = "ami-9d2f0fea"
        sa-east-1 = "ami-4ddb4e50"
        us-east-1 = "ami-21630d44"
        us-west-1 = "ami-c52dd781"
        cn-north-1 = "ami-18980421"
        us-gov-west-1 = "ami-b1d9ba92"
        ap-southeast-2 = "ami-f32b64c9"
        us-west-2 = "ami-cf3c21ff"
    }
}
variable "aws_instance_type" {
    default = "m3.medium"
}
