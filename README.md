# Tallercicd



### Terraform configs

Then, you must delete `.terraform` folder.

The next step, download the providers plugins and configure the s3 backend for the tfstate.

> Replace < deploy_id > with your deploy_id
> deploy_id = tallerfp-< environment >

```bash
terraform init --reconfigure --backend-config="bucket=tallerfp-tfstate" --backend-config="region=eu-west-1" --backend-config="key=dev.tfstate"
```

For calculating the diff between code and current infrastructure, you must run:

```bash
terraform plan # Add --destroy to calculate the resources to be destroyed
```

If the output is correct, you can create the infrastructure with:

```bash
terraform apply --auto-approve
```

In case you want to destroy the created resources:

```bash
terraform destroy --auto-approve
```