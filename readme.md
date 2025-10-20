## How to Run this

git clone https://github.com/<your-org>/azure-two-tier-iac.git
cd azure-two-tier-iac


## Connect to Azure Cli 

az login --tenant <your tenant id>
az account show --query id -o tsv # get your subcription id
az account set --subscription "subid"
cp terraform.tfvars.example terraform.tfvars

### edit terraform.tfvars: set location, your public IP/CIDR for prod scenerion

- terraform init
- terraform validate
- terraform plan
- terraform apply

![alt text](image-1.png)

![alt text](image.png)