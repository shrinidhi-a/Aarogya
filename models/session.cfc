component {

    public boolean function getSessionValidation() {
        
        try {
            local.sessionValidation = queryExecute(
                "SELECT sessionId FROM UserDetails 
                WHERE Email = :email",
                {email: session.userEmail}
            );
            // If a record exists, compare the hashed password
            if (local.sessionValidation.recordCount > 0) {
                return (session.sessionid == local.sessionValidation.sessionId[1]);
            }else{
                return false;
            }
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error retrieving session ID: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }
    
}