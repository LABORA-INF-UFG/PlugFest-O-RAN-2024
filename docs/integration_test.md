
There are three steps required for testing the integration and communication between the Near- and Non-RT RICs: (i) create a policy type in the Near-RT RIC, (ii) create a policy instance in the Non-RT RIC, and (iii) verify the policy being propagated from the Non- to the Near-RT RICs, detailed below. 

## 1. Create a Policy Type in the A1 Mediator

First, we need a valid policy type schema file in the Near-RT RIC, which we can create using the command below:

<details>
<summary>Policy Type Schema File (click to expand)</summary>
  
```bash
echo '{
  "name": "E2Node UE Energy Policy Type Schema",
  "description": "Defines the UE connections for E2Nodes focusing on management to enhance energy efficiency.",
  "policy_type_id": 5,
  "create_schema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "E2Node UE Energy Policy Configuration",
    "description": "A schema to Defines the UE connections for E2Nodes focusing on management to enhance energy efficiency",
    "type": "object",
    "properties": {
      "E2NodeList": {
        "type": "array",
        "description": "A list of E2Nodes, each defined by specific parameters including Mobile Country Code, Mobile Network Code, NodeB Identifier, and a list of UE (User Equipment) with IMSIs.",
        "items": {
          "type": "object",
          "properties": {
            "mcc": {
              "type": "string",
              "description": "Mobile Country Code identifying the country of the mobile subscriber."
            },
            "mnc": {
              "type": "string",
              "description": "Mobile Network Code identifying the home network of the mobile subscriber."
            },
            "nodebid": {
              "type": "string",
              "description": "NodeB Identifier uniquely identifying a NodeB within a mobile network."
            },
            "UEList": {
              "type": "array",
              "description": "A list of User Equipment identified by IMSIs.",
              "items": {
                "type": "object",
                "properties": {
                  "imsi": {
                    "type": "string",
                    "description": "International Mobile Subscriber Identity uniquely identifying a user of a cellular network."
                  }
                },
                "required": [
                  "imsi"
                ],
                "additionalProperties": false
              }
            }
          },
          "required": [
            "mcc",
            "mnc",
            "nodebid"
          ],
          "additionalProperties": false
        }
      }
    },
    "required": [
      "E2NodeList"
    ],
    "additionalProperties": false
  }
}' >> E2nodeUESchema.json
```
</details>

Note the "policy_type_id"; this will be the ID we will use to reference this policy type.

Next, to interact with the A1 Mediator, we must find the IP address of its HTTP service:
```bash
minikube service service-ricplt-a1mediator-http -n ricplt
```
Now, we can register the policy type with the A1 Mediator:

```bash
export POLICY_ID=5

curl -v -X PUT http://<a1_mediator_http_ip>/a1-p/policytypes/${POLICY_ID} \
-H "Content-Type: application/json" \
-d @E2nodeUESchema.json
```
Which should return an HTTP code 201, indicating the policy type was registered successfully.

## 2. Create a Policy Instance in the Policy Management Service

First, we need a valid policy instance schema file in the Non-RT RIC, which we can create using the command below:

<details>
<summary>Policy Instance Schema File (click to expand)</summary>

```bash
echo '{
  "ric_id": "ric1",
  "policy_id": "456",
  "service_id": "EnergySaverApp",
  "policy_data": {
    "E2NodeList": [
      {
        "mcc": "310",
        "mnc": "260",
        "nodebid": "10001",
        "UEList": [
          {
            "imsi": "7240110"
          },
          {
            "imsi": "7240111"
          }
        ]
      },
      {
        "mcc": "311",
        "mnc": "480",
        "nodebid": "10002",
        "UEList": [
          {
            "imsi": "7240112"
          },
          {
            "imsi": "7240113"
          }
        ]
      }
    ]
  },
  "policytype_id": "5"
}' >>> E2nodeUEInstance.json
```
</details>

Note the "policytype_id" matches the ID in the previous step. 

Next, to interact with the Policy Management Servcie, we must find the IP address of the Non-RT RIC's gateway:
```bash
minikube service nonrtricgateway -n nonrtric
```
Now, we can register the policy type with Non-RT RIC's gateway:
```bash
curl -v -X PUT "http://<a1_mediator_http_ip>/a1-policy/v2/policies" \
-H "Content-Type: application/json" \
-d @E2nodeUEInstance.json
```
Which should return an HTTP code 201, indicating the policy instance was registered successfully.

## 3. Verify Policy Propagation

FInally, we can check the policy instance being propagated from the Non- to the Near-RT RIC.

In the Near-RT RIC, we can check the registered policy types:

```bash
curl -X GET "http://<a1_mediator_http_ip>/A1-P/v2/policytypes/" | jq .
```

And then, check the current policy instance of that particular type, for example:

```bash
curl -s -X GET "http://<a1_mediator_http_ip>/a1-p/v2/policytypes/5/policies/" | jq .
```
Last, we can get details about a particular policy instance, for example:

```bash
curl -s -X GET "http://<a1_mediator_http_ip>/a1-p/v2/policytypes/5/policies/456" | jq .
```
Which should reflect the information of the policy instance we created in step #2.
