# trishuli-config
Implementation Configuration for District Trishuli Hospital Nuwakot

#### Wiki
- [Installation Instructions](https://github.com/Possiblehealth/trishuli-config/blob/master/docs/Installation%20Instructions.md)
- [DHIS2 integration](https://github.com/Possiblehealth/trishuli-config/blob/master/docs/DHIS2_Integration.md)
- [Integration with Care Stream](https://github.com/Possiblehealth/trishuli-config/blob/master/docs/Integration_with_Care_Stream.md)
- [Trishuli Deployment Details](https://github.com/Possiblehealth/trishuli-config/blob/master/docs/Trishuli_Deployment_Details.md)


## Default Bahmni configuration and data. 

#### Deploy
- under server (apache) www directory
- alias root (trishuli-config) to bahmni_config
- run `bahmni -i <inventory file> -impl-play <trishuli config path>/playbooks/all.yml install-impl` command to run the ansible tasks.
  
  ex: bahmni -i local -impl-play /var/www/bahmni_config/playbooks/all.yml install-impl

#### Dev commands
* `./scripts/vagrant-link.sh` to link default_config to vagrants /var/www/bahmni_config
* `./scripts/vagrant-database.sh` to run liquibase migrations in vagrant 


#### CI Deployment
The `default-config.zip` is created on the CI Server as part of the **Bahmni_MRS_Master** pipeline (*FunctionalTests* job). You can download the latest zip from this URL:

Latest Builds: [Download Link](https://ci-bahmni.thoughtworks.com/go/files/Bahmni_MRS_Master/Latest/BuildStage/Latest/FunctionalTests/deployables/) 


```
Replace the {Build_Number} variable in the link:

https://ci-bahmni.thoughtworks.com/go/files/Bahmni_MRS_Master/{Build_Number}/BuildStage/Latest/FunctionalTests/deployables/
```




#### Configurations 
 
 1) Clinical app.json: example -  (Details in comments)

```javascript

 "config" : {
    "otherInvestigationsMap": {
        "Radiology": "Radiology Order",
        "Endoscopy": "Endoscopy Order"
    },
    "conceptSetUI": {   // all configs for conceptSet added here
        "XCodedConcept": {  // name of the concept
            "autocomplete": true,  // if set to true, it will show autocomplete instead of dropdown for coded concept answers.
            "showAbnormalIndicator": true   //If set to true, will show a checkbox for capturing abnormal observation.
        },
        "Text Complaints": {    //name of the concept
            "freeTextAutocomplete": {   //if present, will show a textbox, with autocomplete for concept name.
                "conceptSetName": "VITALS_CONCEPT",  // autocomplete will search for concepts which are membersOf this conceptSet (Optional)
                "codedConceptName": "Complaints"     // autocomplete will search for concepts which are answersTo this codedConcept (Optional)
            }
        }
    }
}

```
2) Registration app.json: example -  (Details in comments)

```javascript

"config" : {
  "autoCompleteFields":["familyName", "caste"],
  "defaultIdentifierPrefix": "DTH",
  "searchByIdForwardUrl": "/patient/{{patientUuid}}?visitType=OPD - RETURNING",
  "conceptSetUI": {
      "temparature": {
          "showAbnormalIndicator": true
      }
  },
  "registrationConceptSet":"",
  "showMiddleName": false,
  "showLastName": true,
  "hideFields": ["Height", "Weight", "BMI", "BMI_Status"],  //the fields on screen which should NOT be shown
  "registrationCardPrintLayout": "/bahmni_config/openmrs/apps/registration/registrationCardLayout/print.html",
  "localNameSearch": true,                       // registration search displays parameter for search by local name
  "localNameLabel": "बिरामीको नाम",                // label to be diplyed for local name search input
  "localNamePlaceholder": "बिरामीको नाम",          // placeholder to be diplyed for local name search input
  "localNameAttributes": ["givenNameLocal", "familyNameLocal"]  //patient attributes to be search against for local name search
}

```
