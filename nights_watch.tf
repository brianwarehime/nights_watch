variable slack_webhook {}
variable event_threshold {
  default = "0"
}

provider "aws" {
  region = "us-east-1"
  alias = "us-east-1"
}

provider "aws" {
  region = "us-east-2"
  alias = "us-east-2"
}

provider "aws" {
  region = "us-west-1"
  alias = "us-west-1"
}

provider "aws" {
  region = "us-west-2"
  alias = "us-west-2"
}

provider "aws" {
  region = "ap-south-1"
  alias = "ap-south-1"
}

provider "aws" {
  region = "ap-northeast-1"
  alias = "ap-northeast-1"
}

provider "aws" {
  region = "ap-northeast-2"
  alias = "ap-northeast-2"
}

provider "aws" {
  region = "ap-southeast-1"
  alias = "ap-southeast-1"
}

provider "aws" {
  region = "ap-southeast-2"
  alias = "ap-southeast-2"
}

provider "aws" {
  region = "ca-central-1"
  alias = "ca-central-1"
}

provider "aws" {
  region = "eu-central-1"
  alias = "eu-central-1"
}

provider "aws" {
  region = "eu-west-1"
  alias = "eu-west-1"
}

provider "aws" {
  region = "eu-west-2"
  alias = "eu-west-2"
}

provider "aws" {
  region = "eu-west-3"
  alias = "eu-west-3"
}

provider "aws" {
  region = "eu-north-1"
  alias = "eu-north-1"
}

provider "aws" {
  region = "sa-east-1"
  alias = "sa-east-1"
}

module "set_permissions" {
  source = "./permissions"
  providers = {
    aws = "aws.us-east-1"
  }
}

module "launcher_us-east-1" {
  source = "./launcher"
  providers = {
    aws = "aws.us-east-1"
  }
  slack_webhook = "${var.slack_webhook}"
  iam_role = "${module.set_permissions.iam_role}"
}

module "launcher_us-east-2" {
  source = "./launcher"
  providers = {
    aws = "aws.us-east-2"
  }
  slack_webhook = "${var.slack_webhook}"
  iam_role = "${module.set_permissions.iam_role}"
}

module "launcher_us-west-1" {
  source = "./launcher"
  providers = {
    aws = "aws.us-west-1"
  }
  slack_webhook = "${var.slack_webhook}"
  iam_role = "${module.set_permissions.iam_role}"
}

module "launcher_us-west-2" {
  source = "./launcher"
  providers = {
    aws = "aws.us-west-2"
  }
  slack_webhook = "${var.slack_webhook}"
  iam_role = "${module.set_permissions.iam_role}"
}

module "launcher_ap-south-1" {
  source = "./launcher"
  providers = {
    aws = "aws.ap-south-1"
  }
  slack_webhook = "${var.slack_webhook}"
  iam_role = "${module.set_permissions.iam_role}"
}

module "launcher_ap-northeast-1" {
  source = "./launcher"
  providers = {
    aws = "aws.ap-northeast-1"
  }
  slack_webhook = "${var.slack_webhook}"
  iam_role = "${module.set_permissions.iam_role}"
}

module "launcher_ap-northeast-2" {
  source = "./launcher"
  providers = {
    aws = "aws.ap-northeast-2"
  }
  slack_webhook = "${var.slack_webhook}"
  iam_role = "${module.set_permissions.iam_role}"
}

module "launcher_ap-southeast-1" {
  source = "./launcher"
  providers = {
    aws = "aws.ap-southeast-1"
  }
  slack_webhook = "${var.slack_webhook}"
  iam_role = "${module.set_permissions.iam_role}"
}

module "launcher_ap-southeast-2" {
  source = "./launcher"
  providers = {
    aws = "aws.ap-southeast-2"
  }
  slack_webhook = "${var.slack_webhook}"
  iam_role = "${module.set_permissions.iam_role}"
}

module "launcher_ca-central-1" {
  source = "./launcher"
  providers = {
    aws = "aws.ca-central-1"
  }
  slack_webhook = "${var.slack_webhook}"
  iam_role = "${module.set_permissions.iam_role}"
}

module "launcher_eu-central-1" {
  source = "./launcher"
  providers = {
    aws = "aws.eu-central-1"
  }
  slack_webhook = "${var.slack_webhook}"
  iam_role = "${module.set_permissions.iam_role}"
}

module "launcher_eu-west-1" {
  source = "./launcher"
  providers = {
    aws = "aws.eu-west-1"
  }
  slack_webhook = "${var.slack_webhook}"
  iam_role = "${module.set_permissions.iam_role}"
}

module "launcher_eu-west-2" {
  source = "./launcher"
  providers = {
    aws = "aws.eu-west-2"
  }
  slack_webhook = "${var.slack_webhook}"
  iam_role = "${module.set_permissions.iam_role}"
}

module "launcher_eu-west-3" {
  source = "./launcher"
  providers = {
    aws = "aws.eu-west-3"
  }
  slack_webhook = "${var.slack_webhook}"
  iam_role = "${module.set_permissions.iam_role}"
}

module "launcher_eu-north-1" {
  source = "./launcher"
  providers = {
    aws = "aws.eu-north-1"
  }
  slack_webhook = "${var.slack_webhook}"
  iam_role = "${module.set_permissions.iam_role}"
}

module "launcher_sa-east-1" {
  source = "./launcher"
  providers = {
    aws = "aws.sa-east-1"
  }
  slack_webhook = "${var.slack_webhook}"
  iam_role = "${module.set_permissions.iam_role}"
}
