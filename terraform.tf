terraform {
    backend "s3" {
        bucket = "terraform-sock-shop"
        key = "sock-shop"
        region = "us-east-1"
        profile = "terraform"
    }
}