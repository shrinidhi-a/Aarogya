component output="true"{

// NOTE: Updated with Aarogya2.0
    remote struct function generateXLSForAppointment(
        string appontmentID
    )
        returnformat="JSON" {

        local.response = {
            message: '',
            success: false,
            path: "",
            sessionAvailable: true
        };

        try {
            local.generatexls = new model.file();

            // Check for authenticated user
            if (!(session.isLoggedIn && structKeyExists(session, "role") && session.role == "admin")) {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            local.sessionVal = new model.session();
            if(!local.sessionVal.getSessionValidation()){
                local.response.sessionAvailable = false; 
                return local.response;
            }

            // Attempt to generate the XLS file
            local.xlsInfo = local.generatexls.generateXLSForAppointment(arguments.appontmentID);
            
            if (local.xlsInfo.success) {
                local.response.message = local.xlsInfo.message;
                local.response.success = true;
                local.response.path = local.xlsInfo.path;
            } else {
                local.response.message = local.xlsInfo.message;
            }

        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

    // NOTE: Updated with Aarogya2.0
    remote struct function generateAllXLS()
        returnformat="JSON" {

        local.response = {
            message: '',
            success: false,
            path: "",
            sessionAvailable: true
        };

        try {
            local.generatexls = new model.file();

            // Check for authenticated user
            if (!(session.isLoggedIn && structKeyExists(session, "role"))) {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            local.sessionVal = new model.session();
            if(!local.sessionVal.getSessionValidation()){
                local.response.sessionAvailable = false; 
                return local.response;
            }

            // Attempt to generate the XLS file
            local.xlsInfo = local.generatexls.generateAllXLS();
            
            if (local.xlsInfo.success) {
                local.response.message = local.xlsInfo.message;
                local.response.success = true;
                local.response.path = local.xlsInfo.path;
            } else {
                local.response.message = local.xlsInfo.message;
            }

        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

    // NOTE: Updated with Aarogya2.0
    remote struct function generatePartialXLS(string status="", string mail="", string date="")
        returnformat="JSON" {

        local.response = {
            message: '',
            success: false,
            path: "",
            sessionAvailable: true
        };

        try {
            local.generatexls = new model.file();

            // Check for authenticated user
            if (!(session.isLoggedIn && structKeyExists(session, "role"))) {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            local.sessionVal = new model.session();
            if(!local.sessionVal.getSessionValidation()){
                local.response.sessionAvailable = false; 
                return local.response;
            }

            // Attempt to generate the XLS file
            local.xlsInfo = local.generatexls.generatePartialXLS(arguments.status, arguments.mail, arguments.date);
            
            if (local.xlsInfo.success) {
                local.response.message = local.xlsInfo.message;
                local.response.success = true;
                local.response.path = local.xlsInfo.path;
            } else {
                local.response.message = local.xlsInfo.message;
            }

        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

    // NOTE: Updated with Aarogya2.0
    // TODO: No use
    remote struct function generatePrescription(
        string key
    ) 
    returnformat="JSON" {

        local.response = {
            message: '',
            success: false,
            path: '',
            sessionAvailable: true
        };

        try {
            local.prescription = new model.file();

            // Check for authenticated user
            if (!(session.isLoggedIn && structKeyExists(session, "role") && session.role == "patient")) {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            local.sessionVal = new model.session();
            if(!local.sessionVal.getSessionValidation()){
                local.response.sessionAvailable = false; 
                return local.response;
            }

            // Attempt to get the prescription
            local.cancelStatus = local.prescription.getPrescription(arguments.key);
            
            if (local.cancelStatus.success) {
                local.response.success = true;
                local.response.path = local.cancelStatus.path;
                local.response.message = "Prescription downloaded successfully";
            } else {
                local.response.message = local.cancelStatus.message;
            }

        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

    remote struct function generateXLS()
        returnformat="JSON" {

        local.response = {
            message: '',
            success: false,
            path: "",
            sessionAvailable: true
        };

        try {
            local.generatexls = new model.file();

            // Check for authenticated user
            if (!(session.isLoggedIn && structKeyExists(session, "role"))) {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            local.sessionVal = new model.session();
            if(!local.sessionVal.getSessionValidation()){
                local.response.sessionAvailable = false; 
                return local.response;
            }

            // Attempt to generate the XLS file
            local.xlsInfo = local.generatexls.generateXLS();
            
            if (local.xlsInfo.success) {
                local.response.message = local.xlsInfo.message;
                local.response.success = true;
                local.response.path = local.xlsInfo.path;
            } else {
                local.response.message = local.xlsInfo.message;
            }

        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }
}