component {

    // NOTE: Updated with new Database.
    public boolean function checkEmailExists(
        string emailID
    )
    {
        try{
            local.emailCountResult = queryExecute(
                "SELECT COUNT(*) AS emailCount FROM UserDetails WHERE Email = :email;",
                {email: arguments.emailID}
            );
            if(local.emailCountResult.recordCount > 0 && local.emailCountResult.emailCount[1] > 0) {
                return true;
            }
            else{
                return false;
            }
        }
        catch (any e) {
            writeLog(file="Aarogyalogs", text="Error checking email: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }

    
    // NOTE: Updated with new Database.
    public boolean function updateSessionDetails(
        string emailID,
        string SessionID
    )
    {
        try {
            local.updateSession = queryExecute(
                "UPDATE UserDetails
                 SET sessionId = :sessionId
                 WHERE Email = :email",
                { 
                    email: arguments.emailID, // Use the passed emailID directly
                    sessionId: arguments.SessionID // Use the passed emailID directly
                }
            );

            return true; 
        } 
        catch (any e) {
            writeLog(file="Aarogyalogs", text="Error inserting email for session: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }

    // NOTE: Updated with new Database.
    public boolean function invalidateSessions(
        string emailID
    )
    {
        try {
            local.updateSession = queryExecute(
                "UPDATE UserDetails
                 SET sessionId = NULL
                 WHERE Email = :email",
                { 
                    email: arguments.emailID // Use the passed emailID directly
                }
            );

            return true; 
        } 
        catch (any e) {
            writeLog(file="Aarogyalogs", text="Error inserting email for session: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }


    // NOTE: Updated with new Database.
    // REMEMBER: The Insertion (Registration) for both patient and admin and carried by different functions (insertUser & insertAdmin).
    public boolean function insertUser(
        string role,
        string name,
        string dob,
        string email,
        string phoneNumber,
        string insuranceProvider,
        string insuranceCoverage,
        string hashedPassword
    ){
        try{
            queryExecute(
                "INSERT INTO UserDetails(
                    UserRole,
                    FullName,
                    DOB,
                    Email,
                    Phone,
                    InsuranceProvider,
                    InsuranceCoverageDuration,
                    Pass
                )
                VALUES(
                    :UserRole,
                    :fullName,
                    :dob,
                    :email,
                    :phone,
                    :insuranceProvider,
                    :insuranceCoverage,
                    :pass
                )",
                {
                    UserRole:arguments.role,
                    fullName:arguments.name,
                    dob:arguments.dob,
                    email:arguments.email,
                    phone:arguments.phoneNumber,
                    insuranceProvider:arguments.insuranceProvider,
                    insuranceCoverage:arguments.insuranceCoverage,
                    pass:arguments.hashedPassword
                }
            );
           return true;
        }
        catch (any e) {
            writeLog(file="Aarogyalogs", text="Error registering user: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }

    // NOTE: Updated with new Database.
    public boolean function insertAdmin(
        string role,
        string name,
        string email,
        string hashedPassword
    ){
        try{
            queryExecute(
                "INSERT INTO UserDetails(
                    UserRole,
                    FullName,
                    Email,
                    Pass
                )
                VALUES(
                    :UserRole,
                    :fullName,
                    :email,
                    :pass
                )",
                {
                    UserRole:arguments.role,
                    fullName:arguments.name,
                    email:arguments.email,
                    pass:arguments.hashedPassword
                }
            );
           return true;
        }
        catch (any e) {
            writeLog(file="Aarogyalogs", text="Error registering admin: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }

    // NOTE: Updated with new Database.
    public boolean function checkUserPassword(
        string email, 
        string hashedPassword
    ) 
    {
        try {
            local.loginUser = queryExecute(
                "SELECT Pass FROM UserDetails 
                WHERE Email = :email",
                {email: arguments.email}
            );
    
            // If a record exists, compare the hashed password
            if (local.loginUser.recordCount > 0) {
                return (arguments.hashedPassword == local.loginUser.Pass[1]);
            }
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error comparing password: " & e.message & "; Details: " & e.detail);
        }
        
        return false; 
    }

    // NOTE: Updated with new Database.
    public struct function getUserDetails(
        string email
    ) 
    {
        local.details = {};
    
        try {
            local.userDetailsResult = queryExecute(
                "SELECT UserID, FullName, DOB, Email, Phone, InsuranceProvider, InsuranceCoverageDuration, UserRole 
                FROM UserDetails
                WHERE Email = :email",
                {email: arguments.email}
            );
    
            if (local.userDetailsResult.recordCount > 0) {
                local.details = {
                    UserID: local.userDetailsResult.UserID[1],
                    FullName: local.userDetailsResult.FullName[1],
                    DOB: DateFormat(local.userDetailsResult.DOB[1], "mmmm dd, yyyy"),
                    Email: arguments.email,
                    Phone: local.userDetailsResult.Phone[1],
                    InsuranceProvider: local.userDetailsResult.InsuranceProvider[1],
                    InsuranceCoverageDuration: DateFormat(local.userDetailsResult.InsuranceCoverageDuration[1], "mmmm dd, yyyy"),
                    UserRole: local.userDetailsResult.UserRole[1]
                };
            }
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error retrieving user: " & e.message & "; Details: " & e.detail);
        }
        
        return local.details;
    }

       
    // NOTE: Updated with new Database.
    public boolean function updateToken(
        string email, 
        string resetToken, 
        date resetTokenExpiration
    ) 
    {
        try {
            // Convert the date to a format that SQL Server understands
            local.formattedDate = dateFormat(arguments.resetTokenExpiration, "yyyy-mm-dd") & " " & timeFormat(arguments.resetTokenExpiration, "HH:mm:ss");
    
            local.updateResetTokenResult = queryExecute(
                "UPDATE UserDetails
                SET ResetToken = :resetToken,
                ResetTokenExpiry = :resetTokenExpiration
                WHERE Email = :email",
                {
                    resetToken: arguments.resetToken,
                    resetTokenExpiration: local.formattedDate,
                    email: arguments.email
                }
            );
    
            return true;
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error updating token: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }
    
    // NOTE: Updated with new Database.
    public struct function validateToken(
        string resetToken
    ) 
    {
        local.details={};
        try{
            local.validateTokenResult = queryExecute(
                "SELECT Email, ResetTokenExpiry FROM UserDetails  
                 WHERE ResetToken = :resetToken",
                { resettoken: arguments.resetToken}
            );
            if(validateTokenResult.recordCount > 0 AND validateTokenResult.resettokenexpiry > now())
            {
                local.details={
                    email: validateTokenResult.email[1],
                    resetTokenExpiration: validateTokenResult.resettokenexpiry[1]
                }
            }    
        }
        catch(any e){
            writeLog(file="Aarogyalogs", text="Error validating token: " & e.message & "; Details: " & e.detail);
        }
        return local.details;
    }

    // NOTE: Updated with new Database.
    public boolean function updatePassword(
        string hashedPassword,
        string email
    ) 
    {
        try{
            local.updatePasswordResult = queryExecute(
                "UPDATE UserDetails
                 SET Pass = :password,
                 ResetToken = NULL
                 WHERE Email = :email",
                { 
                    password: arguments.hashedPassword,
                    email: arguments.email
                }
            );
           return true;  
        }
        catch(any e){
            writeLog(file="Aarogyalogs", text="Error updating password: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }

    // NOTE: Updated with new Database.
    public boolean function updateUserBasicInfo(
        string name,
        string dob,
        string email,
        string phoneNumber
    ) 
    {
        try {
            local.formattedDate = dateFormat(arguments.dob, "yyyy-mm-dd")
    
            queryExecute(
                "UPDATE UserDetails
                SET FullName = :FullName,
                    DOB = :DOB,
                    Email = :Email,
                    Phone = :Phone
                WHERE UserID = :UserID",
                {
                    FullName: arguments.name,
                    DOB: local.formattedDate,
                    Email: arguments.email,
                    Phone: arguments.phoneNumber,
                    UserID: session.UserID
                }
            );
    
            return true;
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error updating token: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }

    // NOTE: Updated with new Database.
    public boolean function updateUserInsuranceInfo(
        string insuranceProvider,
        string insuranceCoverage
    ) 
    {
        try {
            local.formattedDate = dateFormat(arguments.insuranceCoverage, "yyyy-mm-dd")
    
            queryExecute(
                "UPDATE UserDetails
                SET InsuranceProvider = :InsuranceProvider,
                InsuranceCoverageDuration = :InsuranceCoverage
                WHERE UserID = :UserID",
                {
                    InsuranceProvider: arguments.insuranceProvider,
                    insuranceCoverage: local.formattedDate,
                    UserID: session.UserID
                }
            );
    
            return true;
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error updating token: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }
    
}