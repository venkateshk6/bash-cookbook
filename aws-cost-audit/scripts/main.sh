########################################################################
#    /_\\ \    / // __|   /_\  _  _  __| |(_)| |_ 
#   / _ \\ \/\/ / \__ \  / _ \| || |/ _` || ||  _|
#  /_/ \_\\_/\_/  |___/ /_/ \_\\_,_|\__,_||_| \__|
# 
# To learn more, see https://maxat-akbanov.com/
########################################################################

#!/bin/bash

# Optional: log to file
exec > >(tee "audit_aws_$(date +%Y%m%d_%H%M%S).log") 2>&1

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION=$(aws configure get region)

echo "🧾 AWS Cost Audit Started on $(date +'%d-%b-%Y %H:%M:%S')"
echo "📛 Account: $ACCOUNT_ID | 📍 Region: $REGION"
echo "=============================="

# Run individual checks
echo -e "\n--- 📊 Budget Alerts Check ---"
./check_budgets.sh

echo -e "\n--- 🏷️  Untagged Resources Check ---"
./check_untagged_resources.sh

echo -e "\n--- 💤  Idle EC2 Resources Check ---"
./check_idle_ec2.sh

echo -e "\n--- ♻️  S3 Lifecycle Policies Check ---"
./check_s3_lifecycle.sh

echo -e "\n--- 🗓️ Old RDS Snapshots Check ---"
./check_old_rds_snapshots.sh

echo -e "\n--- 🧹 Forgotten EBS Volumes Check ---"
./check_forgotten_ebs.sh

echo -e "\n--- 🌐 Data Transfer Risks Check ---"
./check_data_transfer_risks.sh

echo -e "\n--- 💸 On-Demand EC2 Instances Check ---"
./check_on_demand_instances.sh

echo -e "\n--- 🛑 Idle Load Balancers Check ---"
./check_idle_load_balancers.sh

echo -e "\n✅ AWS Audit Completed"
