component output="true"{

    // NOTE: Updated with Aarogya2.0
    remote struct function userRegistration(
        string role,
        string name,
        string dob,
        string email,
        string phoneNumber,
        string insuranceProvider,
        string insuranceCoverage,
        string password
    ) 
    returnformat="JSON"
    {
        local.response = {
            message: "",
            success: false
        };
    
        try {
    
            // Check if email already exists
            local.registerUserObj = new model.user();

            if (local.registerUserObj.checkEmailExists(arguments.email)) {
                local.response.message = "Email already exists";
                return local.response;
            }
    
            // Hash password and insert user
            local.hashedPassword = hash(arguments.password, "SHA-256");

            if(arguments.role EQ "patient"){
                local.registrationResult = local.registerUserObj.insertUser(
                    arguments.role, 
                    arguments.name, 
                    arguments.dob, 
                    arguments.email, 
                    arguments.phoneNumber, 
                    arguments.insuranceProvider, 
                    arguments.insuranceCoverage, 
                    local.hashedPassword
                )
            }else{
                local.registrationResult = local.registerUserObj.insertAdmin(
                    arguments.role, 
                    arguments.name, 
                    arguments.email,
                    local.hashedPassword
                )
            }

            
            if (local.registrationResult) {
                local.welcomeLink = "http://localhost:8500/AarogyaMiniProject-2.0/index.cfm?action=profile"; 
                local.emailBody = "
                    <html>
                        <body>
                            <p>Dear " & arguments.name & ",</p>
                            <p>Thank you for registering with Aarogya! We're excited to have you on board.</p>
                            <p>To get started, click the link below:</p>
                            <p><a href='" & local.welcomeLink & "'>Login</a></p>
                            <p>If you have any questions, feel free to reach out.</p>
                            <p>Regards,<br>Aarogya</p>
                        </body>
                    </html>
                    "; 
                    cfmail(
                        to=arguments.email,
                        from=application.MAIL_FROM,
                        subject="Aarogya: Registration Successful",
                        type="html",
                        charset="utf-8",
                        username=application.MAIL_USERNAME,
                        password=application.MAIL_PASSWORD,
                        server=application.MAIL_SERVER,
                        port=application.MAIL_PORT,
                        useSSL=application.MAIL_SSL
                    ) {
                        writeOutput(local.emailBody);
                    }
                    local.response.message = "Registration successful! A confirmation email has been sent to your email id.";
                    local.response.success = true; 
            } else {
                local.response.message = "Registration failed. Please try again."; 
            }
            
        } catch (any e) {
            local.response.message = e.message;
        }
    
        return local.response;  
    }

    // NOTE: Updated with Aarogya2.0
    remote struct function userLogin(
        string email,
        string password
    ) returnformat="JSON"
    {
        local.response = {
            message: '',
            user:'',
            success: false
        };

        try {
            local.loginUser = new model.user();

            // Check if email exists
            if (local.loginUser.checkEmailExists(arguments.email)) {
                // Hash the password and check for user authentication
                local.hashedPassword = hash(arguments.password, "SHA-256");

                if (local.loginUser.checkUserPassword(arguments.email, local.hashedPassword)) {

                    local.userDetails = local.loginUser.getUserDetails(arguments.email);

                    // Check if user details are retrieved
                    if (!structIsEmpty(local.userDetails)) {
                        // Set session variables
                        session.UserID = local.userDetails.UserID;
                        session.userFullname = local.userDetails.FullName;
                        session.userDob = local.userDetails.DOB;
                        session.userEmail = arguments.email;
                        session.userPhone = local.userDetails.Phone;
                        session.userInsuranceProvider = local.userDetails.InsuranceProvider;
                        session.InsuranceCoverageDuration = local.userDetails.InsuranceCoverageDuration;
                        session.role = local.userDetails.UserRole;
                        session.isLoggedIn = true;

                        local.loginUser.updateSessionDetails(arguments.email, session.SessionID){
                            local.response.message = "Logged in successfully";
                            local.response.user = "Logged in successfully";
                            local.response.success = true;
                        }
                            
                    } else {
                        local.response.message = "Problem fetching user details";
                    }
                } else {
                    local.response.message = "Incorrect password";
                }
            } else {
                local.response.message = "User does not exist";
            }
        } catch (any e) {
            local.response.message = "An error occurred: " & e.message;
        }

        return local.response;
    }

    // NOTE: Updated with Aarogya2.0
    remote struct function forgotUser(
        string email
    ) returnformat="JSON"
    {
        local.response = {
            message:'',
            success:false
        };
        try{
            local.forgotUser = new model.user();
            local.emailExists = local.forgotUser.checkEmailExists(arguments.email);

            if(local.emailExists){
                local.resetToken = createUUID();
                local.resetTokenExpiration = dateAdd("h", 1, now());
                local.tokenUpdated = local.forgotUser.updateToken(arguments.email, local.resetToken, local.resetTokenExpiration);

                if(local.tokenUpdated){
                    local.resetLink = "http://localhost:8500/AarogyaMiniProject-2.0/index.cfm?action=resetPassword&resetToken=" & local.resetToken;
                    local.emailBody = "
                        <html>
                        <body>
                            <p>Dear User,</p>
                            <p>We received a request to reset your password. Click the link below to reset your password:</p>
                            <p><a href='" & local.resetLink & "'>Reset Password</a></p>
                            <p>If you did not request a password reset, please ignore this email.</p>
                            <p>Regards,<br>Aarogya</p>
                        </body>
                        </html>
                        ";
                    cfmail(
                        to=arguments.email,
                        from=application.MAIL_FROM,
                        subject="Aarogya: Reset Password",
                        type="html",
                        charset="utf-8",
                        username=application.MAIL_USERNAME,
                        password=application.MAIL_PASSWORD,
                        server=application.MAIL_SERVER,
                        port=application.MAIL_PORT,
                        useSSL=application.MAIL_SSL
                    )
                    {
                        writeOutput(local.emailBody);
                    }
                    local.response.message="Mail sent to your email id check your email box";
                    local.response.success=true;
                }
                else{
                    local.response.message="Failed to send the mail try again"; 
                } 
            }
            else {
                local.response.message="User does not exists";
            }
        }
        catch(any e){
            local.response.message=e.message;
        }
        return local.response;
    }

    // NOTE: Updated with Aarogya2.0
    remote struct function resetUser(
        string password,
        string token
    ) 
    returnformat="JSON"
    {
        local.response={
            message:'',
            success:false
        };
        try{
            local.resetUser = new model.user();
            local.tokenValidation = local.resetUser.validateToken(arguments.token);
            if(!structIsEmpty(local.tokenValidation)){
                local.hashedPassword = hash(arguments.password, "SHA-256");
                local.passswordUpdated = local.resetUser.updatePassword(local.hashedPassword, local.tokenValidation.email);
                if(local.passswordUpdated){
                    local.response.message="password reset successful";
                    local.response.success=true;
                }
                else{
                    local.response.message="Failed to reset password";
                }              
            }
            else {
                local.response.message="The reset link is invalid or has been expired";
            }
        }
        catch(any e){
            local.response.message=e.message;
        }
        return local.response;
    }

    // NOTE: Updated with Aarogya2.0
    remote struct function getUserDetails() returnformat="JSON"
    {
        local.response = {
            message: '',
            data: structNew(),
            success: false
        };

        try {
            local.userDetail = new model.user();

            local.userDetails = local.userDetail.getUserDetails(session.userEmail);

            if (!structIsEmpty(local.userDetails)) {
                
                local.response.data.userDob = formatDate(local.userDetails.DOB);
                local.response.data.userInsuranceCoverage = formatDate(local.userDetails.InsuranceCoverageDuration);
                local.response.data.userFullname = local.userDetails.FullName;
                local.response.data.userEmail = local.userDetails.Email;
                local.response.data.userPhone = local.userDetails.Phone;
                local.response.data.userInsuranceProvider = local.userDetails.InsuranceProvider;

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
    remote struct function updateUserBasicInfo(
        string name,
        string dob,
        string email,
        string phoneNumber
    ) 
    returnformat="JSON" 
    {
        local.response = {
            message: '',
            success: false,
            sessionAvailable: true
        };

        try {
            local.updateBasic = new model.user();

            if (!session.isLoggedIn || !structKeyExists(session, "role") || session.role != "patient") {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            local.sessionVal = new model.session();
            local.sessionValue = local.sessionVal.getSessionValidation();
            if(local.sessionValue == false){
                local.response.sessionAvailable = false; 
                return local.response;
            }

            if (local.updateBasic.updateUserBasicInfo(
                arguments.name,
                arguments.dob,
                arguments.email,
                arguments.phoneNumber
                )) {
                local.response.success = true;
                local.response.message = "User Basic Details updated successfully";
            } else {
                local.response.message = "Failded to update user basic details";
            }

        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

    // NOTE: Updated with Aarogya2.0
    remote struct function updateUserInsuranceInfo(
        string insuranceProvider,
        string insuranceCoverage
    ) 
    returnformat="JSON" 
    {

        local.response = {
            message: '',
            success: false,
            sessionAvailable: true
        };

        try {
            local.updateBasic = new model.user();

            if (!session.isLoggedIn || !structKeyExists(session, "role") || session.role != "patient") {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            local.sessionVal = new model.session();
            if(!local.sessionVal.getSessionValidation()){
                local.response.sessionAvailable = false; 
                return local.response;
            }

            if (local.updateBasic.updateUserInsuranceInfo(
                arguments.insuranceProvider,
                arguments.insuranceCoverage
                )) {
                local.response.success = true;
                local.response.message = "User Insurance Details updated successfully";
            } else {
                local.response.message = "Failded to update user Insurance details";
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
            local.updatePass = new model.user();

            if (!session.isLoggedIn || !structKeyExists(session, "role") || session.role != "patient") {
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

            if (local.updatePass.checkUserPassword(session.userEmail, local.hashedOldPassword)) {
                if (local.updatePass.updatePassword(
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

    // NOTE: Updated with Aarogya2.0
    remote struct function logoutUser() 
        returnformat="JSON"
    {
        local.response={
            messsage='',
            success=false
        }
        try{
            local.userSessionClear = new model.user();
            if(local.userSessionClear.invalidateSessions(session.userEmail)){
                sessionInvalidate();
                local.response.message="Logged out successfully";
                local.response.success=true;
            }
        }
        catch (any e) {
            local.response.message=e.message;  
        }
        return local.response;
    }

    function formatDate(value) {
        if (isDate(value)) {
            return dateFormat(value, "yyyy-MM-dd");
        } else {
            return dateFormat(createDateTime(value), "yyyy-MM-dd");
        }
    }
}