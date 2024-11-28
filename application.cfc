component {
    this.name = "Aarogya";
    this.applicationTimeout = CreateTimeSpan(10, 0, 0, 0);
    this.sessionManagement = true;
    this.sessionTimeout = CreateTimeSpan(0, 0, 30, 0);
    this.datasource="ProjectAarogya2.0";
    this.mappings = StructNew();
    this.mappings["/model"] = "C:\ColdFusion2023\cfusion\wwwroot\Aarogya\models";
   
    function onApplicationStart() {
        structAppend(Application, {
            "MAIL_FROM" : "contact.aarogyasite@gmail.com",
            "MAIL_USERNAME" : "contact.aarogyasite@gmail.com",
            "MAIL_PASSWORD" : "wnbt sfia lblv qgob",
            "MAIL_SERVER" : "smtp.gmail.com",
            "MAIL_PORT" : "465",
            "MAIL_SSL" : "true",
            "APPOINTMENT_STATUS_PENDING" : "Pending",
            "APPOINTMENT_STATUS_CONFIRMED" : "Confirmed",
            "APPOINTMENT_STATUS_COMPLETED" : "Completed",
            "APPOINTMENT_STATUS_CANCELLED" :"Cancelled",
            "APPOINTMENT_STATUS_NOSHOW" :"NoShow",
            "DOCTOR_WORKSTATUS_AVAILABLE" : "available",
            "DOCTOR_WORKSTATUS_UNAVAILABLE" : "unavailable",
            "USER_UNAVAILABLE" : "unavailable",
            "USER_AVAILABLE" : "available",
            "CATEGORY_STATUS_AVAILABLE" : "available",
            "CATEGORY_STATUS_UNAVAILABLE" : "unavailable"
        });

        // var OnStartComponentInstance = createObject("component", "model.onStartEvents")
        // var resultgetInproperStatuses = OnStartComponentInstance.getInproperStatuses()
        // writeLog(file="AarogyaInfos", text=resultgetInproperStatuses);

        return true;
    }

    function onSessionStart() {
        session.isLoggedIn = false;

    }

    function onRequestStart(string templatePage) {
        var allowedActions = {
            "home": "home",
            "login": "login",
            "register": "register",
            "forgotpassword": "forgotpassword",
            "resetPassword": "resetPassword",
            "profile": "profile",
            "newAppointment": "newAppointment",
            "newDoctor": "newDoctor",
            "newCategory": "newCategory",
            "myprofile": "myprofile",
            "manageDoctors": "manageDoctors",
            "manageCategory": "manageCategory",
            "reports": "reports",
            "error": "errorPage",
            "restart" : "restart",
            "sheduler-2353DD262":"sheduler",
            "landing":"landing",
            "manageUser":"manageUser"
        };

        

        if (url.keyExists("action") && allowedActions.keyExists(url.action)) {
            var action = url.action;

            if(action == "restart"){
                sessionInvalidate(); 
                //TODO: There is a bug in coldfusion, does not clear session on applicationStop()
                applicationStop();
                cflocation(url="index.cfm?action=home", addToken=false);
            }

            if(structKeyExists(session, "isLoggedIn") && session.isLoggedIn && action == "landing"){
                if(structKeyExists(session, "role") && session.role == "admin"){
                    cflocation(url="index.cfm?action=profile", addToken=false);
                }
            }
            
            if (structKeyExists(session, "isLoggedIn") && !session.isLoggedIn && listFindNoCase('landing,profile,newAppointment,newDoctor,newCategory,myprofile,manageDoctors,manageCategory,manageUser,reports', action)) {
                request.path = allowedActions["login"];
            } else if(structKeyExists(session, "isLoggedIn") && session.isLoggedIn && listFindNoCase('login,register,adminLogin,home', action)) {
                // request.path = allowedActions["profile"];
                request.path = allowedActions["landing"];
            }else{
                request.path = allowedActions[action];
            }
        }else if(structIsEmpty(url)){
            if(structKeyExists(session, "isLoggedIn") && session.isLoggedIn){
                // cflocation(url="index.cfm?action=profile", addToken=false);
                cflocation(url="index.cfm?action=landing", addToken=false);
            }else{
                cflocation(url="index.cfm?action=home", addToken=false);
            }
            
        }
        else{
            request.path = allowedActions["error"];
        }
    }

    public boolean function onMissingTemplate(string templatePage) {
        writeLog(file="Aarogyalogs", text="Error fetching categories: " & templatePage);
        cflocation(url="index.cfm?action=error", addToken=false);
        return true;
    }

    function onError( any e) {
        writeDump(e);
    } 

}