component output="true"{

    // NOTE: Updated with Aarogya2.0
    remote struct function getDoctors(
        string category
    ) 
        returnformat="JSON"
    {
        local.response = {
            data: structNew(),
            message: '',
            success: false
        };

        try {
            local.doctors = new model.doctors();

            if (session.isLoggedIn && structKeyExists(session, "role")){
                local.response.data = local.doctors.getDoctorsInfo(arguments.category);
                local.response.message = "Successfully retrived doctor information"; 
                local.response.success = true; 
            } else {
                local.response.message = "Unauthenticated access"; 
            }
        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

    // NOTE: Updated with Aarogya2.0
    remote struct function updateDoctorInfo(
        string key,
        string name,
        string email,
        string phone,
        string qualification
    ) 
    returnformat="JSON" 
    {

        local.response = {
            message: '',
            success: false,
            sessionAvailable: true
        };

        try {
            local.update = new model.doctors();

            if (!session.isLoggedIn || !structKeyExists(session, "role") || session.role != "admin") {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            local.sessionVal = new model.session();
            if(!local.sessionVal.getSessionValidation()){
                local.response.sessionAvailable = false; 
                return local.response;
            }

            if (local.update.checkEmailExistsForOthers(arguments.email, arguments.key)) {
                local.response.message = "Doctor Email Already present in Aarogya";
                return local.response;
            }

            if (local.update.updateDoctorInfo(
                arguments.key,
                arguments.name,
                arguments.email,
                arguments.phone,
                arguments.qualification
                )) {
                local.response.success = true;
                local.response.message = "Doctor Details updated successfully";
            } else {
                local.response.message = "Failded to update Doctor details";
            }

        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

    // NOTE: Updated with Aarogya2.0
    remote struct function removeDoctorInfo(
        string doctorId
    ) 
    returnformat="JSON" 
    {

        local.response = {
            message: '',
            success: false,
            sessionAvailable: true
        };

        try {
            local.remove = new model.doctors();

            if (!session.isLoggedIn || !structKeyExists(session, "role") || session.role != "admin") {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            local.sessionVal = new model.session();
            if(!local.sessionVal.getSessionValidation()){
                local.response.sessionAvailable = false; 
                return local.response;
            }

            if (local.remove.removeDoctorInfo(
                arguments.doctorId
                )) {
                local.response.success = true;
                local.response.message = "Doctor Details removed successfully";
            } else {
                local.response.message = "Failded to remove Doctor details";
            }

        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

    // NOTE: Updated with Aarogya2.0
    remote struct function createNewDoctorProfile(
        name,
        file,
        email,
        phone,
        qualification,
        category
    ) 
        returnformat="JSON"
    {
        local.response = {
            message: '',
            success: false,
            sessionAvailable: true
        };

        try {
            if (!(session.isLoggedIn && structKeyExists(session, "role") && session.role == "admin")) {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            local.doctors = new model.doctors();
            
            if (local.doctors.checkEmailExists(arguments.email)) {
                local.response.message = "Doctor already present in Aarogya";
                return local.response;
            }

            local.sessionVal = new model.session();
            if(!local.sessionVal.getSessionValidation()){
                local.response.sessionAvailable = false; 
                return local.response;
            }

            local.uploadDirectory = expandPath("../uploads/images");

            if (!directoryExists(local.uploadDirectory)) {
                directoryCreate(local.uploadDirectory);
            }

            local.uploadedFilePath = fileUpload(
                destination="#local.uploadDirectory#", 
                fileField="file",
                onConflict= "MakeUnique"
            );

            local.filePath = "/images/"& uploadedFilePath.serverFile;

            if (local.doctors.createNewDoctor(
                arguments.name,
                arguments.email,
                arguments.phone,
                arguments.qualification,
                arguments.category,
                local.filePath
            )) {
                local.response.success = true;
                local.response.message = "New doctor profile created successfully";
            } else {
                local.response.message = "Unable to create new doctor profile";
            }
        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }
}