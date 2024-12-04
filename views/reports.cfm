
    <main id="main" class="main">
        <!--- <div class="card w-90 mb-3 mt-7 mx-3" id="profile-content" style="margin-top: 70px;"></div> --->
        <div class="container mb-3 mt-7 min-vh-100 border-0" style="margin-top: 90px;">
            <div class="card-body">
                <div class="row">
                    <div class="col-8">
                        <h4>Reports</h4>
                    </div>
                    <div class="col-4">
                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                            <button class="btn btn-sm shadow" type="button" id="downloadAllReports" style="background-color:#fdfdfd; color:#4fa284">Download All Reports</button>
                            <!--- <button class="btn btn-sm shadow" type="button" id="AddDoctorAdmin" style="background-color:#fdfdfd; color:#4fa284">Add New Doctor</button> --->
                        </div>
                    </div>
                </div>
                <br>
                <div>
                    <div class="d-flex align-items-center">
                        <!-- Email Input -->
                        <input 
                            id="userSerchInputReports"
                            type="text" 
                            class="form-control flex-grow-1 me-2" 
                            placeholder="Enter Email Address of Patient to search" 
                            aria-label="Recipient's username"
                        >
                
                        <!-- Role Dropdown -->
                        <select name="role" class="form-control flex-grow-1 me-2" id="appointmentStatusReport" required>
                            <option value="" selected>Select All</option>
                            <option value="Pending">Pending</option>
                            <option value="Confirmed">Confirmed</option>
                            <option value="Completed">Completed</option>
                            <option value="Cancelled">Cancelled</option>
                            <option value="NoShow">NoShow</option>
                        </select>
                
                        <!-- Date of Birth Input -->
                        <input 
                            type="date" 
                            name="dateofbirth" 
                            class="form-control flex-grow-1 me-2" 
                            id="appointmentDateReport" 
                            required
                        >
                
                        <!-- Search Button -->
                        <button class="btn btn-sm shadow flex-grow-1 me-2" type="button" id="searchButtonReport" style="background-color:#fdfdfd; color:#4fa284">
                            Search
                        </button>
                
                        <!-- Download Button -->
                        <button class="btn btn-sm shadow flex-grow-1" type="button" id="downloadFilteredReports" style="background-color:#fdfdfd; color:#4fa284">
                            Download
                        </button>
                    </div>
                </div>
                
                
                <!--- <ul class="nav nav-underline">
                    <li class="nav-item">
                        <a class="nav-link navColor active" aria-current="page" id="requests-tab" href="#">Appointment Requests</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link navColor" aria-current="page" id="confirmedApp-tab" href="#">Confirmed Appointments</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link navColor" aria-current="page" id="completedApp-tab" href="#">Completed Appointments</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link navColor" aria-current="page" id="concelledApp-tab" href="#">Cancelled Appointments</a>
                    </li>
                </ul> --->

                <div class="flex-column align-items-center justify-content-center">

                    <div class="row" id="reportsAppointment"></div>

                    <div class="text-center mt-3">
                        <p class="card-text" id="noAppointmentAvailableVerify"></p>
                    </div>
                    
                </div>
            </div>   
        </div>
    </main>
