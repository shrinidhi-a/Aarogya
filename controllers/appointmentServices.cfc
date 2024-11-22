component output="true"{

    // NOTE: Updated with Aarogya2.0
    remote struct function getAppointmentDetailsForAdmin(string status)
        returnformat="JSON" 
    {

        local.response = {
            data: structNew(),
            message: '',
            success: false
        };

        try {
            local.appointments = new model.appointment();

            // Check for authenticated admin user
            if (!session.isLoggedIn || structKeyExists(session, "role") && session.role != "admin") {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            // Fetch all appointment information based on status
            local.response.data = local.appointments.getAppointmentDetailsForAdmin(arguments.status);
            local.response.message = "Successfully retrieved all the appointment details"; 
            local.response.success = true;

        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

    // NOTE: Updated with Aarogya2.0
    remote struct function completeAppointment(
        string key
    ) 
    returnformat="JSON" 
    {

        local.response = {
            message: '',
            success: false,
            sessionAvailable: true
        };

        try {
            local.complete = new model.appointment();

            // Check for authenticated admin user
            if (!session.isLoggedIn || !structKeyExists(session, "role") || session.role != "admin") {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            local.sessionVal = new model.session();
            if(!local.sessionVal.getSessionValidation()){
                local.response.sessionAvailable = false; 
                return local.response;
            }

            // Attempt to complete the appointment
            if (local.complete.completeAppointment(arguments.key)) {
                local.response.success = true;
                local.response.message = "Appointment completed successfully";
            } else {
                local.response.message = "Unable to complete appointment";
            }

        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

    // NOTE: Updated with Aarogya2.0
    remote struct function cancelAppointment(
        string key,
        string patientname,
        string patientEmail
    ) 
    returnformat="JSON" {

        local.response = {
            message: '',
            success: false,
            sessionAvailable: true
        };

        try {
            local.cancel = new model.appointment();

            // Check for authenticated user with a role
            if (!session.isLoggedIn || !structKeyExists(session, "role")) {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            local.sessionVal = new model.session();
            if(!local.sessionVal.getSessionValidation()){
                local.response.sessionAvailable = false; 
                return local.response;
            }

            // Attempt to cancel the appointment
            if (local.cancel.cancelAppointment(arguments.key)) {
                if (session.role == "admin") {
                    // Prepare the email body
                    local.link = "http://localhost:8500/Aarogya/index.cfm?action=profile";
                    local.emailBody = "
                    <html>
                    <body>
                        <p>Dear " & arguments.patientname & ",</p>
                        <p>We regret to inform you that your appointment number " & arguments.key & " has been rejected.</p>
                        <p>You can check the details and reschedule your appointment using the link below:</p>
                        <p><a href='" & local.link & "'>Go to Aarogya website</a></p>
                        <p>If you have any questions or need further assistance, please feel free to reach out.</p>
                        <p>Thank you for your understanding.</p>
                        <p>Regards,<br>Aarogya</p>
                    </body>
                    </html>
                    ";

                    // Send the cancellation email
                    cfmail(
                        to=arguments.patientEmail,
                        from=application.MAIL_FROM,
                        subject="Aarogya: Appointment Cancelled",
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

                local.response.success = true;
                local.response.message = "Appointment cancelled successfully";
            } else {
                local.response.message = "Unable to cancel your appointment";
            }

        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

    // NOTE: Updated with Aarogya2.0
    remote struct function noshowAppointment(
        string key,
        string patientname,
        string patientEmail
    ) 
    returnformat="JSON" {

        local.response = {
            message: '',
            success: false,
            sessionAvailable: true
        };

        try {
            local.noshow = new model.appointment();

            // Check for authenticated user with a role
            if (!session.isLoggedIn || !structKeyExists(session, "role")) {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            local.sessionVal = new model.session();
            if(!local.sessionVal.getSessionValidation()){
                local.response.sessionAvailable = false; 
                return local.response;
            }

            // Attempt to cancel the appointment
            if (local.noshow.noshowAppointment(arguments.key)) {
                if (session.role == "admin") {
                    // Prepare the email body for no-show notification
                    local.link = "http://localhost:8500/Aarogya/index.cfm?action=profile";
                    local.emailBody = "
                    <html>
                    <body>
                        <p>Dear " & arguments.patientname & ",</p>
                        <p>We noticed that you did not attend your appointment number " & arguments.key & ".</p>
                        <p>You can check the details and reschedule your appointment using the link below:</p>
                        <p><a href='" & local.link & "'>Go to Aarogya website</a></p>
                        <p>If you have any questions or need further assistance, please feel free to reach out.</p>
                        <p>Thank you for your understanding.</p>
                        <p>Regards,<br>Aarogya</p>
                    </body>
                    </html>
                    ";
            
                    // Send the no-show notification email
                    cfmail(
                        to=arguments.patientEmail,
                        from=application.MAIL_FROM,
                        subject="Aarogya: Appointment No-Show Notification",
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
            
                local.response.success = true;
                local.response.message = "Appointment is marked as No Show";
            } else {
                local.response.message = "Unable to mark your appointment as No Show";
            }            

        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

    // NOTE: Updated with Aarogya2.0
    remote struct function acceptAppointment(
        string key,
        string patientname,
        string patientEmail
    ) 
    returnformat="JSON" {

        local.response = {
            message: '',
            success: false,
            sessionAvailable: true
        };

        try {
            local.accept = new model.appointment();

            // Check for authenticated admin user
            if (!session.isLoggedIn || !structKeyExists(session, "role") || session.role != "admin") {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            local.sessionVal = new model.session();
            if(!local.sessionVal.getSessionValidation()){
                local.response.sessionAvailable = false; 
                return local.response;
            }

            // Attempt to accept the appointment
            if (local.accept.acceptAppointment(arguments.key)) {
                // Prepare email details
                local.link = "http://localhost:8500/Aarogya/index.cfm?action=profile";
                local.emailBody = "
                <html>
                <body>
                    <p>Dear " & arguments.patientname & ",</p>
                    <p>We are pleased to inform you that your appointment number " & arguments.key & " has been successfully accepted.</p>
                    <p>You can check progress using the link below:</p>
                    <p><a href='" & local.link & "'>Go to Aarogya website</a></p>
                    <p>Thank you for choosing us for your healthcare needs. If you have any questions or need further assistance, please feel free to reach out.</p>
                    <p>Regards,<br>Aarogya</p>
                </body>
                </html>
                ";

                // Send the acceptance email
                cfmail(
                    to=arguments.patientEmail,
                    from=application.MAIL_FROM,
                    subject="Aarogya: Appointment Approved",
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

                local.response.success = true;
                local.response.message = "Appointment accepted successfully";
            } else {
                local.response.message = "Unable to accept appointment";
            }

        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

    // NOTE: Updated with Aarogya2.0
    remote struct function getAppointmentDetails(string status)
        returnformat="JSON" 
    {

        local.response = {
            data: structNew(),
            message: '',
            success: false
        };

        try {
            local.appointments = new model.appointment();

            // Check for authenticated user with the correct role
            if (!session.isLoggedIn || structKeyExists(session, "role") && session.role != "patient") {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            // Fetch appointment information based on status
            local.response.data = local.appointments.getAppointmentInfo(arguments.status);
            local.response.message = "Successfully retrieved the appointment details"; 
            local.response.success = true;

        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

    // NOTE: Updated with Aarogya2.0
    remote struct function rescheduleAppointment(
        string key,
        string updatedScheduleDate,
        string updatedScheduleTime
    ) 
    returnformat="JSON" 
    {

        local.response = {
            message: '',
            success: false,
            sessionAvailable: true
        };

        try {
            local.reschedule = new model.appointment();

            // Check for authenticated user with the correct role
            if (!session.isLoggedIn || structKeyExists(session, "role") && session.role != "patient") {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            local.sessionVal = new model.session();
            if(!local.sessionVal.getSessionValidation()){
                local.response.sessionAvailable = false; 
                return local.response;
            }

            // Attempt to reschedule the appointment
            if (local.reschedule.rescheduleAppointment(arguments.key, arguments.updatedScheduleDate, arguments.updatedScheduleTime)) {
                local.response.success = true;
                local.response.message = "Appointment rescheduled successfully";
            } else {
                local.response.message = "Unable to reschedule";
            }

        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

    remote struct function getBookedAppointments(
        string selectedDate,
        string selectedDoctor
    ) 
    returnformat="JSON" 
    {

        local.response = {
            message: '',
            success: false,
            data: structNew()
        };

        try {
            local.appointments = new model.appointment();

            if (!session.isLoggedIn || structKeyExists(session, "role") && session.role != "patient") {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            local.result = local.appointments.getBookedAppointments(arguments.selectedDate, arguments.selectedDoctor);

            if (local.result.success) {
                local.response.success = true;
                local.response.data = local.result.data;
                local.response.message = "Available appointments retrived successfully";
            } else {
                local.response.message = "Unable to retrived available appointments details";
            }

        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }


    remote struct function createAppointment(
        string Category,
        string doctor,
        string dateAndTime,
        string startTime
    ) 
    returnformat="JSON" 
    {

        local.response = {
            message: '',
            success: false,
            sessionAvailable: true
        };

        try {
            local.appointment = new model.appointment();

            // Check for authenticated user with the correct role
            if (!session.isLoggedIn || structKeyExists(session, "role") && session.role != "patient") {
                local.response.message = "Unauthenticated access";
                return local.response;
            }

            local.sessionVal = new model.session();
            if(!local.sessionVal.getSessionValidation()){
                local.response.sessionAvailable = false; 
                return local.response;
            }

            // Attempt to create the appointment
            if (local.appointment.createNewAppointment(arguments.Category, arguments.doctor, arguments.dateAndTime, arguments.startTime)) {
                local.response.message = "Your appointment request has been created and is pending admin confirmation."; 
                local.response.success = true; 
            } else {
                local.response.message = "We couldn't create an appointment"; 
            }

        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

    // NOTE: Updated with Aarogya2.0
    remote struct function notifyAppointment(
        string key,
        string patientname,
        string patientEmail,
        string appointmentDate,
        string appointmentTime
    ) 
    returnformat="JSON" {

        local.response = {
            message: '',
            success: false,
            sessionAvailable: true
        };

        try {

            // Check for authenticated admin user
            if (!session.isLoggedIn || !structKeyExists(session, "role") || session.role != "admin") {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            local.sessionVal = new model.session();
            if(!local.sessionVal.getSessionValidation()){
                local.response.sessionAvailable = false; 
                return local.response;
            }

            
            // Prepare email details
            local.link = "http://localhost:8500/Aarogya/index.cfm?action=profile";
            local.emailBody = "
                <html>
                <body>
                    <p>Dear #arguments.patientname#</p>
                    <p>This is a reminder that your appointment is scheduled for <strong>#arguments.appointmentDate#</strong> at <strong>#arguments.appointmentTime#</strong>.</p>
                    <p>You can check your appointment details using the link below:</p>
                    <p><a href='#local.link#'>Go to Aarogya website</a></p>
                    <p>Thank you for choosing us for your healthcare needs. If you have any questions or need further assistance, please feel free to reach out.</p>
                    <p>Regards,<br>Aarogya</p>
                </body>
                </html>
            ";

            // Send the acceptance email
            cfmail(
                to=arguments.patientEmail,
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

            local.response.success = true;
            local.response.message = "Notification Mail Sent Successfully";
           
        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

    // NOTE: Updated with Aarogya2.0
    remote struct function getUpcomingAppointment()
        returnformat="JSON" 
    {

        local.response = {
            data: structNew(),
            message: '',
            success: false
        };

        try {
            local.appointments = new model.appointment();

            // Check for authenticated user with the correct role
            if (!session.isLoggedIn || structKeyExists(session, "role") && session.role != "patient") {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            // Fetch appointment information based on status
            local.response.data = local.appointments.getUpcomingAppointment();
            local.response.message = "Successfully retrieved the appointment details"; 
            local.response.success = true;

        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

    // NOTE: Updated with Aarogya2.0
    remote struct function getDoctorInformation(
        string date,
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
            local.appointments = new model.appointment();

            // Check for authenticated user with the correct role
            if (!session.isLoggedIn || structKeyExists(session, "role") && session.role != "patient") {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            // Fetch appointment information based on status
            local.response.data = local.appointments.getDoctorInformation(arguments.date, arguments.category);
            local.response.message = "Successfully retrieved the doctor details"; 
            local.response.success = true;

        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

    remote struct function getAllAppointmentDetails(string status, string date)
        returnformat="JSON" 
    {

        local.response = {
            data: structNew(),
            message: '',
            success: false
        };

        try {
            local.appointments = new model.appointment();

            // Check for authenticated user with the correct role
            if (!session.isLoggedIn || structKeyExists(session, "role") && session.role != "patient") {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            // Fetch appointment information based on status
            local.response.data = local.appointments.getAllAppointmentDetails(arguments.status, arguments.date);
            local.response.message = "Successfully retrieved the appointment details"; 
            local.response.success = true;

        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

    remote struct function getAllPastAppointmentDetails(string status, string date)
        returnformat="JSON" 
    {

        local.response = {
            data: structNew(),
            message: '',
            success: false
        };

        try {
            local.appointments = new model.appointment();

            // Check for authenticated user with the correct role
            if (!session.isLoggedIn || structKeyExists(session, "role") && session.role != "patient") {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            // Fetch appointment information based on status
            local.response.data = local.appointments.getAllPastAppointmentDetails(arguments.status, arguments.date);
            local.response.message = "Successfully retrieved the appointment details"; 
            local.response.success = true;

        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

    remote struct function getNotificationData()
        returnformat="JSON" 
    {

        local.response = {
            data: structNew(),
            message: '',
            success: false
        };

        try {
            local.appointments = new model.appointment();

            // Check for authenticated user with the correct role
            if (!session.isLoggedIn || structKeyExists(session, "role") && session.role != "admin") {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            // Fetch appointment information based on status
            local.response.data = local.appointments.getNotificationData();
            local.response.message = "Successfully retrieved the notification details"; 
            local.response.success = true;

        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

}

