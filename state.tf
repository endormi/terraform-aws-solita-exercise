# Optional

/*
# If you already have a bucket, you can add it here
# without needing to create the bucket first
# In that case keep the code below commented out

terraform {
  backend "s3" {
    bucket     = "exercise-terraform-backend"
    key        = "terraform.tfstate"
    region     = "eu-north-1"
    encrypt    = true
    kms_key_id = "alias/bucket_key"
  }
}
*/

/*
# Run this code first with backend commented out
# then run both together

resource "aws_kms_key" "bucket_key" {
  description             = "Encrypts bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_kms_alias" "key_alias" {
  name          = "alias/bucket_key"
  target_key_id = aws_kms_key.bucket_key.key_id
}

resource "aws_s3_bucket" "tstate" {
  bucket = "exercise-terraform-backend"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bucket_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket                  = aws_s3_bucket.tstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
*/
