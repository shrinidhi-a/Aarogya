component {

    public struct function getDoctorsInfo(
    string category
    ) {
        local.data = structNew();

        try {
            // Initialize SQL query and parameters
            local.sql = "SELECT DoctorID, FullName, Qualification, Email, Phone, imagePath FROM Doctors WHERE WorkStatus = :workstatus";
            local.params = { workstatus: application.DOCTOR_WORKSTATUS_AVAILABLE };

            // Conditionally add CategoryID filter if a category is provided
            if (len(trim(arguments.category))) {
                local.sql &= " AND CategoryID = :category";
                local.params["category"] = arguments.category;
            }

            // Execute query
            local.doctorInfo = queryExecute(local.sql, local.params);

            // Populate data structure if records are found
            if (local.doctorInfo.recordCount > 0) {
                for (local.row in local.doctorInfo) {
                    local.data[local.row.DoctorID] = {
                        FullName: local.row.FullName,
                        Qualification: local.row.Qualification,
                        Email: local.row.Email,
                        Phone: local.row.Phone,
                        ImagePath: local.row.imagePath
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

    public boolean function updateDoctorInfo(
        string id,
        string name,
        string email,
        string phone,
        string qualification,
        string filePath
    ) {
        try {
            // Initialize base query and parameters
            local.sql = "
                UPDATE Doctors
                SET FullName = :FullName,
                    Email = :Email,
                    Phone = :Phone,
                    Qualification = :Qualification";
            local.params = {
                FullName: arguments.name,
                Email: arguments.email,
                Phone: arguments.phone,
                Qualification: arguments.qualification,
                DoctorID: arguments.id
            };

            // Conditionally add the imagePath field if filePath has a value
            if (len(trim(arguments.filePath))) {
                local.sql &= ", imagePath = :imagePath";
                local.params["imagePath"] = arguments.filePath;
            }

            // Add WHERE clause
            local.sql &= " WHERE DoctorID = :DoctorID";

            // Execute the query
            queryExecute(local.sql, local.params);

            return true;
        } catch (any e) {
            // Log the error
            writeLog(file = "Aarogyalogs", text = "Error updating doctor info: " & e.message & "; Details: " & e.detail);
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
        string category,
        string filePath
    ) {

        try {
            queryExecute(
                "INSERT INTO Doctors(
                    CategoryID,
                    FullName,
                    Qualification,
                    Email,
                    Phone,
                    imagePath
                )
                VALUES(
                    :CategoryID,
                    :FullName,
                    :qualification,
                    :Email,
                    :Phone,
                    :imagePath
                )",
                {
                    CategoryID:arguments.category,
                    FullName:arguments.name,
                    qualification:arguments.qualification,
                    Email:arguments.email,
                    Phone:arguments.phone,
                    imagePath:arguments.filePath
                }
            );
            return true;
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error creating doctors: " & e.message);
            return false;
        }
    }
}