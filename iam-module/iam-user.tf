   {
      "Version": "2012-10-17",
      "Statement": [
         {
         "Sid": "AllowS3StateBucket",
            "Effect": "Allow",
            "Action": [
               "s3:GetObject",
               "s3:PutObject",
               "s3:ListBucket"
            ],
            "Resource": [
               "arn:aws:s3:::your-unique-tf-state-bucket",
               "arn:aws:s3:::your-unique-tf-state-bucket/*"
            ]
         },
         {
            "Sid": "AllowDynamoDBLockTable",
            "Effect": "Allow",
            "Action": [
               "dynamodb:GetItem",
               "dynamodb:PutItem",
               "dynamodb:DeleteItem"
            ],
            "Resource": "arn:aws:dynamodb:us-east-1:123456789012:table/terraform-locks"
         }
      ]
   }
