component {

    // NOTE: Updated with new Database.
    public struct function getAppointmentDetailsForAdmin(string status) {
        local.data = structNew();
    
        try {
            local.appointmentInfo = queryExecute(
                "SELECT a.AppointmentID, a.DateAndTime, a.CreatedAt, a.AppointmentStatus, a.StartTime, " & 
                "d.DoctorID AS DoctorID, d.FullName AS DoctorFullName, d.Qualification, d.Email AS DoctorEmail, d.Phone AS DoctorPhone, " & 
                "c.CategoryName, " & 
                "u.UserID AS UserID, u.FullName AS UserFullName, u.Email AS UserEmail, u.Phone AS UserPhone " & 
                "FROM Appointments a " & 
                "JOIN Doctors d ON a.DoctorID = d.DoctorID " & 
                "JOIN Categories c ON a.CategoryID = c.CategoryID " & 
                "JOIN UserDetails u ON a.PatientID = u.UserID " & 
                "WHERE LOWER(a.AppointmentStatus) = LOWER(:status) ",
                {
                    status: arguments.status
                }
            );
            
            if (local.appointmentInfo.recordCount > 0) {
                for (local.row in local.appointmentInfo) {

                    local.formattedDate = dateFormat(local.row.DateAndTime, "yyyy-MM-dd");
                    local.timeOnly = timeFormat(local.row.StartTime, "hh:mm tt");

                    local.data[local.row.AppointmentID] = {
                        Date: local.formattedDate,
                        Time: local.timeOnly,
                        CreatedAt: local.row.CreatedAt,
                        AppointmentStatus: local.row.AppointmentStatus,
                        Doctor: {
                            ID: local.row.DoctorID,
                            FullName: local.row.DoctorFullName,
                            Qualification: local.row.Qualification,
                            Email: local.row.DoctorEmail,
                            Phone: local.row.DoctorPhone
                        },
                        User: {
                            ID: local.row.UserID,
                            FullName: local.row.UserFullName,
                            Email: local.row.UserEmail,
                            Phone: local.row.UserPhone
                        },
                        CategoryName: local.row.CategoryName
                    };
                }
            }
            return local.data;
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error fetching all appointments: " & e.message & "; Details: " & e.detail);
            return local.data;
        }
    }

    // NOTE: Updated with new Database.
    public boolean function completeAppointment(
        string key
    ) 
    {
        try {
    
            queryExecute(
                "UPDATE Appointments
                SET AppointmentStatus = :status
                WHERE AppointmentID = :key",
                {
                    status: application.APPOINTMENT_STATUS_COMPLETED,
                    key: arguments.key
                }
            );
            return true;
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error completing appointment: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }

    public boolean function setPrescriptionStatus(
        string key
    ) 
    {
        try {
    
            queryExecute(
                "UPDATE Appointments
                SET PrescriptionAvailable = :status
                WHERE AppointmentID = :key",
                {
                    status: 1,
                    key: arguments.key
                }
            );
            return true;
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error completing appointment: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }

    public boolean function isPrescriptionAvailable(
        string key
    ) 
    {
        try {
            local.prescriptionInfo = queryExecute(
                "SELECT PrescriptionAvailable FROM Appointments WHERE AppointmentID = :AppointmentID",
                {
                    AppointmentID: arguments.key
                }
            );

            // Check if any records were returned
            if (local.prescriptionInfo.recordCount > 0) {
                // Access the first row and check the value
                if (local.prescriptionInfo.PrescriptionAvailable[1] == 1) {
                    return true;
                } else {
                    return false;
                }
            } else {
                // No records found
                return false;
            }
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error checking prescription availability: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }


    // NOTE: Updated with new Database.
    public boolean function cancelAppointment(
        string key
    ) 
    {
        try {
    
            queryExecute(
                "UPDATE Appointments
                SET AppointmentStatus = :status
                WHERE AppointmentID = :key",
                {
                    status: Application.APPOINTMENT_STATUS_CANCELLED,
                    key: arguments.key
                }
            );
            return true;
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error cancelling appointment: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }

    // NOTE: Updated with new Database.
    public boolean function acceptAppointment(
        string key
    ) 
    {
        try {
    
            queryExecute(
                "UPDATE Appointments
                SET AppointmentStatus = :status
                WHERE AppointmentID = :key",
                {
                    status: application.APPOINTMENT_STATUS_CONFIRMED ,
                    key: arguments.key
                }
            );
            return true;
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error accepting appointment: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }

    // NOTE: Updated with new Database.
    public boolean function noshowAppointment(
        string key
    ) 
    {
        try {
    
            queryExecute(
                "UPDATE Appointments
                SET AppointmentStatus = :status
                WHERE AppointmentID = :key",
                {
                    status: application.APPOINTMENT_STATUS_NOSHOW ,
                    key: arguments.key
                }
            );
            return true;
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error marking appointment no show: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }

    // NOTE: Updated with new Database.
    public struct function getAppointmentInfo(string status) {
        local.data = structNew();
    
        try {
            local.appointmentInfo = queryExecute(
                "SELECT a.AppointmentID, a.DateAndTime, a.CreatedAt, a.AppointmentStatus, a.StartTime," & 
                "d.FullName, d.Qualification, d.Email, d.Phone, d.DoctorID, " & 
                "c.CategoryName " & 
                "FROM Appointments a " & 
                "JOIN Doctors d ON a.DoctorID = d.DoctorID " & 
                "JOIN Categories c ON a.CategoryID = c.CategoryID " & 
                "WHERE a.PatientID = :patientId AND LOWER(a.AppointmentStatus) = LOWER(:status) ",
                {
                    patientId: session.UserID,
                    status: arguments.status
                }
            );

            
    
            if (local.appointmentInfo.recordCount > 0) {
                for (local.row in local.appointmentInfo) {

                    local.formattedDate = dateFormat(local.row.DateAndTime, "yyyy-MM-dd");
                    local.timeOnly = timeFormat(local.row.StartTime, "hh:mm tt");

                    local.data[local.row.AppointmentID] = {
                        Date: local.formattedDate,
                        Time: local.timeOnly,
                        CreatedAt: local.row.CreatedAt,
                        AppointmentStatus: local.row.AppointmentStatus,
                        Doctor: {
                            FullName: local.row.FullName,
                            DoctorID: local.row.DoctorID,
                            Qualification: local.row.Qualification,
                            Email: local.row.Email,
                            Phone: local.row.Phone
                        },
                        CategoryName: local.row.CategoryName
                    };
                }
            }
            return local.data;
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error fetching appointments: " & e.message & "; Details: " & e.detail);
            return local.data;
        }
    }
    
    // NOTE: Updated with new Database.
    public boolean function createNewAppointment(
        string category,
        string doctor,
        string dateAndTime,
        string startTime
    ) {
        local.timeIn24 = {
            "1" : "09:00:00",
            "2" : "10:00:00",
            "3" : "11:00:00",
            "4" : "12:00:00",
            "5" : "14:00:00",
            "6" : "15:00:00",
            "7" : "16:00:00",
            "8" : "17:00:00",
            "9" : "18:00:00",
            "10" : "19:00:00"
        };

        try {
            local.dateObject = parseDateTime(arguments.dateAndTime);
            local.formattedDate = dateFormat(local.dateObject, "yyyy-MM-dd"); // Corrected month format

            queryExecute(
                "INSERT INTO Appointments (
                    PatientID,
                    DoctorID,
                    DateAndTime,
                    AppointmentStatus,
                    CategoryID,
                    StartTime
                ) VALUES (
                    :PatientID,
                    :DoctorID,
                    :DateAndTime,
                    :AppointmentStatus,
                    :CategoryID,
                    :StartTime
                )",
                {
                    PatientID : session.UserID,
                    DoctorID : arguments.doctor,
                    DateAndTime : local.formattedDate, // Ensure this is in the correct format
                    AppointmentStatus : application.APPOINTMENT_STATUS_PENDING,
                    CategoryID : arguments.category,
                    StartTime : local.timeIn24[arguments.startTime]
                }
            );

            return true; // Appointment created successfully
        } catch (any e) {
            writeLog(
                file="Aarogyalogs", 
                text="Error creating appointment: " & e.message & "; Details: " & e.detail
            );
            return false; // Appointment creation failed
        }
    }


    // NOTE: Updated with new Database.
    public boolean function rescheduleAppointment(
        string key,
        string updatedScheduleDate,
        string updatedScheduleTime
    ) 
    {
        local.timeIn24 = {
            "1" : "09:00:00",
            "2" : "10:00:00",
            "3" : "11:00:00",
            "4" : "12:00:00",
            "5" : "14:00:00",
            "6" : "15:00:00",
            "7" : "16:00:00",
            "8" : "17:00:00",
            "9" : "18:00:00",
            "10" : "19:00:00"
        };

        try {
            // Convert the datetime string to a valid date object
            // local.dateObject = parseDateTime(arguments.updatedSchedule);
            // Format it for SQL
            // local.formattedDate = dateFormat(local.dateObject, "yyyy-mm-dd") & " " & timeFormat(local.dateObject, "HH:mm:ss");

            // Update the appointment
            queryExecute(
                "UPDATE Appointments
                SET DateAndTime = :updatedScheduleDate,
                    StartTime = :StartTime,
                    AppointmentStatus = :status
                WHERE AppointmentID = :key",
                {
                    updatedScheduleDate: arguments.updatedScheduleDate,
                    StartTime : local.timeIn24[arguments.updatedScheduleTime],
                    key: arguments.key,
                    status: application.APPOINTMENT_STATUS_PENDING
                }
            );
            return true;
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error updating appointment: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }


    public struct function getBookedAppointments(
        string selectedDate,
        string selectedDoctor
    ) 
    {
        local.response = {
            data: structNew(),
            success: false
        };

        try {
            // Initialize tracker with appointment data

            local.tracker = {
                appointments: [
                    { id: "1", time: "09:00 AM", isEnabled: false },
                    { id: "2", time: "10:00 AM", isEnabled: false },
                    { id: "3", time: "11:00 AM", isEnabled: false },
                    { id: "4", time: "12:00 PM", isEnabled: false },
                    { id: "5", time: "02:00 PM", isEnabled: false },
                    { id: "6", time: "03:00 PM", isEnabled: false },
                    { id: "7", time: "04:00 PM", isEnabled: false },
                    { id: "8", time: "05:00 PM", isEnabled: false },
                    { id: "9", time: "06:00 PM", isEnabled: false },
                    { id: "10", time: "07:00 PM", isEnabled: false }
                ]
            };

            // Execute query to retrieve booked appointments
            local.appointments = queryExecute(
                "SELECT StartTime, AppointmentID FROM Appointments WHERE DateAndTime = :selectedDate AND AppointmentStatus != :cancel AND DoctorID = :DoctorID",
                {
                    selectedDate: arguments.selectedDate,
                    cancel: application.APPOINTMENT_STATUS_CANCELLED,
                    DoctorID: arguments.selectedDoctor
                }
            );

            // Check if there are any booked appointments
            if (local.appointments.recordCount > 0) {
                for (local.row in local.appointments) {
                    local.timeOnly = timeFormat(local.row.StartTime, "hh:mm tt");
                    
                    // Iterate through the tracker to update availability
                    for (local.appointment in local.tracker.appointments) {
                        if (local.appointment.time == local.timeOnly) {
                            local.appointment.isEnabled = true;
                        }
                    }
                }
            }

            // Set the response data and success flag
            local.response.data = local.tracker;
            local.response.success = true;

            return local.response;
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error: " & e.message & "; Details: " & e.detail);
            return local.response;
        }
    }

    // NOTE: Updated with new Database.
    public struct function getUpcomingAppointment() {
        local.data = structNew();
    
        try {
            local.appointmentInfo = queryExecute(
                "SELECT TOP 1 a.AppointmentID, a.DateAndTime, a.CreatedAt, a.AppointmentStatus, a.StartTime, " &  
                "d.FullName, d.Qualification, d.Email, d.Phone, d.DoctorID, d.imagePath, " & 
                "c.CategoryName " & 
                "FROM Appointments a " & 
                "JOIN Doctors d ON a.DoctorID = d.DoctorID " & 
                "JOIN Categories c ON a.CategoryID = c.CategoryID " & 
                "WHERE a.PatientID = :patientId " & 
                "AND LOWER(a.AppointmentStatus) = LOWER(:status) " & 
                "AND (a.DateAndTime > :today OR (a.DateAndTime = :today AND a.StartTime > :currentTime)) " & 
                "ORDER BY a.DateAndTime ASC, a.StartTime ASC",
                {
                    patientId: session.UserID,
                    status: application.APPOINTMENT_STATUS_CONFIRMED,
                    today: dateFormat(now(), "yyyy-MM-dd"),
                    currentTime: timeFormat(now(), "HH:mm:ss")
                }
            );
    
            // Check if we have at least one record
            if (local.appointmentInfo.recordCount > 0) {
                // Move to the first row
                local.row = local.appointmentInfo;
    
                local.formattedDate = dateFormat(local.row.DateAndTime[1], "yyyy-MM-dd");
                local.timeOnly = timeFormat(local.row.StartTime[1], "hh:mm tt");
    
                // Assign the data to the structure
                local.data = {
                    DataAvailable: true,
                    AppointmentID: local.row.AppointmentID[1],
                    Date: local.formattedDate,
                    Time: local.timeOnly,
                    CreatedAt: local.row.CreatedAt[1],
                    AppointmentStatus: local.row.AppointmentStatus[1],
                    IMAGEPATH: local.row.imagePath[1],
                    Doctor: {
                        FullName: local.row.FullName[1],
                        DoctorID: local.row.DoctorID[1],
                        Qualification: local.row.Qualification[1],
                        Email: local.row.Email[1],
                        Phone: local.row.Phone[1]
                    },
                    CategoryName: local.row.CategoryName[1]
                };
            }else{
                local.data = {
                    DataAvailable: false
                }
            }
    
            return local.data;
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error fetching next upcoming appointment: " & e.message & "; Details: " & e.detail);
            return local.data;
        }
    }
    
    
    // NOTE: Updated with new Database.
    public struct function getDoctorInformation(
        string date,
        string category
    ) {
        local.data = structNew();
    
        try {

            local.sqlDoctorInfo = "SELECT DoctorID, CategoryID, FullName, Qualification, Email, Phone, imagePath FROM Doctors WHERE WorkStatus = :workstatus";
            local.paramsDoctorInfo = { workstatus: application.DOCTOR_WORKSTATUS_AVAILABLE };

            if (arguments.category != "") {
                local.sqlDoctorInfo &= " AND CategoryID = :category";
                local.paramsDoctorInfo.category = arguments.category;
            }

            // Execute the query
            local.doctorInfo = queryExecute(local.sqlDoctorInfo, local.paramsDoctorInfo);
    
            if (local.doctorInfo.recordCount > 0) {
                for (local.row in local.doctorInfo) {

                    local.tracker = {
                        appointments: [
                            { id: "1", time: "09:00 AM", isEnabled: false },
                            { id: "2", time: "10:00 AM", isEnabled: false },
                            { id: "3", time: "11:00 AM", isEnabled: false },
                            { id: "4", time: "12:00 PM", isEnabled: false },
                            { id: "5", time: "02:00 PM", isEnabled: false },
                            { id: "6", time: "03:00 PM", isEnabled: false },
                            { id: "7", time: "04:00 PM", isEnabled: false },
                            { id: "8", time: "05:00 PM", isEnabled: false },
                            { id: "9", time: "06:00 PM", isEnabled: false },
                            { id: "10", time: "07:00 PM", isEnabled: false }
                        ]
                    };

                    local.sqlAppointmentInfo = "SELECT StartTime, AppointmentID FROM Appointments WHERE AppointmentStatus != :cancel AND DoctorID = :DoctorID";
                    local.paramsAppointmentInfo = { 
                        cancel: application.APPOINTMENT_STATUS_CANCELLED,
                        DoctorID: local.row.DoctorID 
                    };

                    // Determine the selected date (either from arguments or today's date)
                    local.dateToSend = arguments.date != "" ? arguments.date : DateFormat(Now(), "yyyy-mm-dd");

                    // Add date condition to the query
                    local.sqlAppointmentInfo &= " AND CAST(DateAndTime AS DATE) = :selectedDate";
                    local.paramsAppointmentInfo.selectedDate = local.dateToSend;

                    // Execute the query
                    local.appointmentInfo = queryExecute(local.sqlAppointmentInfo, local.paramsAppointmentInfo);

                    if (local.appointmentInfo.recordCount > 0) {
                        for (local.appoint in local.appointmentInfo) {
                            local.timeOnly = timeFormat(local.appoint.StartTime, "hh:mm tt");
                            for (local.appointment in local.tracker.appointments) {
                                if (local.appointment.time == local.timeOnly) {
                                    local.appointment.isEnabled = true;
                                }
                            }
                        }
                    }

                    local.currentTime = now()
                    local.currentDate = DateFormat(Now(), "yyyy-mm-dd");
                    local.timeOnlyNow = timeFormat(local.currentTime, "hh:mm tt");
                    if(local.currentDate == local.dateToSend){
                        for (local.appointment in local.tracker.appointments) {
                            if(local.appointment.time < local.timeOnlyNow){
                                local.appointment.isEnabled = true;
                            }
                        }
                    }

                    local.availabilityInfo = queryExecute(
                        "SELECT StartTime, EndTime FROM DoctorUnavailability WHERE UnavailableDate = :UnavailableDate AND DoctorId = :DoctorId",
                        {
                            DoctorId: local.row.DoctorID,
                            UnavailableDate: local.dateToSend
                        }
                    );

                    if (local.availabilityInfo.recordCount > 0) {
                        // writeLog(file="Aarogyalogs", text=local.row.DoctorID);
                        // local.Category = local.categoryInfo.CategoryName[1]
                        for (local.unavailability in local.availabilityInfo) {
                            local.startTimeUnavailability = timeFormat(local.unavailability.StartTime, "hh:mm tt");
                            local.endTimeUnavailability = timeFormat(local.unavailability.EndTime, "hh:mm tt");
                            
                            for (local.appointment in local.tracker.appointments) {
                                // writeLog(file="Aarogyalogs", text="inside");
                                if (DateCompare(local.appointment.time, local.startTimeUnavailability) >= 0 && DateCompare(local.appointment.time, local.endTimeUnavailability) <= 0) {
                                    // writeLog(file="Aarogyalogs", text="");
                                    local.appointment.isEnabled = true
                                }
                            }
                        }
                    }
                    
                    local.categoryInfo = queryExecute(
                        "SELECT CategoryName FROM Categories WHERE CategoryID = :CategoryID",
                        {
                            CategoryID: local.row.CategoryID
                        }
                    );
            
                    if (local.categoryInfo.recordCount > 0) {
                        local.Category = local.categoryInfo.CategoryName[1]
                    }

                    local.data[local.row.DoctorID] = {
                        FullName: local.row.FullName,
                        DoctorID: local.row.DoctorID,
                        Qualification: local.row.Qualification,
                        ImagePath: local.row.imagePath,
                        Email: local.row.Email,
                        Phone: local.row.Phone,
                        Date: local.dateToSend,
                        Category:local.Category,
                        CategotyID: local.row.CategoryID,
                        AppointmentDetails: local.tracker
                    };
                }
            }
    
            return local.data;
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error fetching doctor info and appointment: " & e.message & "; Details: " & e.detail);
            return local.data;
        }
    }

    // NOTE: Updated with new Database.
    public struct function getAllAppointmentDetails(string status, string date) {
        local.data = structNew();
        
        try {
            // Base query string
            local.queryStr = "
                SELECT 
                    a.AppointmentID, a.DateAndTime, a.CreatedAt, a.AppointmentStatus, a.StartTime, 
                    d.FullName, d.Qualification, d.Email, d.Phone, d.DoctorID, d.imagePath, 
                    c.CategoryName 
                FROM 
                    Appointments a 
                JOIN 
                    Doctors d ON a.DoctorID = d.DoctorID 
                JOIN 
                    Categories c ON a.CategoryID = c.CategoryID 
                WHERE 
                    a.PatientID = :patientId
            ";
            
            // Initialize query parameters
            local.queryParams = { patientId: session.UserID };
            
            // Add status condition if provided
            if (len(trim(arguments.status))) {
                local.queryStr &= " AND LOWER(a.AppointmentStatus) = LOWER(:status) ";
                local.queryParams.status = arguments.status;
            }
            
            // Add date condition
            if (len(trim(arguments.date))) {
                if(arguments.date EQ dateFormat(now(), "yyyy-MM-dd")){
                    local.queryStr &= " AND a.DateAndTime = :today AND a.StartTime > :currentTime ";
                    local.queryParams.today = dateFormat(now(), "yyyy-MM-dd");
                }else{
                    local.queryStr &= " AND a.DateAndTime = :date ";
                    local.queryParams.date = arguments.date;
                }
            } else {
                local.queryStr &= " AND (a.DateAndTime > :today OR (a.DateAndTime = :today AND a.StartTime > :currentTime)) ";
                local.queryParams.today = dateFormat(now(), "yyyy-MM-dd");
            }
    
            // Always set current time for time comparison
            local.queryParams.currentTime = timeFormat(now(), "HH:mm:ss");
    
            // Append ordering logic outside the condition
            local.queryStr &= " ORDER BY a.DateAndTime ASC, a.StartTime ASC";
    
            // Execute the query
            local.appointmentInfo = queryExecute(local.queryStr, local.queryParams);
    
            // Check if any records found
            if (local.appointmentInfo.recordCount > 0) {
                for (local.row in local.appointmentInfo) {
                    local.formattedDate = dateFormat(local.row.DateAndTime, "yyyy-MM-dd");
                    local.timeOnly = timeFormat(local.row.StartTime, "hh:mm tt");
    
                    // Populate the result data
                    local.data[local.row.AppointmentID] = {
                        Date: local.formattedDate,
                        Time: local.timeOnly,
                        CreatedAt: local.row.CreatedAt,
                        AppointmentStatus: local.row.AppointmentStatus,
                        DATAAVAILABLE: true,
                        Doctor: {
                            FullName: local.row.FullName,
                            DoctorID: local.row.DoctorID,
                            Qualification: local.row.Qualification,
                            Email: local.row.Email,
                            Phone: local.row.Phone,
                            ImagePath: local.row.imagePath
                        },
                        CategoryName: local.row.CategoryName,
                        APPOINTMENTID: local.row.AppointmentID
                    };
                }
            } else {
                // Set the data if no appointments found
                local.data["NoAppointments"] = {
                    DATAAVAILABLE: false,
                    AppointmentStatus: arguments.status
                };
            }
            return local.data;
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error fetching appointments: " & e.message & "; Details: " & e.detail);
            return { error: true, message: e.message };
        }
    }
    


    // NOTE: Updated with new Database.
    public struct function getAllPastAppointmentDetails(string status, string date) {
        local.data = structNew();
    
        try {

            local.queryStr =    "SELECT a.AppointmentID, a.DateAndTime, a.CreatedAt, a.AppointmentStatus, a.StartTime, d.FullName, d.Qualification, d.Email, 
                                d.Phone, d.DoctorID, d.imagePath, d.imagePath, c.CategoryName 
                                FROM Appointments a 
                                JOIN Doctors d ON a.DoctorID = d.DoctorID 
                                JOIN Categories c ON a.CategoryID = c.CategoryID 
                                WHERE a.PatientID = :patientId "

            local.queryParams = {
                patientId: session.UserID,
                today: dateFormat(now(), "yyyy-MM-dd"),
                currentTime: timeFormat(now(), "HH:mm:ss")
            }
            
            if (arguments.status != "") {
                local.queryStr &= " AND LOWER(a.AppointmentStatus) = LOWER(:status) ";
                local.queryParams.status = arguments.status;
            }

            // local.queryStr &= "AND (a.DateAndTime < :today OR (a.DateAndTime = :today AND a.StartTime < :currentTime)) ORDER BY a.DateAndTime ASC, a.StartTime ASC";

            // Add date condition
            if (len(trim(arguments.date))) {
                if(trim(arguments.date) EQ dateFormat(now(), "yyyy-MM-dd")){
                    local.queryStr &= " AND a.DateAndTime = :today AND a.StartTime < :currentTime ORDER BY a.DateAndTime ASC, a.StartTime ASC";
                    local.queryParams.today = dateFormat(now(), "yyyy-MM-dd");
                }else{
                    local.queryStr &= " AND a.DateAndTime = :date ORDER BY a.DateAndTime ASC, a.StartTime ASC";
                    local.queryParams.date = arguments.date;
                }
            } else {
                local.queryStr &= " AND (a.DateAndTime < :today OR (a.DateAndTime = :today AND a.StartTime < :currentTime)) ORDER BY a.DateAndTime ASC, a.StartTime ASC";
                local.queryParams.today = dateFormat(now(), "yyyy-MM-dd");
            }

            local.appointmentInfo = queryExecute(local.queryStr, local.queryParams);
    
            if (local.appointmentInfo.recordCount > 0) {
                for (local.row in local.appointmentInfo) {

                    local.formattedDate = dateFormat(local.row.DateAndTime, "yyyy-MM-dd");
                    local.timeOnly = timeFormat(local.row.StartTime, "hh:mm tt");

                    local.data[local.row.AppointmentID] = {
                        Date: local.formattedDate,
                        Time: local.timeOnly,
                        CreatedAt: local.row.CreatedAt,
                        AppointmentStatus: local.row.AppointmentStatus,
                        DATAAVAILABLE: true,
                        Doctor: {
                            FullName: local.row.FullName,
                            DoctorID: local.row.DoctorID,
                            Qualification: local.row.Qualification,
                            Email: local.row.Email,
                            Phone: local.row.Phone,
                            ImagePath: local.row.imagePath
                        },
                        CategoryName: local.row.CategoryName,
                        APPOINTMENTID: local.row.AppointmentID
                    };
                }
            }else{
                local.data[1] = {
                    DATAAVAILABLE: false,
                    AppointmentStatus: arguments.status
                }
            }
            return local.data;
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error fetching appointments: " & e.message & "; Details: " & e.detail);
            return local.data;
        }
    }


    // NOTE: Updated with new Database.
    public struct function getNotificationData() {
        local.data = structNew();
    
        try {

            local.queryStr =    "SELECT AppointmentID, AppointmentStatus, DateAndTime, StartTime
                                FROM Appointments
                                WHERE AppointmentStatus IN (:pending, :confirmed) 
                                AND (DateAndTime < :today OR (DateAndTime = :today AND StartTime < :currentTime))";


            local.queryParams = {
                today: dateFormat(now(), "yyyy-MM-dd"),
                currentTime: timeFormat(now(), "HH:mm:ss"),
                pending: application.APPOINTMENT_STATUS_PENDING,
                confirmed: application.APPOINTMENT_STATUS_CONFIRMED
            }
            
            // if (arguments.status != "") {
            //     local.queryStr &= " AND LOWER(a.AppointmentStatus) = LOWER(:status) ";
            //     local.queryParams.status = arguments.status;
            // }

            // local.queryStr &= "AND (a.DateAndTime < :today OR (a.DateAndTime = :today AND a.StartTime < :currentTime)) ORDER BY a.DateAndTime ASC, a.StartTime ASC";

            // Add date condition
            // if (len(trim(arguments.date))) {
            //     if(trim(arguments.date) EQ dateFormat(now(), "yyyy-MM-dd")){
            //         local.queryStr &= " AND a.DateAndTime = :today AND a.StartTime < :currentTime ORDER BY a.DateAndTime ASC, a.StartTime ASC";
            //         local.queryParams.today = dateFormat(now(), "yyyy-MM-dd");
            //     }else{
            //         local.queryStr &= " AND a.DateAndTime = :date ORDER BY a.DateAndTime ASC, a.StartTime ASC";
            //         local.queryParams.date = arguments.date;
            //     }
            // } else {
            //     local.queryStr &= " AND (a.DateAndTime < :today OR (a.DateAndTime = :today AND a.StartTime < :currentTime)) ORDER BY a.DateAndTime ASC, a.StartTime ASC";
            //     local.queryParams.today = dateFormat(now(), "yyyy-MM-dd");
            // }

            local.appointmentInfo = queryExecute(local.queryStr, local.queryParams);
    
            if (local.appointmentInfo.recordCount > 0) {
                for (local.row in local.appointmentInfo) {

                    local.formattedDate = dateFormat(local.row.DateAndTime, "yyyy-MM-dd");
                    local.timeOnly = timeFormat(local.row.StartTime, "hh:mm tt");

                    

                    local.holdData[local.row.AppointmentID] = {
                        // Date: local.formattedDate,
                        // Time: local.timeOnly,
                        // CreatedAt: local.row.CreatedAt,
                        // AppointmentStatus: local.row.AppointmentStatus,
                        // DATAAVAILABLE: true,
                        // Doctor: {
                        //     FullName: local.row.FullName,
                        //     DoctorID: local.row.DoctorID,
                        //     Qualification: local.row.Qualification,
                        //     Email: local.row.Email,
                        //     Phone: local.row.Phone,
                        //     ImagePath: local.row.imagePath
                        // },
                        // CategoryName: local.row.CategoryName,
                        // APPOINTMENTID: local.row.AppointmentID
                        // Count: local.appointmentInfo.recordCount,
                        // DATAAVAILABLE: true,
                        APPOINTMENTTIME: local.timeOnly,
                        APPOINTMENTDATE: local.formattedDate,
                        AppointmentId: local.row.AppointmentID,
                        Status: local.row.AppointmentStatus
                    };
                    local.data["COUNT"] = local.appointmentInfo.recordCount;
                    local.data["DATAAVAILABLE"] = true;

                }
                local.data["DATA"] = local.holdData;
            }else{
                local.data["DATAAVAILABLE"] = false;
            }
            return local.data;
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error fetching appointments: " & e.message & "; Details: " & e.detail);
            return local.data;
        }
    }

}