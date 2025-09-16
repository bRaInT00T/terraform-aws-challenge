module "s3_logs" {
  source = "git::https://github.com/Coalfire-CF/terraform-aws-s3.git?ref=main"

  name = "logs-${var.resource_prefix}"

  lifecycle_configuration_rules = [
    {
      id      = "expire-inactive"
      enabled = true
      prefix  = "inactive/"
      expiration = {
        days = 90
      }
    },
    {
      id      = "active-to-glacier"
      enabled = true
      prefix  = "active/"
      transitions = [
        {
          days          = 90
          storage_class = "GLACIER"
        }
      ]
    }
  ]
}

module "s3_images" {
  source = "git::https://github.com/Coalfire-CF/terraform-aws-s3.git?ref=main"
  name   = "images-${var.resource_prefix}"

  lifecycle_configuration_rules = [
    {
      id      = "memes-glacier"
      enabled = true
      prefix  = "memes/"
      transitions = [
        {
          days          = 90
          storage_class = "GLACIER"
        }
      ]
    }
  ]

  tags = {
    Project = var.resource_prefix
    Owner   = "NickWolk"
  }
}

resource "aws_s3_object" "images_folders" {
  for_each = toset(["archive/", "memes/"])
  bucket   = module.s3_images.id
  key      = each.value
}

