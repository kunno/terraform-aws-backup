terraform {
  required_version = ">= 1.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.62.0"
      #    configuration_aliases = [aws.pre_stage]
    }
  }
}
