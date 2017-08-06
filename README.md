-------
Terraform Script which creates Infra in one go On Azure
=====================================

Steps to run this script
---------------------------------------
- Provide values in nbtest.tf file or set environment variables like ARM_CLIENT_ID , ARM_CLIENT_SECRET , ARM_SUBSCRIPTION_ID , ARM_TENANT_ID and removed provider block from nbtest.tf file.

- Run "terraform apply -var 'username=user' -var 'pass=pass' " . This comand will create spawn a instance on azure with pased username and password.

- Run "terraform refresh -var 'username=user' -var 'pass=pass' " . This will return new instance's IP Address as its a defect in terraform we need to run terraform refresh to see output variables.
