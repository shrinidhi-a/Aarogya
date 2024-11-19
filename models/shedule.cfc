component {

    // NOTE: Updated with new Database.
    public boolean function update()
    {
        try{
            local.currentTime = now();
            local.formattedTime = timeFormat(local.currentTime, "HH:mm");
            local.formattedDate = dateFormat(local.currentTime, "yyyy-MM-dd"); 
            // local.formattedTime = "09:45";

            local.timeConvert = {
                "08:45" : "09:00",
                "09:45" : "10:00",
                "10:45" : "11:00",
                "11:45" : "12:00",
                "12:45" : "13:00",
                "13:45" : "14:00",
                "14:45" : "15:00",
                "15:45" : "16:00",
                "16:45" : "17:00",
                "17:45" : "18:00",
                "18:45" : "19:00"
            }

            if(StructKeyExists(local.timeConvert, local.formattedTime)){
                local.appointmentInfo = queryExecute(
                    "SELECT U.Email " & 
                    "FROM UserDetails U " & 
                    "JOIN Appointments A ON U.UserID = A.PatientID " & 
                    "WHERE A.AppointmentStatus = :status " & 
                    "AND CAST(A.StartTime AS TIME) = :time " & 
                    "AND A.DateAndTime = :date",
                    {   
                        status: application.APPOINTMENT_STATUS_CONFIRMED,
                        time: local.timeConvert[local.formattedTime],
                        date: local.formattedDate 
                    }
                );

                if (local.appointmentInfo.recordCount > 0) {
                    local.link = "http://localhost:8500/AarogyaMiniProject-2.0/index.cfm?action=profile"

                    local.emailBody = "
                    <html>
                    <body>
                        <p>Dear User,</p>
                        <p>This is a reminder that your appointment is scheduled for <strong>#local.timeConvert[local.formattedTime]#</strong>.</p>
                        <p>You can check your appointment details using the link below:</p>
                        <p><a href='#local.link#'>Go to Aarogya website</a></p>
                        <p>Thank you for choosing us for your healthcare needs. If you have any questions or need further assistance, please feel free to reach out.</p>
                        <p>Regards,<br>Aarogya</p>
                    </body>
                    </html>
                    "


                    for (row in local.appointmentInfo) {
                        cfmail(
                            to=row.Email,
                            from=application.MAIL_FROM,
                            subject="Aarogya: Your Appointment Remainder",
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
                    }
                }
                return true;
            }else{
                return false;
            }
        }
        catch (any e) {
            writeLog(file="Aarogyalogs", text="Error: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }

    public boolean function updateNoShow()
    {
        try{
            local.currentTime = now();
            local.formattedTime = timeFormat(local.currentTime, "HH:mm");
            local.formattedDate = dateFormat(local.currentTime, "yyyy-MM-dd"); 
            // local.formattedTime = "09:45";

            local.timeConvert = {
                "09:45" : "09:00",
                "10:45" : "10:00",
                "11:45" : "11:00",
                "12:45" : "12:00",
                "13:45" : "13:00",
                "14:45" : "14:00",
                "15:45" : "15:00",
                "16:45" : "16:00",
                "17:45" : "17:00",
                "18:45" : "18:00",
                "19:45" : "19:00"
            }

            if(StructKeyExists(local.timeConvert, local.formattedTime)){
                local.appointmentInfo = queryExecute(
                    "SELECT U.Email, A.AppointmentID " & 
                    "FROM UserDetails U " & 
                    "JOIN Appointments A ON U.UserID = A.PatientID " & 
                    "WHERE A.AppointmentStatus = :status " & 
                    "AND CAST(A.StartTime AS TIME) = :time " & 
                    "AND A.DateAndTime = :date",
                    {   
                        status: application.APPOINTMENT_STATUS_CONFIRMED,
                        time: local.timeConvert[local.formattedTime],
                        date: local.formattedDate 
                    }
                );

                if (local.appointmentInfo.recordCount > 0) {

                    for (local.row in local.appointmentInfo) {

                        local.appointmentID = local.row.AppointmentID;

                        queryExecute(
                            "UPDATE Appointments 
                            SET AppointmentStatus = :NoShow
                            WHERE AppointmentID = :AppointmentID",
                            {
                                NoShow: application.APPOINTMENT_STATUS_NOSHOW,
                                AppointmentID: local.appointmentID
                            }
                        );

                        local.link = "http://localhost:8500/AarogyaMiniProject-2.0/index.cfm?action=profile"

                        local.emailBody = "
                        <html>
                            <body>
                                <p>Dear User,</p>
                                <p>This is to inform you that you have missed your appointment scheduled for <strong>#local.timeConvert[local.formattedTime]#</strong>.</p>
                                <p>If this was an oversight or you would like to reschedule your appointment, please visit the link below to get more information:</p>
                                <p><a href='#local.link#'>Go to Aarogya website</a></p>
                                <p>We understand that sometimes things can come up. If you need assistance or wish to reschedule, please don't hesitate to contact us.</p>
                                <p>Thank you for choosing us for your healthcare needs.</p>
                                <p>Regards,<br>Aarogya</p>
                            </body>
                        </html>
                        "


                        
                        cfmail(
                            to=local.row.Email,
                            from=application.MAIL_FROM,
                            subject="Aarogya: You have missed your Appointment",
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
                        
                    }
                    return true;
                }else{
                    return false;
                }      
            }else{
                return false;
            }
        }
        catch (any e) {
            writeLog(file="Aarogyalogs", text="Error: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }
}