resource "aws_s3_bucket" "secure_storage" {
  bucket = "secure-file-storage-12345"
  acl    = "private"
}
