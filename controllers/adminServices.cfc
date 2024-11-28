component output="true"{

    // NOTE: Updated with Aarogya2.0
    remote struct function getAdminDetails() returnformat="JSON"
    {
        local.response = {
            message: '',
            data: structNew(),
            success: false
        };

        try {
            local.adminDetail = new model.admin();

            if (!session.isLoggedIn || !structKeyExists(session, "role") || session.role != "admin") {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            local.adminDetails = local.adminDetail.getAdminDetails(session.userEmail);

            if (!structIsEmpty(local.adminDetails)) {
                
                local.response.data.adminFullname = local.adminDetails.FullName;
                local.response.data.adminEmail = local.adminDetails.Email;

                local.response.message = "User Info Fetched successfully";
                local.response.success = true;
            } else {
                local.response.message = "Problem fetching user details";
            }
        } catch (any e) {
            local.response.message = "An error occurred: " & e.message;
        }
        return local.response;
    }

    // NOTE: Updated with Aarogya2.0
    remote struct function updateAdminBasicInfo(
        string name,
        string email
    ) 
    returnformat="JSON" 
    {

        local.response = {
            message: '',
            success: false,
            sessionAvailable: true
            
        };

        try {
            local.updateBasic = new model.admin();
            local.updateUser = new model.user();

            if (!session.isLoggedIn || !structKeyExists(session, "role") || session.role != "admin") {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            local.sessionVal = new model.session();
            if(!local.sessionVal.getSessionValidation()){
                local.response.sessionAvailable = false; 
                return local.response;
            }

            if(local.updateUser.checkEmailExistsUnique(arguments.email)){
                local.response.message = "Email Already Exists"; 
                return local.response;
            }

            if (local.updateBasic.updateAdminBasicInfo(
                arguments.name,
                arguments.email
                )) {
                local.response.success = true;
                local.response.message = "Admin Basic Details updated successfully";
            } else {
                local.response.message = "Failded to update admin basic details";
            }

        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

    // NOTE: Updated with Aarogya2.0
    remote struct function updatePassword(
        string oldpassword,
        string newpassword
    ) returnformat="JSON"
    {
        local.response = {
            message: '',
            success: false,
            sessionAvailable: true
        };

        try {
            local.updatePass = new model.admin();

            if (!session.isLoggedIn || !structKeyExists(session, "role") || session.role != "admin") {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            local.sessionVal = new model.session();
            if(!local.sessionVal.getSessionValidation()){
                local.response.sessionAvailable = false; 
                return local.response;
            }

            local.hashedOldPassword = hash(arguments.oldpassword, "SHA-256");
            local.hashedPassword = hash(arguments.newpassword, "SHA-256");

            if (local.updatePass.checkUserPasswordAdmin(session.userEmail, local.hashedOldPassword)) {
                if (local.updatePass.updatePasswordAdmin(
                        local.hashedPassword,
                        session.userEmail
                    )) {
                    local.response.success = true;
                    local.response.message = "User Password updated successfully";
                } else {
                    local.response.message = "Failded to update user Password";
                }
            } else {
                local.response.message = "Old password is Incorrect";
            }
           
        } catch (any e) {
            local.response.message = "An error occurred: " & e.message;
        }

        return local.response;
    }
}