'use strict';
var displayControl = angular.module('bahmni.common.displaycontrol.custom');
displayControl.directive('birthCertificates', ['$q', 'observationsService', 'appService', 'spinner', '$sce', function ($q, observationsService, appService, spinner, $sce) {
    var link = function ($scope) {
		var conceptNames = ["Delivery Note-Liveborn gender","Delivery Note-Liveborn weight","Delivery Note-Delivery date and time","Delivery Note-Name of Father"];
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
}]);

displayControl.directive('deathCertificate', ['observationsService', 'appService', 'spinner', function (observationsService, appService, spinner) {
        var link = function ($scope) {
            var conceptNames = ["WEIGHT"];
            $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/deathCertificate.html";
            spinner.forPromise(observationsService.fetch($scope.patient.uuid, conceptNames, "latest", undefined, $scope.visitUuid, undefined).then(function (response) {
                $scope.observations = response.data;
            }));
        };

        return {
            restrict: 'E',
            link: link,
            template: '<ng-include src="contentUrl"/>'
        }
}]);

displayControl.directive('customTreatmentChart', ['appService', 'treatmentConfig', 'TreatmentService', 'spinner', '$q', function (appService, treatmentConfig, treatmentService, spinner, $q) {
        var link = function ($scope) {
            var Constants = Bahmni.Clinical.Constants;
            var days = [
                'Sunday',
                'Monday',
                'Tuesday',
                'Wednesday',
                'Thursday',
                'Friday',
                'Saturday'
            ];
            $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/customTreatmentChart.html";

            $scope.atLeastOneDrugForDay = function (day) {
                var atLeastOneDrugForDay = false;
                $scope.ipdDrugOrders.getIPDDrugs().forEach(function (drug) {
                    if (drug.isActiveOnDate(day.date)) {
                        atLeastOneDrugForDay = true;
                    }
                });
                return atLeastOneDrugForDay;
            };

            $scope.getVisitStopDateTime = function () {
                return $scope.visitSummary.stopDateTime || Bahmni.Common.Util.DateUtil.now();
            };

            $scope.getStatusOnDate = function (drug, date) {
                var activeDrugOrders = _.filter(drug.orders, function (order) {
                    if ($scope.config.frequenciesToBeHandled.indexOf(order.getFrequency()) !== -1) {
                        return getStatusBasedOnFrequency(order, date);
                    } else {
                        return drug.getStatusOnDate(date) === 'active';
                    }
                });
                if (activeDrugOrders.length === 0) {
                    return 'inactive';
                }
                if (_.every(activeDrugOrders, function (order) {
                        return order.getStatusOnDate(date) === 'stopped';
                    })) {
                    return 'stopped';
                }
                return 'active';
            };

            var getStatusBasedOnFrequency = function (order, date) {
                var activeBetweenDate = order.isActiveOnDate(date);
                var frequencies = order.getFrequency().split(",").map(function (day) {
                    return day.trim();
                });
                var dayNumber = moment(date).day();
                return activeBetweenDate && frequencies.indexOf(days[dayNumber]) !== -1;
            };

            var init = function () {
                var getToDate = function () {
                    return $scope.visitSummary.stopDateTime || Bahmni.Common.Util.DateUtil.now();
                };

                var programConfig = appService.getAppDescriptor().getConfigValue("program") || {};

                var startDate = null,
                    endDate = null,
                    getEffectiveOrdersOnly = false;
                if (programConfig.showDetailsWithinDateRange) {
                    startDate = $stateParams.dateEnrolled;
                    endDate = $stateParams.dateCompleted;
                    if (startDate || endDate) {
                        $scope.config.showOtherActive = false;
                    }
                    getEffectiveOrdersOnly = true;
                }

                return $q.all([treatmentConfig(), treatmentService.getPrescribedAndActiveDrugOrders($scope.config.patientUuid, $scope.config.numberOfVisits,
                        $scope.config.showOtherActive, $scope.config.visitUuids || [], startDate, endDate, getEffectiveOrdersOnly)])
                    .then(function (results) {
                        var config = results[0];
                        var drugOrderResponse = results[1].data;
                        var createDrugOrderViewModel = function (drugOrder) {
                            return Bahmni.Clinical.DrugOrderViewModel.createFromContract(drugOrder, config);
                        };
                        for (var key in drugOrderResponse) {
                            drugOrderResponse[key] = drugOrderResponse[key].map(createDrugOrderViewModel);
                        }

                        var groupedByVisit = _.groupBy(drugOrderResponse.visitDrugOrders, function (drugOrder) {
                            return drugOrder.visit.startDateTime;
                        });
                        var treatmentSections = [];

                        for (var key in groupedByVisit) {
                            var values = Bahmni.Clinical.DrugOrder.Util.mergeContinuousTreatments(groupedByVisit[key]);
                            treatmentSections.push({
                                visitDate: key,
                                drugOrders: values
                            });
                        }
                        if (!_.isEmpty(drugOrderResponse[Constants.otherActiveDrugOrders])) {
                            var mergedOtherActiveDrugOrders = Bahmni.Clinical.DrugOrder.Util.mergeContinuousTreatments(drugOrderResponse[Constants.otherActiveDrugOrders]);
                            treatmentSections.push({
                                visitDate: Constants.otherActiveDrugOrders,
                                drugOrders: mergedOtherActiveDrugOrders
                            });
                        }
                        $scope.treatmentSections = treatmentSections;
                        if ($scope.visitSummary) {
                            $scope.ipdDrugOrders = Bahmni.Clinical.VisitDrugOrder.createFromDrugOrders(drugOrderResponse.visitDrugOrders, $scope.visitSummary.startDateTime, getToDate());
                        }
                    });
            };
            spinner.forPromise(init());
        };

        return {
            restrict: 'E',
            link: link,
            scope: {
                config: "=",
                visitSummary: '='
            },
            template: '<ng-include src="contentUrl"/>'
        }
}]);

displayControl.directive('patientAppointmentsDashboard', ['$http', '$q', '$window', 'appService', function ($http, $q, $window, appService) {
        var link = function ($scope) {
            $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/patientAppointmentsDashboard.html";
            var getUpcomingAppointments = function () {
                var params = {
                    q: "bahmni.sqlGet.upComingAppointments",
                    v: "full",
                    patientUuid: $scope.patient.uuid
                };
                return $http.get('/openmrs/ws/rest/v1/bahmnicore/sql', {
                    method: "GET",
                    params: params,
                    withCredentials: true
                });
            };
            var getPastAppointments = function () {
                var params = {
                    q: "bahmni.sqlGet.pastAppointments",
                    v: "full",
                    patientUuid: $scope.patient.uuid
                };
                return $http.get('/openmrs/ws/rest/v1/bahmnicore/sql', {
                    method: "GET",
                    params: params,
                    withCredentials: true
                });
            };
            $q.all([getUpcomingAppointments(), getPastAppointments()]).then(function (response) {
                $scope.upcomingAppointments = response[0].data;
                $scope.upcomingAppointmentsHeadings = _.keys($scope.upcomingAppointments[0]);
                $scope.pastAppointments = response[1].data;
                $scope.pastAppointmentsHeadings = _.keys($scope.pastAppointments[0]);
            });

            $scope.goToListView = function () {
                $window.open('/bahmni/appointments/#/home/manage/appointments/list');
            };
        };
        return {
            restrict: 'E',
            link: link,
            scope: {
                patient: "=",
                section: "="
            },
            template: '<ng-include src="contentUrl"/>'
        };
}]);

displayControl.directive('dischargeSummary', ['observationsService', 'appService', 'spinner', function (observationsService, appService, spinner) {
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
}]);

// Lab test list
try {
	var clinicalApp = angular.module('bahmni.clinical');
	clinicalApp.directive('a', function () {
		var link = function ($scope, element, attrs, ngModel) {
			if(element.context.className === 'grid-row-element button orderBtn ng-binding ng-scope'){
				if($scope.test.name.display.substring(0,19) == 'Lab Group Separator'){
					element.removeClass('grid-row-element');
					element.removeClass('buttonss');
					element.removeAttr('ng-click');
					element.attr('ng-disabled','1');
					element.removeClass('orderBtn');
					element.css('min-width','94%');
					element.css('margin-bottom','10px');
					element.css('border','none');
					element.css('margin-left','0');
					element.css('padding-left','0');
					element.css('background','#ccc');
					element.css('pointer-events','none');
				}
			}
		};
		return { link: link };
	});
} catch(e) {
    console.log('App not initialized... [bahmni.clinical]');
}