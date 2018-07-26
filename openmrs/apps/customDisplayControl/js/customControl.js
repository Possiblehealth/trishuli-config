'use strict';
angular.module('bahmni.common.displaycontrol.custom')
    // Birth Certificate
    .directive('birthCertificate', ['$q', 'observationsService', 'appService', 'spinner', '$sce', function ($q, observationsService, appService, spinner, $sce) {
            var link = function ($scope) {
                var conceptNames = ["Delivery Note-Liveborn gender","Delivery Note-Liveborn weight","Delivery Note-Delivery date and time"];
                $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/birthCertificate.html";
                spinner.forPromise(observationsService.fetch($scope.patient.uuid, conceptNames, "latest", undefined, $scope.patientUuid, undefined).then(function (response) {
                    $scope.observations = response.data;
                    $scope.data = {};
                	  angular.forEach($scope.observations, function(obs,key){
                        	$scope.data[obs.conceptNameToDisplay] = obs.valueAsString;
                	 });
                }));
            };
            return {
                restrict: 'E',
                template: '<ng-include src="contentUrl"/>',
                link: link
            }
    }])
    // Discharge Summary
    .directive('dischargeSummary', ['observationsService', 'appService', 'spinner', function (observationsService, appService, spinner) {
            var link = function ($scope) {
                var conceptNames = [
                  "Discharge Note, Admission Date",
                  "Discharge Note, Discharge Date",
                  "Discharge Note, Diagnosis",
                  "OPD-Chief complaint", 
                  "OPD-Medical History",
                  "OPD-History of present illness",
                  "Discharge Note, Brief Hospital Course",
                  "Physical Examination",
                  "OPD-Physical Examination Details", 
                  "OPD-Problem", 
                  "Discharge Note, Medications on Discharged",
                  "Discharge Note, Followup Instructions",
                  "Discharge Note, Name of Doctor to contact for more information"
                ];
                $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/dischargeSummary.html";
                spinner.forPromise(observationsService.fetch($scope.patientUuid, conceptNames, undefined, undefined, $scope.visitUuid, undefined).then(function (response) {
                    $scope.observations = response.data;
                    $scope.data = {};
                	  angular.forEach($scope.observations, function(obs,key){
                        	$scope.data[obs.conceptNameToDisplay] = obs.valueAsString;
                	 });
                }));
                
                // Get Latest Prescriptions
                var url = '../../openmrs/ws/rest/v1/bahmnicore/drugOrders/prescribedAndActive?getEffectiveOrdersOnly=false&numberOfVisits=1&patientUuid='+$scope.patient.uuid;
                $.getJSON(url, function(result){
                  var treatment = [];
                  $.each(result.visitDrugOrders, function(i, order){

                    //if(order.dateStopped != "null"){
                    treatment.push(order.drug.name + ", " + order.dosingInstructions.dose + " " + order.dosingInstructions.doseUnits + ", " + order.dosingInstructions.frequency + " for " + order.duration + " " + order.durationUnits);
                    //}
                    $scope.treatment = treatment;
                  });
                });
                
                // Get orderResult
                var orderResult_url = '../../openmrs/ws/rest/v1/bahmnicore/labOrderResults?numberOfVisits=1&patientUuid='+$scope.patient.uuid;
                $.getJSON(orderResult_url, function(result){
                  $scope.investigations = [];
                  //console.log(JSON.stringify(result,2,2));s
                  $.each(result.results, function(i, result){
                    $scope.investigations.push(result.testName + " " + result.result);
                  });
                });
                
                // Past Diagnosis
                /*
                var pastDiagnosis_url = '../../openmrs/ws/rest/v1/bahmnicore/diagnosis/search?patientUuid='+$scope.patient.uuid;
                $.getJSON(pastDiagnosis_url, function(result){
                  
                  $scope.pastDiagnosis = [];
                  console.log(JSON.stringify(result,2,2));
                  $.each(result, function(i, diagnosis){
                    $scope.pastDiagnosis.push(diagnosis.certainty + " " + diagnosis.codedAnswer + " " + diagnosis.freeTextAnswer);
                  });
                });*/
            };
            return {
                restrict: 'E',
                template: '<ng-include src="contentUrl"/>',
                link: link
            }
    }])
