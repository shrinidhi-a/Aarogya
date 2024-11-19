component output="true"{

    // NOTE: Updated with Aarogya2.0
    remote struct function createPrescription(
        appointmentID,
        file,
        Note,
        PatientId,
        DoctorId,
        patientEmail
    ) 
    returnformat="JSON" {

        local.response = {
            message: '',
            success: false,
            sessionAvailable: true
        };

        try{
            local.prescription = new model.prescription();

            // Check for authenticated admin user
            if (!(session.isLoggedIn && structKeyExists(session, "role") && session.role == "admin")) {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            local.sessionVal = new model.session();
            if(!local.sessionVal.getSessionValidation()){
                local.response.sessionAvailable = false; 
                return local.response;
            }


            local.uploadDirectory = expandPath("../Uploads/Prescriptions/files_"&arguments.appointmentID&"");

            if (!directoryExists(local.uploadDirectory)) {
                directoryCreate(local.uploadDirectory);
            }

            local.uploadedFilePath = fileUpload(
                destination="#local.uploadDirectory#", 
                fileField="file",
                onConflict= "Overwrite"
            );

            local.filePath = "uploads/Prescriptions/files_"&arguments.appointmentID&"" & '/' & uploadedFilePath.serverFile;

            local.prescriptionStatus =  local.prescription.createNewPrescription(arguments.appointmentID, arguments.doctorID, arguments.patientID, local.filePath);

            local.prescriptionPDFStatus = local.prescription.createPrescriptionPDF(arguments.appointmentID, arguments.patientID, arguments.Note);
            
            if(local.prescriptionStatus == true && local.prescriptionPDFStatus == true){

                local.appointment = new model.appointment();

                if(local.appointment.setPrescriptionStatus(arguments.appointmentID)){
                    local.prescriptionLink = "http://localhost:8500/AarogyaMiniProject-2.0/index.cfm?action=profile"; 

                    local.emailBody = "
                    <html>
                    <body>
                        <p>Dear User,</p>
                        <p>We are pleased to inform you that your prescription for appointment " & arguments.appointmentID & " has been created.</p>
                        <p>You can find your prescription attached in this mail</p>
                        <br>
                        <p>If you have any questions or need further assistance, please do not hesitate to contact us.</p>
                        <p><a href='" & local.prescriptionLink & "'>Go to Aarogya website</a></p>
                        <p>Regards,<br>Aarogya</p>
                    </body>
                    </html>
                    ";

                    // Send the email with the prescription link
                    cfmail(
                        to=arguments.patientEmail,
                        from=application.MAIL_FROM,
                        subject="Aarogya: Your Appointment Prescription",
                        type="html",
                        charset="utf-8",
                        username=application.MAIL_USERNAME,
                        password=application.MAIL_PASSWORD,
                        server=application.MAIL_SERVER,
                        port=application.MAIL_PORT,
                        useSSL=application.MAIL_SSL
                    ) {
                        
                        cfmailparam(file = "#local.uploadDirectory#/#uploadedFilePath.serverFile#")
                        cfmailparam(file = "#local.uploadDirectory#/AutoGen/prescription.pdf")
                        writeOutput(local.emailBody)
                    }

                    local.response.message = "Prescription created successfully"; 
                    local.response.success = true; 
                }else{
                    local.response.message = "We couldn't create the prescription"; 
                }
            } else {
                local.response.message = "We couldn't create the prescription"; 
            }
                    
        } catch (any e) {
                local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

    remote struct function getPrescriptionLinks(
        string appointmentID
    )
    returnformat="JSON" {

        local.response = {
            message: '',
            success: false,
            sessionAvailable: true,
            path: structNew()
        };

        try{
            if (!(session.isLoggedIn && structKeyExists(session, "role") && session.role == "patient")) {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }
    
            local.sessionVal = new model.session();
            if(!local.sessionVal.getSessionValidation()){
                local.response.sessionAvailable = false; 
                return local.response;
            }
    
            local.appointment = new model.appointment();

            if (local.appointment.isPrescriptionAvailable(arguments.appointmentID)) {
                local.prescription = new model.prescription();
                local.filePath = local.prescription.getPaths(arguments.appointmentID);
                
                if (local.filePath.success) {
                    local.response.message = "Prescription available";
                    local.response.path = local.filePath.paths;
                    local.response.success = true;
                } else {
                    local.response.message = "Files unavailable on the server.";
                }
            } else {
                local.response.message = "Prescription not available. We will notify you once your prescription is available.";
            }
            return local.response;
        }
        catch (any e) {
            local.response.message = "Error: " & e.message;
            return local.response;  
        }
        
    }
}