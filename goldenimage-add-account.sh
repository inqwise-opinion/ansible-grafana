#!/bin/bash

# Set the account ID that you want to share the AMIs with
ACCOUNT_ID=388616473956
AMI_ID=$(jq -r '.builds[-1].artifact_id' manifest.json | cut -d "," -f2 | cut -d ":" -f2)
AMI_ID_EU=$(jq -r '.builds[-1].artifact_id' manifest.json | cut -d "," -f1 | cut -d ":" -f2)

aws ec2 modify-image-attribute --region us-west-2 --image-id $AMI_ID --launch-permission "Add=[{UserId=$ACCOUNT_ID}]" --profile payroll-stg
aws ec2 create-launch-template-version --launch-template-id lt-0d446ae538ffdfa7f --version-description $tag --source-version '$Latest' --launch-template-data "ImageId=$AMI_ID_EU" --profile payroll-stg --region eu-west-1
aws ec2 create-launch-template-version --launch-template-id lt-0b99013d96ac9c8cd --version-description $tag --source-version '$Latest' --launch-template-data "ImageId=$AMI_ID" --profile payroll --region us-west-2

# manifest.json example
#
# {
#   "builds": [
#     {
#       "name": "amazon_linux2",
#       "builder_type": "amazon-ebs",
#       "build_time": 1680171040,
#       "files": null,
#       "artifact_id": "eu-west-1:ami-099a031e2e846b790,us-west-2:ami-07e6d7257b143501e",
#       "packer_run_uuid": "1ba74066-d691-e7d9-8be2-39baa2b4061d",
#       "custom_data": null
#     },
#     {
#       "name": "amazon_linux2",
#       "builder_type": "amazon-ebs",
#       "build_time": 1680177993,
#       "files": null,
#       "artifact_id": "eu-west-1:ami-07275aa28fde893c9,us-west-2:ami-03d73f407806e5491",
#       "packer_run_uuid": "52a1b797-70e9-ace2-5fdd-512612914285",
#       "custom_data": null
#     },
#     {
#       "name": "amazon_linux2",
#       "builder_type": "amazon-ebs",
#       "build_time": 1680179595,
#       "files": null,
#       "artifact_id": "eu-west-1:ami-0ed7f10a9e8a219bb,us-west-2:ami-0e2fca97bcf83b4af",
#       "packer_run_uuid": "aed718bc-ded5-b403-c243-9b835d52c16f",
#       "custom_data": null
#     },
#     {
#       "name": "amazon_linux2",
#       "builder_type": "amazon-ebs",
#       "build_time": 1680181815,
#       "files": null,
#       "artifact_id": "eu-west-1:ami-0c9b23070adc87aa3,us-west-2:ami-0d882076b105cfbf0",
#       "packer_run_uuid": "1ef267c7-2c69-d055-094b-8aa988338750",
#       "custom_data": null
#     },
#     {
#       "name": "amazon_linux2",
#       "builder_type": "amazon-ebs",
#       "build_time": 1680434926,
#       "files": null,
#       "artifact_id": "eu-west-1:ami-040f077385f3f2e47,us-west-2:ami-0b897636fa2327e3b",
#       "packer_run_uuid": "f3e2d592-9847-939f-6987-60676a954883",
#       "custom_data": null
#     },
#     {
#       "name": "amazon_linux2",
#       "builder_type": "amazon-ebs",
#       "build_time": 1680436955,
#       "files": null,
#       "artifact_id": "eu-west-1:ami-00171eb7066af1cbf,us-west-2:ami-0fe565038c53443ae",
#       "packer_run_uuid": "8fe4141b-738e-9cb4-c42f-b25bf15f9f2d",
#       "custom_data": null
#     },
#     {
#       "name": "amazon_linux2",
#       "builder_type": "amazon-ebs",
#       "build_time": 1680438637,
#       "files": null,
#       "artifact_id": "eu-west-1:ami-008f7cb9fb65f1581,us-west-2:ami-043f7417bb803f382",
#       "packer_run_uuid": "85ccfd40-5c85-914a-52e8-0992834988b7",
#       "custom_data": null
#     },
#     {
#       "name": "amazon_linux2",
#       "builder_type": "amazon-ebs",
#       "build_time": 1680527635,
#       "files": null,
#       "artifact_id": "eu-west-1:ami-03288d2b41179d3a5,us-west-2:ami-09ac1c9a8503e8815",
#       "packer_run_uuid": "14dadc0b-789d-f931-3940-6230e25f9d61",
#       "custom_data": null
#     },
#     {
#       "name": "amazon_linux2",
#       "builder_type": "amazon-ebs",
#       "build_time": 1681109371,
#       "files": null,
#       "artifact_id": "eu-west-1:ami-0d6c982c5950aedd3,us-west-2:ami-0521aafe1116be13e",
#       "packer_run_uuid": "630b749d-c1e8-e38c-8812-cf671358945d",
#       "custom_data": null
#     },
#     {
#       "name": "amazon_linux2",
#       "builder_type": "amazon-ebs",
#       "build_time": 1681382157,
#       "files": null,
#       "artifact_id": "eu-west-1:ami-0a236ee18d707db3d,us-west-2:ami-05afd0e1d4fa4d07d",
#       "packer_run_uuid": "3e142e4f-2add-f54e-83f6-ebbce4523106",
#       "custom_data": null
#     },
#     {
#       "name": "amazon_linux2",
#       "builder_type": "amazon-ebs",
#       "build_time": 1682343335,
#       "files": null,
#       "artifact_id": "eu-west-1:ami-09d4a0487a4da30dc,us-west-2:ami-0e7f55af5143cacca",
#       "packer_run_uuid": "4758be15-2ae7-80b0-6969-16ac83a5066e",
#       "custom_data": null
#     },
#     {
#       "name": "amazon_linux2",
#       "builder_type": "amazon-ebs",
#       "build_time": 1683446040,
#       "files": null,
#       "artifact_id": "eu-west-1:ami-0f92c1b0bd7d3b421,us-west-2:ami-0a4b7d722188bf9a0",
#       "packer_run_uuid": "bfc922fa-fef0-0680-2ee3-048317999153",
#       "custom_data": null
#     },
#     {
#       "name": "amazon_linux2",
#       "builder_type": "amazon-ebs",
#       "build_time": 1684844968,
#       "files": null,
#       "artifact_id": "eu-west-1:ami-021d203ca3652a782,us-west-2:ami-0bf56241a62265acf",
#       "packer_run_uuid": "d6091683-3222-6b2a-0e27-972b7d4f74e3",
#       "custom_data": null
#     },
#     {
#       "name": "amazon_linux2",
#       "builder_type": "amazon-ebs",
#       "build_time": 1684852376,
#       "files": null,
#       "artifact_id": "eu-west-1:ami-0c0fc9f1d7e36c74e,us-west-2:ami-0ef6536eb12a68630",
#       "packer_run_uuid": "54d0f5db-bc57-cd7c-3c96-9087f39a779f",
#       "custom_data": null
#     },
#     {
#       "name": "amazon_linux2",
#       "builder_type": "amazon-ebs",
#       "build_time": 1684854363,
#       "files": null,
#       "artifact_id": "eu-west-1:ami-0b2a8ef3f89e42bc8,us-west-2:ami-0f006cdd1aec4de1b",
#       "packer_run_uuid": "c377d9d5-e0d3-7df0-a165-a696226038d5",
#       "custom_data": null
#     },
#     {
#       "name": "amazon_linux2",
#       "builder_type": "amazon-ebs",
#       "build_time": 1684860620,
#       "files": null,
#       "artifact_id": "eu-west-1:ami-003e3d3b1a46c69d7,us-west-2:ami-087918b3a6a365da4",
#       "packer_run_uuid": "e48df5f6-e079-822f-2b9e-56aa1fee81bf",
#       "custom_data": null
#     },
#     {
#       "name": "amazon_linux2",
#       "builder_type": "amazon-ebs",
#       "build_time": 1684912473,
#       "files": null,
#       "artifact_id": "eu-west-1:ami-0a77af79ac3e7d09e,us-west-2:ami-074c951c3e630a6e3",
#       "packer_run_uuid": "9717529f-b346-ba1a-53b6-4ee2c13f26bd",
#       "custom_data": null
#     },
#     {
#       "name": "amazon_linux2",
#       "builder_type": "amazon-ebs",
#       "build_time": 1720696558,
#       "files": null,
#       "artifact_id": "eu-west-1:ami-0d704fa3764b75e56,us-west-2:ami-0e3b36ec56bc890b4",
#       "packer_run_uuid": "9d1e4ce7-4175-5ae6-08b1-71c1a941575b",
#       "custom_data": null
#     },
#     {
#       "name": "amazon_linux2",
#       "builder_type": "amazon-ebs",
#       "build_time": 1720697498,
#       "files": null,
#       "artifact_id": "eu-west-1:ami-0586cb5551c39377c,us-west-2:ami-0904df01501557714",
#       "packer_run_uuid": "3a1d4767-3dfe-7f25-3339-bdb18aa97251",
#       "custom_data": null
#     },
#     {
#       "name": "amazon_linux2",
#       "builder_type": "amazon-ebs",
#       "build_time": 1720942288,
#       "files": null,
#       "artifact_id": "eu-west-1:ami-068bc69143ee7331c,us-west-2:ami-0fa498cd0708e1614",
#       "packer_run_uuid": "8ae1f4d4-36e9-4b5c-8663-3e71c12452f4",
#       "custom_data": null
#     }
#   ],
#   "last_run_uuid": "8ae1f4d4-36e9-4b5c-8663-3e71c12452f4"
# }