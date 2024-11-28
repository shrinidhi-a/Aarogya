component {

    // NOTE: Updated with new Database.
    public struct function getAdminDetails(string email) {
        local.details = {};
    
        try {
            local.adminDetailsResult = queryExecute(
                "SELECT FullName, UserID
                FROM UserDetails
                WHERE Email = :email AND Availability =:Availability",
                {email: arguments.email, Availability: application.USER_AVAILABLE}
            );
    
            if (local.adminDetailsResult.recordCount > 0) {
                local.details = {
                    FullName: local.adminDetailsResult.FullName[1],
                    ID: local.adminDetailsResult.UserID[1],
                    Email: arguments.email
                };
            }
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error retrieving admin: " & e.message & "; Details: " & e.detail);
        }
        
        return local.details;
    }

    // NOTE: Updated with new Database.
    public boolean function updateAdminBasicInfo(
        string name,
        string email
    ) 
    {
        try {

            queryExecute(
                "UPDATE UserDetails
                SET FullName = :FullName,
                    Email = :Email
                WHERE UserID = :ID",
                {
                    FullName: arguments.name,
                    Email: arguments.email,
                    ID: session.userID
                }
            );
    
            return true;
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error updating token: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }

    // // NOTE: Updated with new Database.
    // public boolean function checkEmailExists(emailID){
    //     try{
    //         local.emailCountResult = queryExecute(
    //             "SELECT COUNT(*) AS emailCount FROM UserDetails WHERE Email = :email;",
    //             {email: arguments.emailID}
    //         );
    //         if(local.emailCountResult.recordCount > 0 && local.emailCountResult.emailCount[1] > 0) {
    //             return true;
    //         }
    //         else{
    //             return false;
    //         }
    //     }
    //     catch (any e) {
    //         writeLog(file="Aarogyalogs", text="Error checking email: " & e.message & "; Details: " & e.detail);
    //         return false;
    //     }
    // }

    // // NOTE: Updated with new Database.
    // public boolean function checkUserPassword(string email, string hashedPassword) {
    //     try {
    //         local.loginAdmin = queryExecute(
    //             "SELECT Pass FROM UserDetails 
    //             WHERE Email = :email",
    //             {email: arguments.email}
    //         );
    
    //         // If a record exists, compare the hashed password
    //         if (local.loginAdmin.recordCount > 0) {
    //             return (arguments.hashedPassword == local.loginAdmin.Pass[1]);
    //         }
    //     } catch (any e) {
    //         writeLog(file="Aarogyalogs", text="Error comparing password: " & e.message & "; Details: " & e.detail);
    //     }
        
    //     return false; 
    // } 

    // NOTE: Updated with new Database.
    public boolean function updatePasswordAdmin(
        string hashedPassword,
        string email
    ) 
    {
        try{
            local.updatePasswordResult = queryExecute(
                "UPDATE UserDetails
                 SET Pass = :password
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
    public boolean function checkUserPasswordAdmin(
        string email, 
        string hashedPassword
    ) 
    {
        try {
            local.passUser = queryExecute(
                "SELECT Pass FROM UserDetails 
                WHERE Email = :email",
                {email: arguments.email}
            );
    
            // If a record exists, compare the hashed password
            if (local.passUser.recordCount > 0) {
                return (arguments.hashedPassword == local.passUser.Pass[1]);
            }
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error comparing password: " & e.message & "; Details: " & e.detail);
        }
        
        return false; 
    }    

    
}