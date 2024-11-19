<cfscript>
    try{
        local.sheduler = new model.shedule();
        local.sheduler.update();
        local.sheduler.updateNoShow();
    } catch (any e) {
        writeLog(file="Aarogyalogs", text="Error: " & e.message & "; Details: " & e.detail);
    }
</cfscript>