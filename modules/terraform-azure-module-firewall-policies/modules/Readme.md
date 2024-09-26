# Terraform Module for AZURE FIREWALL POLICY

## This module creates following resources :
1) Multiple Firewall policies in one module call 
2) Multiple Collection like custom rule, application rule, NAT rule, Network rule and we can dynamically attach these rules to Firewall policies as per our choice.


## Module Usage

### Description

### Azure Firewall Policy
Azure Firewall Policy is a comprehensive network security policy management solution that enables centralized control over firewall configurations. It includes features for threat intelligence, intrusion detection, and custom rule sets. Policies can be dynamically updated and include support for DNS, identity, and insights configurations. Azure Firewall Policy ensures robust protection and compliance across Azure deployments.

#### Azure Web Application Firewall (WAF) Policy
Azure Web Application Firewall (WAF) Policy provides advanced security for web applications by filtering and monitoring HTTP requests. It includes customizable rules for detecting and mitigating threats, with options for custom and managed rulesets. WAF Policies support dynamic adjustments and detailed logging, ensuring effective protection against a variety of web vulnerabilities and attacks.

**Please refer to "sample" folder for complete and  minimalistic example.**

1. complete_main.tf
2. minimalistic_main.tf

## Requirements
| Name      | Version  |
|-----------|----------|
| Terraform | ~> 1.5.0 |


# Inputs
# Inputs

 Variable Name                              | Type         | Description                                                               | Default | Required | Accepted Values                           | Modification Forces Recreation 
------------------------------------------|--------------|---------------------------------------------------------------------------|---------|----------|-------------------------------------------|--------------------------------
  `firewall_policies`                          | map(object)                        | Map of firewall policies with required and optional fields                  | `{}`    | Yes      | Map of firewall policies                          | Yes                            |
| `name`                                       | string                             | Name of the firewall policy                                                 |   | Yes      | Example: `"my-firewall-policy"`                  | Yes                            |
| `resource_group_name`                        | string                             | Name of the resource group where the firewall policy is located             |     | Yes      | Example: `"my-resource-group"`                   | Yes                            |
| `location`                                   | string                             | Location for the firewall policy                                            |    | Yes      | Example: `"East US"`                             | Yes                            |
| `base_policy_id`                             | string (optional)                  | The base policy ID (if applicable)                                          |   | No       | `null`, or a valid base policy ID                | Yes                            |
| `dns`                                        | object (optional)                  | DNS settings, including servers and proxy enablement                        |   | No       | List of DNS servers and proxy_enabled flag       | No                            |
| `identity`                                   | object (optional)                  | Identity settings with type and optional list of identity IDs               |   | No       | Object containing `type` and optional `identity_ids` | Yes                        |
| `insights`                                   | object (optional)                  | Insights settings, including logging configuration and retention period     |  | No       | Insights configuration                          | NO                             |
| `intrusion_detection`                        | object (optional)                  | Intrusion detection configuration with private ranges and signature overrides |   | No       | List of intrusion detection settings             | Yes                            |
| `private_ip_ranges`                          | list(string) (optional)            | List of private IP ranges                                                   |     | No       | List of private IP ranges                        | No                             |
| `auto_learn_private_ranges_enabled`          | bool (optional)                    | Enable/disable automatic learning of private ranges                         |  | No       | `true`, `false`                                 | No                             |
| `sku`                                        | string (optional)                  | SKU of the firewall policy                                                  | "Standard" | No   | `"Standard"`, `"Premium"`                       | Yes                            |
| `tags`                                       | map(string) (optional)             | Tags to associate with the firewall policy                                  |     | No       | Map of tags                                     | No                             |
| `threat_intelligence_allowlist`              | object (optional)                  | Threat intelligence allowlist, including IP addresses and FQDNs             |   | No       | Object with `ip_addresses` and `fqdns`          | No                             |
| `threat_intelligence_mode`                   | string (optional)                  | Threat intelligence mode                                                    | "Alert" | No     | `"Alert"`, `"Deny"`                             | No                             |
| `tls_certificate`                            | object (optional)                  | TLS certificate configuration with key vault secret ID                      |   | No       | Object containing `key_vault_secret_id`         | Yes                            |
| `sql_redirect_allowed`                       | bool (optional)                    | Enable/disable SQL redirect                                                 |  | No       | `true`, `false`                                 | No                             |
| `explicit_proxy`                             | object (optional)                  | Explicit proxy settings including ports and PAC file                        |   | No       | Object with `enabled`, `http_port`, `https_port`, etc. | No                    |
`proxy_enabled ` | bool | proxy_enabled  for DNS | false | No | "True" or "False" | No 
`firewall_policy_rule_collection_groups` | map(object) | Map of firewall policy rule collection groups                              |      | Yes      | Values for each rule collection group      | Yes
 `name`                                          | string          | The name of the firewall configuration.                                     |    | Yes      | String                                    | Yes                            |
| `firewall_policy_id`                            | string          | The ID of the firewall policy.                                              |    | Yes      | String                                    | Yes                            |
| `priority`                                      | number          | The priority of the firewall policy.                                        |     | Yes      | Number                                    | No                            |
### Application Rule Collections

| Variable Name                                   | Type            | Description                                                                | Default | Required | Accepted Values                           | Modification Forces Recreation |
|-------------------------------------------------|-----------------|----------------------------------------------------------------------------|---------|----------|-------------------------------------------|--------------------------------|
| `application_rule_collections.name`             | string          | The name of the application rule collection.                                |    | Yes      | String                                    | Yes                            |
| `application_rule_collections.description`      | string          | *(Optional)* Description of the application rule collection.                |   | No       | String                                    | No                             |
| `application_rule_collections.priority`         | number          | The priority of the application rule collection.                            |      | Yes      | Number                                    | No                            |
| `application_rule_collections.action`           | string          | The action to be taken (Allow/Deny).                                        |     | Yes      | `"Allow"`, `"Deny"`                       | No                            |
| `application_rule_collections.rules`            | list(object)    | A list of rules for the application rule collection.                        |     | Yes      | List of objects                           | Yes                            |

#### Application Rule Attributes

| Variable Name                                   | Type            | Description                                                                | Default | Required | Accepted Values                           | Modification Forces Recreation |
|-------------------------------------------------|-----------------|----------------------------------------------------------------------------|---------|----------|-------------------------------------------|--------------------------------|
| `rules.name`                                    | string          | The name of the rule.                                                      |    | Yes      | String                                    | No                            |
| `rules.protocols.type`                          | string          | The type of the protocol.                                                  |     | Yes      | `"Http"`, `"Https"`, `"Mssql"`            | No                            |
| `rules.protocols.port`                          | number          | The port number used by the protocol.                                       |     | Yes      | Number                                    | No                            |
| `rules.http_headers`                            | list(object)    | *(Optional)* A list of HTTP headers (name and value).                       |     | No       | List of objects                           | No                             |
| `rules.source_addresses`                        | list(string)    | A list of source IP addresses.                                              |     | Yes      | List of strings                           | No                            |
| `rules.source_ip_groups`                        | list(string)    | *(Optional)* A list of source IP groups.                                    |   | No       | List of strings                           | No                             |
| `rules.destination_urls`                        | list(string)    | *(Optional)* A list of destination URLs.                                    |   | No       | List of strings                           | No                             |
| `rules.destination_fqdns`                       | list(string)    | A list of destination Fully Qualified Domain Names (FQDNs).                 |     | Yes      | List of strings                           | NO                            |
| `rules.terminate_tls`                           | bool            | *(Optional)* Whether to terminate TLS.                                      |  | No       | Boolean                                   | No                             |
| `rules.web_categories`                          | list(string)    | *(Optional)* A list of web categories.                                      |   | No       | List of strings                           | No                             |
### Network Rule Collections

| Variable Name                                   | Type            | Description                                                                | Default | Required | Accepted Values                           | Modification Forces Recreation |
|-------------------------------------------------|-----------------|----------------------------------------------------------------------------|---------|----------|-------------------------------------------|--------------------------------|
| `network_rule_collections.name`                 | string          | The name of the network rule collection.                                    |     | Yes      | String                                    | No                            |
| `network_rule_collections.description`          | string          | *(Optional)* Description of the network rule collection.                    |  | No       | String                                    | No                             |
| `network_rule_collections.priority`             | number          | The priority of the network rule collection.                                |     | Yes      | Number                                    | No                            |
| `network_rule_collections.action`               | string          | The action to be taken (Allow/Deny).                                        |     | Yes      | `"Allow"`, `"Deny"`                       | No                            |
| `network_rule_collections.rules`                | list(object)    | A list of rules for the network rule collection.                            |     | Yes      | List of objects                           | Yes                            |

#### Network Rule Attributes

| Variable Name                                   | Type            | Description                                                                | Default | Required | Accepted Values                           | Modification Forces Recreation |
|-------------------------------------------------|-----------------|----------------------------------------------------------------------------|---------|----------|-------------------------------------------|--------------------------------|
| `rules.name`                                    | string          | The name of the rule.                                                      |     | Yes      | String                                    | No                            |
| `rules.protocols`                               | list(string)    | A list of protocols.                                                       |     | Yes      | List of strings                           | Yes                            |
| `rules.source_addresses`                        | list(string)    | *(Optional)* A list of source IP addresses.                                 |   | No       | List of strings                           | No                             |
| `rules.destination_addresses`                   | list(string)    | *(Optional)* A list of destination IP addresses.                            |  | No       | List of strings                           | No                             |
| `rules.destination_ports`                       | list(number)    | A list of destination ports.                                               |     | Yes      | List of numbers                           | No                            |

### NAT Rule Collections

| Variable Name                                   | Type            | Description                                                                | Default | Required | Accepted Values                           | Modification Forces Recreation |
|-------------------------------------------------|-----------------|----------------------------------------------------------------------------|---------|----------|-------------------------------------------|--------------------------------|
| `nat_rule_collections.name`                     | string          | The name of the NAT rule collection.                                        |   | Yes      | String                                    | No                            |
| `nat_rule_collections.priority`                 | number          | The priority of the NAT rule collection.                                    |      | Yes      | Number                                    | No                            |
| `nat_rule_collections.action`                   | string          | The action to be taken (Allow/Deny).                                        |     | Yes      | `"Allow"`, `"Deny"`                       | No                            |
| `nat_rule_collections.rules`                    | list(object)    | A list of rules for the NAT rule collection.                                |     | Yes      | List of objects                           | Yes                            |

#### NAT Rule Attributes

| Variable Name                                   | Type            | Description                                                                | Default | Required | Accepted Values                           | Modification Forces Recreation |
|-------------------------------------------------|-----------------|----------------------------------------------------------------------------|---------|----------|-------------------------------------------|--------------------------------|
| `rules.name`                                    | string          | The name of the rule.                                                      |     | Yes      | String                                    | No                            |
| `rules.protocols`                               | list(string)    | A list of protocols.                                                      |   | Yes      | List of strings                           | Yes                            |
| `rules.source_addresses`                        | list(string)    | *(Optional)* A list of source IP addresses.                                 |   | No       | List of strings                           | No                             |
| `rules.destination_address`                     | string          | *(Optional)* The destination IP address.                                    |   | No       | String                                    | No                             |
| `rules.translated_address`                      | string          | The translated IP address.                                                 |    | Yes      | String                                    | No                            |
| `rules.translated_port`                         | number          | *(Optional)* The translated port.                                           |   | No       | Number                                    | No                             |
`rules.destination_port` | list(number) | A list of destination ports | | Yes | list of Ports | No |

#### Application policy Front Door

| Variable Name                                   | Type            | Description                                                                | Default | Required | Accepted Values                           | Modification Forces Recreation |
|-------------------------------------------------|-----------------|----------------------------------------------------------------------------|---------|----------|-------------------------------------------|--------------------------------|
| `name`                                          | string          | The name of the Web Application Firewall (WAF) policy.                      |     | Yes      | String                                    | Yes                            |
| `resource_group_name`                           | string          | The name of the resource group.                                             |     | Yes      | String                                    | Yes                            |
| `enabled`                                       | bool            | *(Optional)* Enable or disable the WAF policy.                              | `true`  | No       | Boolean                                   | No                             |
| `mode`                                          | string          | *(Optional)* The mode of the WAF policy (`Prevention` or `Detection`).       |   | No       | `"Prevention"`, `"Detection"`             | No                             |
| `redirect_url`                                  | string          | *(Optional)* URL to redirect blocked requests to.                           |   | No       | String                                    | No                             |
| `custom_block_response_status_code`             | number          | *(Optional)* HTTP status code to return for blocked requests.               |   | No       | 403, 404, 429                             | No                             |
| `custom_block_response_body`                    | string          | *(Optional)* Custom body for the blocked response.                          |   | No       | String                                    | No                             |

### Custom Rules

| Variable Name                                   | Type            | Description                                                                | Default | Required | Accepted Values                           | Modification Forces Recreation |
|-------------------------------------------------|-----------------|----------------------------------------------------------------------------|---------|----------|-------------------------------------------|--------------------------------|
| `custom_rules.name`                             | string          | The name of the custom rule.                                                |    | Yes      | String                                    | No                            |
| `custom_rules.enabled`                          | bool            | *(Optional)* Enable or disable the custom rule.                             | `true`  | No       | Boolean                                   | No                             |
| `custom_rules.priority`                         | number          | The priority of the custom rule.                                            | `1`     | Yes      | Number                                    | No                            |
| `custom_rules.rate_limit_duration_in_minutes`   | number          | The time window for rate limiting (in minutes).                             | `1`     | Yes      | Number                                    | No                            |
| `custom_rules.rate_limit_threshold`             | number          | The maximum number of requests allowed during the rate limit window.        | `10`     | Yes      | Number                                    | No                            |
| `custom_rules.type`                             | string          | The type of the rule (`Match` or `RateLimit`).                              |     | Yes      | `"Match"`, `"RateLimit"`                  | No                            |
| `custom_rules.action`                           | string          | The action to take on matching requests (`Allow`, `Block`, `Log`).          |     | Yes      | `"Allow"`, `"Block"`, `"Log"`, `Redirect`             | No                            |

#### Custom Rule Match Conditions

| Variable Name                                   | Type            | Description                                                                | Default | Required | Accepted Values                           | Modification Forces Recreation |
|-------------------------------------------------|-----------------|----------------------------------------------------------------------------|---------|----------|-------------------------------------------|--------------------------------|
| `custom_rules.match_conditions.match_variable`  | string          | The match variable (e.g., `RemoteAddr`, `RequestUri`).                      |     | Yes      | String                                    | Yes                            |
| `custom_rules.match_conditions.operator`        | string          | The operator used for matching (e.g., `Equals`, `Contains`).                |     | Yes      | String                                    | Yes                            |
| `custom_rules.match_conditions.negation_condition`| bool           | *(Optional)* Negate the match condition.                                    |  | No       | Boolean                                   | No                             |
| `custom_rules.match_conditions.match_values`    | list(string)    | A list of values to match against.                                          | `  | Yes      | List of strings                           | Yes                            |
| `custom_rules.match_conditions.transforms`      | list(string)    | *(Optional)* Transformations to apply to the match value (`Lowercase`).     |   | No       | List of strings                           | No                             |
| `custom_rules.match_conditions.selector`        | string          | *(Optional)* The selector to apply (e.g., for JSON or XML).                 |   | No       | String                                    | No                             |

### Managed Rules

| Variable Name                                   | Type            | Description                                                                | Default | Required | Accepted Values                           | Modification Forces Recreation |
|-------------------------------------------------|-----------------|----------------------------------------------------------------------------|---------|----------|-------------------------------------------|--------------------------------|
| `managed_rules.type`                            | string          | The type of managed rule (e.g., `OWASP`).                                   |     | Yes      | String                                    | No                            |
| `managed_rules.version`                         | string          | The version of the managed rule (e.g., `3.2`).                              |    | Yes      | String                                    | No                            |

#### Managed Rule Exclusions

| Variable Name                                   | Type            | Description                                                                | Default | Required | Accepted Values                           | Modification Forces Recreation |
|-------------------------------------------------|-----------------|----------------------------------------------------------------------------|---------|----------|-------------------------------------------|--------------------------------|
| `managed_rules.exclusions.match_variable`       | string          | The match variable to exclude from the rule.                                |    | Yes      | String                                    | No                            |
| `managed_rules.exclusions.operator`             | string          | The operator used for exclusion (e.g., `Equals`, `Contains`).               |     | Yes      | String                                    | No                            |
| `managed_rules.exclusions.selector`             | string          | The selector used for the exclusion.                                        |     | Yes      | String                                    | NO                            |

#### Managed Rule Overrides

| Variable Name                                   | Type            | Description                                                                | Default | Required | Accepted Values                           | Modification Forces Recreation |
|-------------------------------------------------|-----------------|----------------------------------------------------------------------------|---------|----------|-------------------------------------------|--------------------------------|
| `managed_rules.overrides.rule_group_name`       | string          | The name of the rule group to override.                                     |    | Yes      | String                                    | No                            |
| `managed_rules.overrides.rules.rule_id`         | string          | The ID of the rule to override.                                             |     | Yes      | String                                    | No                            |
| `managed_rules.overrides.rules.enabled`         | bool            | *(Optional)* Enable or disable the rule.                                    | `false`  | No       | Boolean                                   | No                             |
| `managed_rules.overrides.rules.action`          | string          | The action to take on matching requests (`Allow`, `Block`, `Log`).          |     | Yes      | `"Allow"`, `"Block"`, `"Log"`             | No                            |

###### WAF policy ##############
| Variable Name                                   | Type            | Description                                                                | Default | Required | Accepted Values                           | Modification Forces Recreation |
|-------------------------------------------------|-----------------|----------------------------------------------------------------------------|---------|----------|-------------------------------------------|--------------------------------|
| `name`                                          | string          | The name of the Web Application Firewall (WAF) policy.                      |     | Yes      | String                                    | Yes                            |
| `resource_group_name`                           | string          | The name of the resource group.                                             |    | Yes      | String                                    | Yes                            |
| `policy-setting-enabled`                        | bool   | (Optional) Enable or disable the WAF policy.                | TRUE          | No       | Boolean    | No        |
| `policy-setting-mode`                           | string | (Optional) The mode of the WAF policy - request_body_check  | Prevention          | No       | "Prevention", "Detection" | No |
| `policy-setting-request_body_check`             | bool   | request_body_check in WAF policy                            | TRUE          | No       | "True" or "False" | No   |
| `policy-setting-file_upload_limit_in_mb`        | number | file_upload_limit_in_mb in WAF policy                       | 100           | No       | "1 to 4000" | No        |
| `policy-setting-max_request_body_size_in_kb`    | number | max_request_body_size_in_kb in WAF policy                   | 128           | No       | "8 to 2000" | No        |
| `request_body_enforcement`                      | bool   | request_body_enforcement for WAF policy                     | TRUE          | No       | "True" or "False" | No   |
| `request_body_inspect_limit_in_kb`              | number | request_body_inspect_limit_in_kb for WAF policy             | 128           | No       | 128 or above | No       |
| `js_challenge_cookie_expiration_in_minutes`     | number | js_challenge_cookie_expiration_in_minutes for WAF policy    | 30            | No       | "5 to 1440" | No       |
 `log_scrubbing` | string | for Sensitive data | {} | No | string | No | 

### Custom Rules

| Variable Name                                   | Type            | Description                                                                | Default | Required | Accepted Values                           | Modification Forces Recreation |
|-------------------------------------------------|-----------------|----------------------------------------------------------------------------|---------|----------|-------------------------------------------|--------------------------------|
| `custom_rules.name`                             | string          | The name of the custom rule.                                                |    | Yes      | String                                    | No                            |
| `custom_rules.enabled`                          | bool            | *(Optional)* Enable or disable the custom rule.                             | `true`  | No       | Boolean                                   | No                             |
| `custom_rules.priority`                         | number          | The priority of the custom rule.                                            |     | Yes      | Number                                    | No                            |
| `custom_rules.rate_limit_duration_in_minutes`   | number          | The time window for rate limiting (in minutes).                             |      | Yes      | Number                                    | No                            |
| `custom_rules.rate_limit_threshold`             | number          | The maximum number of requests allowed during the rate limit window.        |      | Yes      | Number                                    | No                            |
| `custom_rules.type`                             | string          | The type of the rule (`Match` or `RateLimit`).                              |     | Yes      | `"Match"`, `"RateLimit"`                  | No                            |
| `custom_rules.action`                           | string          | The action to take on matching requests (`Allow`, `Block`, `Log`).          |    | Yes      | `"Allow"`, `"Block"`, `"Log"`             | No                            |

#### Custom Rule Match Conditions

| Variable Name                                   | Type            | Description                                                                | Default | Required | Accepted Values                           | Modification Forces Recreation |
|-------------------------------------------------|-----------------|----------------------------------------------------------------------------|---------|----------|-------------------------------------------|--------------------------------|
| `custom_rules.match_conditions.match_variable`  | string          | The match variable (e.g., `RemoteAddr`, `RequestUri`).                      |     | Yes      | String                                    | No                            |
| `custom_rules.match_conditions.operator`        | string          | The operator used for matching (e.g., `Equals`, `Contains`).                |     | Yes      | String                                    | No                            |
| `custom_rules.match_conditions.negation_condition`| bool           | *(Optional)* Negate the match condition.                                    |  | No       | Boolean                                   | No                             |
| `custom_rules.match_conditions.match_values`    | list(string)    | A list of values to match against.                                          |     | Yes      | List of strings                           | No                            |
| `custom_rules.match_conditions.transforms`      | list(string)    | *(Optional)* Transformations to apply to the match value (`Lowercase`).     |   | No       | List of strings                           | No                             |
| `custom_rules.match_conditions.selector`        | string          | *(Optional)* The selector to apply (e.g., for JSON or XML).                 |   | No       | String                                    | No                             |

### Managed Rules

| Variable Name                                   | Type            | Description                                                                | Default | Required | Accepted Values                           | Modification Forces Recreation |
|-------------------------------------------------|-----------------|----------------------------------------------------------------------------|---------|----------|-------------------------------------------|--------------------------------|
| `managed_rules_set.type`                            | string          | The type of managed rule (e.g., `OWASP`).                                   |     | Yes      | String                                    | Yes                            |
| `managed_rules_set.version`                         | string          | The version of the managed rule (e.g., `3.2`).                              |     | Yes      | String                                    | Yes                            |

#### Managed Rule Exclusions

| Variable Name                                   | Type            | Description                                                                | Default | Required | Accepted Values                           | Modification Forces Recreation |
|-------------------------------------------------|-----------------|----------------------------------------------------------------------------|---------|----------|-------------------------------------------|--------------------------------|
| `managed_rules.exclusions.match_variable`       | string          | The match variable to exclude from the rule.                                |     | Yes      | String                                    | Yes                            |
| `managed_rules.exclusions.operator`             | string          | The operator used for exclusion (e.g., `Equals`, `Contains`).               |     | Yes      | String                                    | Yes                            |
| `managed_rules.exclusions.selector`             | string          | The selector used for the exclusion.                                        |     | Yes      | String                                    | Yes                            |
`excluded_rule_set_managed_rules_set.type` | string | The type of managed rule (e.g., OWASP).                     |          | No       | String    | No        |
| `excluded_rule_set_managed_rules._setversion` | string | The version of the managed rule (e.g., 3.2).                 |          | No       | String    | No        |
| `excluded_rule_set_rule_group_name`        | string | The name for Rule group under exclusion, excluded_rule_set   |          | Yes      | String    | No        |

#### Managed Rule Overrides

| Variable Name                                   | Type            | Description                                                                | Default | Required | Accepted Values                           | Modification Forces Recreation |
|-------------------------------------------------|-----------------|----------------------------------------------------------------------------|---------|----------|-------------------------------------------|--------------------------------|
| `managed_rules.overrides.rule_group_name`       | string          | The name of the rule group to override.                                     |     | Yes      | String                                    | No                            |
| `managed_rules.overrides.rules.rule_id`         | string          | The ID of the rule to override.                                             |     | Yes      | String                                    | No                            |
| `managed_rules.overrides.rules.enabled`         | bool            | *(Optional)* Enable or disable the rule.                                    | `false`  | No       | Boolean                                   | No                             |
| `managed_rules.overrides.rules.action`          | string          | The action to take on matching requests (`Allow`, `Block`, `Log`).          |     | Yes      | `"Allow"`, `"Block"`, `"Log"`             | No                            |











# Outputs

| Output Name                                      | Description                                                                                                        |
|--------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------|
| `firewall_policy_id`                             | The ID of the Firewall Policy.                                                                 
| `firewall_policy_child_policies`                 | A list of references to child Firewall Policies of this Firewall Policy.                                           |
| `firewall_policy_firewalls`                      | A list of references to Azure Firewalls that this Firewall Policy is associated with.                               |
| `firewall_policy_rule_collection_groups`         | A list of references to Firewall Policy Rule Collection Groups that belong to this Firewall Policy.                  |
| `Firewall_Policy_Rule_Collection_Group_ID`  | Id of Firewall Policy Rule Collection Group |
| `frontdoor_firewall_policy_ids`                  | A list of IDs for the Front Door Firewall Policies.                                                                |
| `frontdoor_firewall_policy_locations`            | A list of Azure Regions where the Front Door Firewall Policies exist.                                               |
| `frontdoor_firewall_policy_frontend_endpoint_ids`| A list of Frontend Endpoint IDs associated with the Front Door Firewall Policies.                                   |
| `web_application_firewall_policy_ids`      `      | A list of IDs for the Web Application Firewall Policies.                                        `                   |




## Notes


## Authors
mohammedirfan@cloudxsupport.com

## Contributors


## Team DL
devops@cloudxchange.io
