# Terraform Module for Azure Defender

## This module creates following resources :
1) Multiple Azure defender in one module call 


## Module Usage

### Description

This Terraform module provisions and manages Azure Defender module. This allows for consistent, reusable modules to configure and deploy advanced threat protection. Once applied, it ensures continuous security monitoring and alerts for vulnerabilities, enhancing the protection of your Azure environment.

**Please refer to "sample" folder for complete and  minimalistic example.**

1. complete_main.tf
2. minimalistic_main.tf

## Requirements


## Providers
| Name   | Version   |
|--------|-----------|
| azure  | "~>4.0"   |


# Inputs

 Variable Name                        | Type         | Description                                                                | Default  | Required | Accepted Values                     | modification forces recreation 
--------------------------------------|--------------|----------------------------------------------------------------------------|----------|----------|-------------------------------------|--------------------------------
| create Azure defender  | map(object) | Create map of Defender (attributes of the map of object defined below) | {}      | yes      |  {}    | NA
storage_account_id | string | Storage sccount ID(map of object part) | {} | yes  | Storage ID for Azure | NA
override_subscription_settings_enabled | bool | Subscription setting (part of map of object) | false | No | "true" or "false" | NA
malware_scanning_on_upload_enabled | bool | Malware Scanning (part of map of object) | false | No | "true" or "false"  | NA
malware_scanning_on_upload_cap_gb_per_month | number | Malware scanning on upload(part of map of object) | -1 | No |  "-1" or "above 0" | NA
scan_results_event_grid_topic_id | bool | Scan_result_event(part of map of object)you must set override_subscription_settings_enabled to true | {} | No |  "true" or "false" | NA
sensitive_data_discovery_enabled | bool | Sensitive data discovery(part of map of object) | false | No | "true" or "false" | NA




# Outputs

| Output Name              | Description                                      |
|--------------------------|--------------------------------------------------|
| defender_id              | ID of the defender                               |



## Notes


## Authors
Mohammed Irfan

## Contributors
mohammedirfan@clouodxsupport.com

## Team DL
devops@cloudxchange.io


