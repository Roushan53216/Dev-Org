({
    doInit : function(component, event, helper) {
        var action = component.get("c.getDepartmantName");
        //action.setParams({ firstName : cmp.get("v.firstName") });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log(result.departmentName);
                component.set("v.departmentToAdmit",result.departmentName);
                console.log(component.get("v.departmentToAdmit"));

            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);

    },
    getDoctors : function(component, event, helper) {
        var action = component.get("c.getAllDoctors");
        action.setParams({ department : component.get("v.departmant") });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log(result);
                component.set("v.doctorList",result);
                //console.log(component.get("v.departmentToAdmit"));

            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);


    },
    handleSubmit : function(component, event, helper) {
        var action = component.get("c.insertPatient");
        action.setParams({ 'Name' : component.get("v.patientName"),
                            'AppointmentDate': component.get("v.appointmentDate"),
                            'departmentToAdmit' : component.get("v.departmant"),
                            'appointmentTime' : component.get("v.appointmentTime"),
                            'doctor' : component.get("v.doctor"),
                            //departmentToAdmit : component.get("v.departmant"),  
                        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log(result);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Appointment Has Been Scheduled SuucessFully.',
                    duration:' 1000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'sticky'
                });
                toastEvent.fire();

            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})