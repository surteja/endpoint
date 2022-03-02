resource "aws_iam_role" "beanstalk_service" {
  name = "beanstalk_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_s3_bucket" "my_app_ebs" {
  bucket = "my-app-ebs"
  acl    = "private"

  tags = {
    Name = "My APP EBS"
  }
}

resource "aws_s3_bucket_object" "my_app_deployment" {
  bucket = aws_s3_bucket.my_app_ebs.id
  key    = "jenkins.aws.json"
  source = "jenkins.aws.json"
}

resource "aws_iam_role_policy_attachment" "beanstalk_log_attach" {
  role       = aws_iam_role.beanstalk_service.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_instance_profile" "beanstalk_iam_instance_profile" {
  name = "beanstalk_iam_instance_profile"
  role = aws_iam_role.beanstalk_service.name
}

resource "aws_elastic_beanstalk_application" "endpoint" {
  name        = "EndpointClosing"
  description = "This is used to deploy elastic-beanstalk application"
}

resource "aws_elastic_beanstalk_environment" "endpoint" {
  name                = "EndpointClosing"
  application         = aws_elastic_beanstalk_application.endpoint.name
  solution_stack_name = "64bit Amazon Linux 2015.03 v2.0.3 running Docker 1.12.6"


setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.main.id
  }
  setting {
    namespace = "aws:ec2:subnet"
    name      = "Subnets"
    value     = [aws_subnet.public.id]
  }
}

resource "aws_elastic_beanstalk_application_version" "my_app_ebs_version" {
  name        = "my-app-ebs-version"
  application = aws_elastic_beanstalk_application.endpoint.name
  description = "application version created by terraform"
  bucket      = aws_s3_bucket.my_app_ebs.id
  key         = aws_s3_bucket_object.my_app_deployment.id
}