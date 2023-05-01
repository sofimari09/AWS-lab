module "label" {
  source   = "cloudposse/label/null"
  version = "0.25.0"

  environment  = var.environment
  label_order = var.label_order
}

module "course" {
  source = "./modules/dynamo_db/eu-central-1"
  context = module.label.context
  name = "course"
}

module "author" {
  source = "./modules/dynamo_db/eu-central-1"
  context = module.label.context
  name = "author"
}

module "delete-course" {
  source = "./lambda/delete-course"
  name="delete-course"
}

module "get-all-authors" {
  source = "./lambda/get-all-authors"
  name="get-all-authors"
}

module "get-all-courses" {
  source = "./lambda/get-all-courses"
  name="get-all-courses"
}

module "get-course" {
  source = "./lambda/get-course"
  name="get-course"
}

module "save-course" {
  source = "./lambda/save-course"
  name="save-course"
}

module "update-course" {
  source = "./lambda/update-course"
  name="update-course"
}
