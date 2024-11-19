component {

    // NOTE: Updated with new Database.
    public boolean function createNewPrescription(
        string appointmentID,
        string doctorID,
        string patientID,
        string filePath
    ) {
        try {
            local.dateObject = parseDateTime(now());
            local.formattedDate = dateFormat(local.dateObject, "yyyy-mm-dd");

            local.existingPrescription = queryExecute(
                "SELECT * FROM Prescriptions 
                WHERE AppointmentID = :AppointmentID",
                {
                    AppointmentID: arguments.appointmentID
                }
            );

            if (local.existingPrescription.recordCount > 0) {
                queryExecute(
                    "UPDATE Prescriptions 
                    SET PrescriptionPath = :filePath, 
                        GenerationDate = :GenerationDate 
                    WHERE AppointmentID = :AppointmentID",
                    {
                        filePath: arguments.filePath,
                        GenerationDate: local.formattedDate,
                        AppointmentID: arguments.appointmentID
                    }
                );
            } else {
                queryExecute(
                    "INSERT INTO Prescriptions(
                        PatientID,
                        DoctorID,
                        GenerationDate,
                        PrescriptionPath,
                        AppointmentID
                    )
                    VALUES(
                        :PatientID,
                        :DoctorID,
                        :GenerationDate,
                        :PrescriptionPath,
                        :AppointmentID
                    )",
                    {
                        PatientID: arguments.patientID,
                        DoctorID: arguments.doctorID,
                        GenerationDate: local.formattedDate,
                        PrescriptionPath: arguments.filePath,
                        AppointmentID: arguments.appointmentID
                    }
                );
            }

            return true;
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error creating or updating prescription: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }

    public boolean function createPrescriptionPDF(
        string appointmentID,
        string patientID,
        string Note
    ){
        variables.pdfFilePath = expandPath("../Uploads/Prescriptions/files_"&arguments.appointmentID&"/AutoGen");
        
        if (!directoryExists(variables.pdfFilePath)) {
            directoryCreate(variables.pdfFilePath);
        }

        local.filePath = ""& variables.pdfFilePath &"/prescription.pdf";

        try {
            local.prescriptionInfo = queryExecute(
                "SELECT 
                    a.AppointmentID,
                    a.DateAndTime AS AppointmentDateTime,
                    a.AppointmentStatus,
                    p.UserID AS PatientName,
                    p.FullName AS PatientName,
                    p.DOB AS PatientDOB,
                    p.Email AS PatientEmail,
                    p.Phone AS PatientPhone,
                    d.DoctorID,
                    d.FullName AS DoctorName,
                    d.Qualification AS DoctorQualification,
                    d.Email AS DoctorEmail,
                    d.Phone AS DoctorPhone,
                    c.CategoryID,
                    c.CategoryName,
                    pr.PrescriptionID,
                    pr.GenerationDate
                FROM 
                    Appointments a
                JOIN 
                    UserDetails p ON a.PatientID = p.UserID
                JOIN 
                    Doctors d ON a.DoctorID = d.DoctorID
                JOIN 
                    Categories c ON a.CategoryID = c.CategoryID
                LEFT JOIN 
                    Prescriptions pr ON a.AppointmentID = pr.AppointmentID
                WHERE 
                    a.AppointmentID = :appointmentID;",
                {
                    appointmentID: arguments.appointmentID
                }
            );        
            if (local.prescriptionInfo.recordCount > 0) {
                cfdocument (format="pdf", filename=local.filePath, overwrite=true){
                    writeOutput(
                    "
                    <style>
                        body {
                            font-family: Arial, sans-serif;
                            margin: 20px;
                        }
                        h1 {
                            text-align: center;
                        }
                        .section {
                            margin-bottom: 20px;
                        }
                        .label {
                            font-weight: bold;
                        }
                    </style>
                    <h1>Prescription</h1>    
                    <div class='section'>
                        <h3>Patient Information</h3>
                        <p><span class='label'>Name:</span> #local.prescriptionInfo.PatientName#</p>
                        <p><span class='label'>Date of Birth:</span> #local.prescriptionInfo.PatientDOB#</p>
                        <p><span class='label'>Email:</span> #local.prescriptionInfo.PatientEmail#</p>
                        <p><span class='label'>Phone:</span> #local.prescriptionInfo.PatientPhone#</p>
                    </div>    
                    <div class='section'>
                        <h3>Doctor Information</h3>
                        <p><span class='label'>Name:</span> #local.prescriptionInfo.DoctorName#</p>
                        <p><span class='label'>Specialization:</span> #local.prescriptionInfo.DoctorQualification#</p>
                        <p><span class='label'>Email:</span> #local.prescriptionInfo.DoctorEmail#</p>
                        <p><span class='label'>Phone:</span> #local.prescriptionInfo.DoctorPhone#</p>
                    </div>    
                    <div class='section'>
                        <h3>Prescription Details</h3>
                        <p><span class='label'>Generation Date:</span> #local.prescriptionInfo.GenerationDate#</p>
                        <p><span class='label'>Details:</span></p>
                        <p>#arguments.Note#</p>
                    </div>    
                    <div class='section'>
                        <p><span class='label'>Signature of Doctor:</span> _____#local.prescriptionInfo.DoctorName#_______</p>
                        <p><span class='label'>Date:</span> _____#dateFormat(now())#______</p>
                    </div>
                    <p>Document contains auto generated sign</p>
                    "    
                    )
                }    
                return true;
            } else {
                return false;
            }        
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error creating pdf: " & e.message & "; Details: " & e.detail);
            return local.response; 
        }
    }

    public struct function getPaths(
        string appointmentID
    ) {

        local.response = {
            success: false,
            paths: structNew()
        };

        try {
            local.getUploadedPath = queryExecute(
                "SELECT PrescriptionPath FROM Prescriptions WHERE AppointmentID = :AppointmentID",
                {
                    AppointmentID: arguments.appointmentID // Corrected this line
                }
            );

            if (local.getUploadedPath.recordCount > 0) {
                local.response.paths = {
                    "uploadedPrescription": local.getUploadedPath.PrescriptionPath[1], // Accessing the first row
                    "generatedPrescription": "uploads/Prescriptions/files_#arguments.appointmentID#/AutoGen/prescription.pdf"
                };
                local.response.success = true;
            }
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error retrieving prescription paths: " & e.message & "; Details: " & e.detail);
        }

        return local.response; // Always return the response at the end
    }
}