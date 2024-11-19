component {

    // NOTE: Updated with new Database.
    public struct function generateXLSForAppointment(
        string appontmentID
    ) {
        local.response = {
            success = false,
            path = "",
            message = ""
        }

        variables.excelFilePath = expandPath("../temp/AppointmentdataExcel.xlsx");
        if(FileExists(variables.excelFilePath)){
            FileDelete(variables.excelFilePath)
        }

        try {
            local.appointmentInfo = queryExecute(
                "SELECT a.AppointmentID, a.DateAndTime, a.CreatedAt, a.AppointmentStatus, " & 
                "d.FullName, d.Qualification, d.Email, d.Phone, " & 
                "c.CategoryName " & 
                "FROM Appointments a " & 
                "JOIN Doctors d ON a.DoctorID = d.DoctorID " & 
                "JOIN Categories c ON a.CategoryID = c.CategoryID " & 
                "WHERE a.AppointmentID = :appontmentID " &
                "ORDER BY a.DateAndTime",
                {
                    appontmentID: arguments.appontmentID
                }
            );
    
            if (local.appointmentInfo.recordCount > 0) {
                local.mySpreadsheet = SpreadsheetNew("Appointment Data", true);
    
                local.headers = [
                    "Appointment ID", "Date and Time", "Created At", 
                    "Appointment Status", "Doctor Full Name", 
                    "Doctor Specialization", "Doctor Email", 
                    "Doctor Phone", "Category Name"
                ];
    
                for (local.i = 1; local.i <= arrayLen(local.headers); local.i++) {
                    SpreadsheetSetCellValue(local.mySpreadsheet, headers[local.i], 1, local.i);
                }
    
                local.rowIndex = 2;
    
                for (local.row in local.appointmentInfo) {
                    SpreadsheetSetCellValue(local.mySpreadsheet, local.row.AppointmentID, local.rowIndex, 1);
                    SpreadsheetSetCellValue(local.mySpreadsheet, local.row.DateAndTime, local.rowIndex, 2);
                    SpreadsheetSetCellValue(local.mySpreadsheet, local.row.CreatedAt, local.rowIndex, 3);
                    SpreadsheetSetCellValue(local.mySpreadsheet, local.row.AppointmentStatus, local.rowIndex, 4);
                    SpreadsheetSetCellValue(local.mySpreadsheet, local.row.FullName, local.rowIndex, 5);
                    SpreadsheetSetCellValue(local.mySpreadsheet, local.row.Qualification, local.rowIndex, 6);
                    SpreadsheetSetCellValue(local.mySpreadsheet, local.row.Email, local.rowIndex, 7);
                    SpreadsheetSetCellValue(local.mySpreadsheet, local.row.Phone, local.rowIndex, 8);
                    SpreadsheetSetCellValue(local.mySpreadsheet, local.row.CategoryName, local.rowIndex, 9);
                    local.rowIndex++;
                }
    
                SpreadsheetWrite(local.mySpreadsheet, variables.excelFilePath, true);

                local.response.success = true;
                local.response.path = "/temp/AppointmentdataExcel.xlsx";
                local.response.message = "Excel file has been downloaded successfully";
                return local.response;
            } else {
                local.response.message = "You have no data to Export";
                return local.response;
            }
    
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error creating xls: " & e.message & "; Details: " & e.detail);
            return local.response; 
        }
    }

    // NOTE: Updated with new Database.
    public struct function generateAllXLS() {
        local.response = {
            success = false,
            path = "",
            message = ""
        }

        variables.excelFilePath = expandPath("../temp/allAppontmentsdataExcel.xlsx");
        if(FileExists(variables.excelFilePath)){
            FileDelete(variables.excelFilePath)
        }

        try {
            local.appointmentInfo = queryExecute(
                "SELECT a.AppointmentID, a.DateAndTime, a.CreatedAt, a.AppointmentStatus, " & 
                "d.FullName, d.Qualification, d.Email, d.Phone, " & 
                "c.CategoryName " & 
                "FROM Appointments a " & 
                "JOIN Doctors d ON a.DoctorID = d.DoctorID " & 
                "JOIN Categories c ON a.CategoryID = c.CategoryID " & 
                "ORDER BY a.DateAndTime"
            );
    
            
            if (local.appointmentInfo.recordCount > 0) {
                local.mySpreadsheet = SpreadsheetNew("Appointment Data", true);
    
                local.headers = [
                    "Appointment ID", "Date and Time", "Created At", 
                    "Appointment Status", "Doctor Full Name", 
                    "Doctor Specialization", "Doctor Email", 
                    "Doctor Phone", "Category Name"
                ];
    
                for (local.i = 1; local.i <= arrayLen(local.headers); local.i++) {
                    SpreadsheetSetCellValue(local.mySpreadsheet, headers[local.i], 1, local.i);
                }
    
                local.rowIndex = 2;
    
                for (local.row in local.appointmentInfo) {
                    SpreadsheetSetCellValue(local.mySpreadsheet, local.row.AppointmentID, local.rowIndex, 1);
                    SpreadsheetSetCellValue(local.mySpreadsheet, local.row.DateAndTime, local.rowIndex, 2);
                    SpreadsheetSetCellValue(local.mySpreadsheet, local.row.CreatedAt, local.rowIndex, 3);
                    SpreadsheetSetCellValue(local.mySpreadsheet, local.row.AppointmentStatus, local.rowIndex, 4);
                    SpreadsheetSetCellValue(local.mySpreadsheet, local.row.FullName, local.rowIndex, 5);
                    SpreadsheetSetCellValue(local.mySpreadsheet, local.row.Qualification, local.rowIndex, 6);
                    SpreadsheetSetCellValue(local.mySpreadsheet, local.row.Email, local.rowIndex, 7);
                    SpreadsheetSetCellValue(local.mySpreadsheet, local.row.Phone, local.rowIndex, 8);
                    SpreadsheetSetCellValue(local.mySpreadsheet, local.row.CategoryName, local.rowIndex, 9);
                    local.rowIndex++;
                }
    
                SpreadsheetWrite(local.mySpreadsheet, variables.excelFilePath, true);

                local.response.success = true;
                local.response.path = "/temp/allAppontmentsdataExcel.xlsx";
                local.response.message = "Excel file has been downloaded successfully";
                return local.response;
            } else {
                local.response.message = "You have no data to Export";
                return local.response;
            }
    
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error creating xls: " & e.message & "; Details: " & e.detail);
            return local.response; 
        }
    }

    // NOTE: Updated with new Database.
    //TODO: remove
    public struct function getPrescription(
        string key
    ) 
    {
        local.response = {
            success = false,
            path = "",
            message = ""
        }

        variables.pdfFilePath = expandPath("../temp/prescription.pdf");

        if(FileExists(variables.pdfFilePath)){
            FileDelete(variables.pdfFilePath)
        }

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
                    pr.GenerationDate,
                    pr.Details AS PrescriptionDetails
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
                    appointmentID: arguments.key
                }
            );
    
            if (local.prescriptionInfo.recordCount > 0 AND local.prescriptionInfo.PrescriptionDetails NEQ "") {
                cfdocument (format="pdf", filename=variables.pdfFilePath, overwrite=true){
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
                        <p>#local.prescriptionInfo.PrescriptionDetails#</p>
                    </div>

                    <div class='section'>
                        <p><span class='label'>Signature of Doctor:</span> _____#local.prescriptionInfo.DoctorName#_______</p>
                        <p><span class='label'>Date:</span> _____#dateFormat(now())#______</p>
                    </div>
                    <p>Document contains auto generated sign</p>
                    "

                    )
                }

                local.response.success = true;
                local.response.path = "/temp/prescription.pdf";
                return local.response;
            } else {
                local.response.message = "Prescription not generated. We will inform you via email once it is updated."
                return local.response;
            }
    
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error creating pdf: " & e.message & "; Details: " & e.detail);
            return local.response; 
        }
    }
    
    public struct function generateXLS() {
        local.response = {
            success = false,
            path = "",
            message = ""
        }

        try {
            local.appointmentInfo = queryExecute(
                "SELECT a.AppointmentID, a.DateAndTime, a.CreatedAt, a.AppointmentStatus, " & 
                "d.FullName, d.Qualification, d.Email, d.Phone, " & 
                "c.CategoryName " & 
                "FROM Appointments a " & 
                "JOIN Doctors d ON a.DoctorID = d.DoctorID " & 
                "JOIN Categories c ON a.CategoryID = c.CategoryID " & 
                "WHERE a.PatientID = :patientId " &
                "ORDER BY a.DateAndTime",
                {
                    patientId: session.UserID
                }
            );
    
            variables.excelFilePath = expandPath("../temp/dataExcel.xlsx");
            
            if (local.appointmentInfo.recordCount > 0) {
                local.mySpreadsheet = SpreadsheetNew("Appointment Data", true);
    
                local.headers = [
                    "Appointment ID", "Date and Time", "Created At", 
                    "Appointment Status", "Doctor Full Name", 
                    "Doctor Qualification", "Doctor Email", 
                    "Doctor Phone", "Category Name"
                ];
    
                for (local.i = 1; local.i <= arrayLen(local.headers); local.i++) {
                    SpreadsheetSetCellValue(local.mySpreadsheet, headers[local.i], 1, local.i);
                }
    
                local.rowIndex = 2;
    
                for (local.row in local.appointmentInfo) {
                    SpreadsheetSetCellValue(local.mySpreadsheet, local.row.AppointmentID, local.rowIndex, 1);
                    SpreadsheetSetCellValue(local.mySpreadsheet, local.row.DateAndTime, local.rowIndex, 2);
                    SpreadsheetSetCellValue(local.mySpreadsheet, local.row.CreatedAt, local.rowIndex, 3);
                    SpreadsheetSetCellValue(local.mySpreadsheet, local.row.AppointmentStatus, local.rowIndex, 4);
                    SpreadsheetSetCellValue(local.mySpreadsheet, local.row.FullName, local.rowIndex, 5);
                    SpreadsheetSetCellValue(local.mySpreadsheet, local.row.Qualification, local.rowIndex, 6);
                    SpreadsheetSetCellValue(local.mySpreadsheet, local.row.Email, local.rowIndex, 7);
                    SpreadsheetSetCellValue(local.mySpreadsheet, local.row.Phone, local.rowIndex, 8);
                    SpreadsheetSetCellValue(local.mySpreadsheet, local.row.CategoryName, local.rowIndex, 9);
                    local.rowIndex++;
                }
    
                SpreadsheetWrite(local.mySpreadsheet, variables.excelFilePath, true);

                local.response.success = true;
                local.response.path = "/temp/dataExcel.xlsx";
                local.response.message = "Excel file has been downloaded successfully";
                return local.response;
            } else {
                local.response.message = "You have no data to Export";
                return local.response;
            }
    
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error creating xls: " & e.message & "; Details: " & e.detail);
            return local.response; 
        }
    }
}