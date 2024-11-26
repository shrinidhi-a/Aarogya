
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
                            <!--- <button class="btn btn-primary me-md-2 btn-sm" type="button" id="AddDoctorAdmin" style="background-color:#4fa284; color:#1a4041">Add New Doctor</button> --->
                            <button class="btn btn-sm shadow" type="button" id="downloadAllReports" style="background-color:#fdfdfd; color:#4fa284">Download All Reports</button>
                        </div>
                    </div>
                </div>
                <ul class="nav nav-underline">
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
                </ul>

                <div class="flex-column align-items-center justify-content-center">

                    <div class="row" id="reportsAppointment"></div>

                    <div class="text-center mt-3">
                        <p class="card-text" id="noAppointmentAvailableVerify"></p>
                    </div>
                    
                </div>
            </div>   
        </div>
    </main>
