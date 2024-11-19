component {

    // NOTE: Updated with new Database.
    public struct function getDoctorsInfo(
        string category
    ) {
        local.data = structNew();

        try {
            local.doctorInfo = queryExecute(
            "SELECT DoctorID, FullName, Qualification, Email, Phone FROM Doctors WHERE CategoryID = :category AND WorkStatus = :workstatus",
            {category: arguments.category, workstatus: application.DOCTOR_WORKSTATUS_AVAILABLE}
        );

        if (local.doctorInfo.recordCount > 0) {
            for (local.row in local.doctorInfo) {
                local.data[local.row.DoctorID] = {
                    FullName: local.row.FullName,
                    Qualification: local.row.Qualification,
                    Email: local.row.Email,
                    Phone: local.row.Phone
                };
            }
        }
        return local.data;
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error fetching doctors: " & e.message);
            return structNew();
        }
    }

    // NOTE: Updated with new Database.
    public boolean function checkEmailExistsForOthers(
        string emailID,
        string excludeId
        )
    {
        try {
            local.emailCountResult = queryExecute(
                "SELECT COUNT(*) AS emailCount FROM Doctors WHERE Email = :email AND DoctorID != :excludeId AND WorkStatus != :workstatus;",
                {
                    email: arguments.emailID,
                    excludeId: arguments.excludeId,
                    workstatus: application.DOCTOR_WORKSTATUS_UNAVAILABLE
                }
            );

            if (local.emailCountResult.recordCount > 0 && local.emailCountResult.emailCount[1] > 0) {
                return true;
            } else {
                return false;
            }
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error checking email: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }

    // NOTE: Updated with new Database.
    public boolean function updateDoctorInfo(
        string key,
        string name,
        string email,
        string phone,
        string qualification
    ) 
    {
        try {
    
            queryExecute(
                "UPDATE Doctors
                SET FullName = :FullName,
                Email = :Email,
                Phone = :Phone,
                Qualification = :Qualification
                WHERE DoctorID = :DoctorID",
                {
                    FullName: arguments.name,
                    Email: arguments.email,
                    Phone: arguments.phone,
                    Qualification: arguments.qualification,
                    DoctorID: arguments.key
                }
            );
    
            return true;
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error updating token: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }

    // NOTE: Updated with new Database.
    public boolean function removeDoctorInfo(
        string doctorId
    ) 
    {
        try {
            queryExecute(
                "UPDATE Doctors
                SET WorkStatus = :workstatus
                WHERE DoctorID = :DoctorID",
                {
                    workstatus: application.DOCTOR_WORKSTATUS_UNAVAILABLE,
                    DoctorID: arguments.doctorId
                }
            );

            return true;
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error deleting doctor info: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }

    // NOTE: Updated with new Database.
    public boolean function checkEmailExists(
        string emailID
    )
    {
        try{
            local.emailCountResult = queryExecute(
                "SELECT COUNT(*) AS emailCount FROM Doctors WHERE Email = :email AND WorkStatus != :workstatus;",
                {email: arguments.emailID, workstatus: application.DOCTOR_WORKSTATUS_UNAVAILABLE}
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
    public boolean function createNewDoctor(
        string name,
        string email,
        string phone,
        string qualification,
        string category
    ) {

        try {
            queryExecute(
                "INSERT INTO Doctors(
                    CategoryID,
                    FullName,
                    Qualification,
                    Email,
                    Phone
                )
                VALUES(
                    :CategoryID,
                    :FullName,
                    :qualification,
                    :Email,
                    :Phone
                )",
                {
                    CategoryID:arguments.category,
                    FullName:arguments.name,
                    qualification:arguments.qualification,
                    Email:arguments.email,
                    Phone:arguments.phone
                }
            );
            return true;
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error creating doctors: " & e.message);
            return false;
        }
    }
}