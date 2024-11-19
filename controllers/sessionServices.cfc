component output="true"{
    remote struct function getSessionValidation() 
        returnformat="JSON"
    {
        local.response = {
            data: structNew(),
            message: '',
            success: false
        };

        try {
            local.sessionInfo = new model.session();

            if (session.isLoggedIn) {
                if(local.sessionInfo.getSessionValidation()){
                    local.response.success = true;
                    local.response.message = "Validation Success"; 
                }else{
                    local.response.success = false;
                    local.response.message = "Invalid session details"; 
                }
            } else {
                local.response.message = "Unauthenticated access"; 
            }
        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

}
