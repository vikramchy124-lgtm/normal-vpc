resource "aws_s3_bucket" "terra_project_bucket" {
  bucket = "terra-project-unique-bucket-20260901-us-east-1"

  tags = {
    Name        = "terra-project-bucket"
    Environment = "Dev"
  }
}