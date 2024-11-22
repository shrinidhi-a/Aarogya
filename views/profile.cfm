<cfif structKeyExists(session, "isLoggedIn") AND session.role == 'admin'>
    <main id="main" class="main">
        <!--- <div class="card w-90 mb-3 mt-7 mx-3" id="profile-content" style="margin-top: 70px;"></div> --->
        <div class="container mt-10">
            <div class="card mb-3 border-0" style="margin-top: 70px;">
                <div class="card-body">

                    <div class="row">
                        <div class="col d-flex mb-3 justify-content-between align-items-center">
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
                                <li class="nav-item">
                                    <a class="nav-link navColor" aria-current="page" id="no-show-tab" href="#">No-Show Appointments</a>
                                </li>
                            </ul>
                            <div id="notificationButtonAdmin"></div>
                        </div>
                    </div>

                    <div class="flex-column align-items-center justify-content-center">

                        <div class="row align-items-center justify-content-center" id="appointmentsForAdmin"></div>

                        <div class="text-center mt-3">
                            <p class="card-text" id="noAppointmentAvailableVerify"></p>
                        </div>
                        
                    </div>
                </div>   
            </div>
        </div>

        <div
            class="modal fade"
            id="PrescriptionModal"
            tabindex="-1"
            data-bs-backdrop="static"
            aria-labelledby="exampleModalLabel"
            aria-hidden="true"
        >
            <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
                <div class="modal-content">
                    <div class="modal-header border-0">
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="pt-4 pb-2">
                            <h5 class="card-title text-center pb-0 fs-4">Add Prescription</h5>
                            <p class="text-center small">Add Prescription Note and Prescription file</p>
                            <div id="messageDivPrescription" class="alert"></div>
                        </div>
                        <form class="row g-3" novalidate>
                            <div class="col-12">
                                <label for="prescriptionNote" class="form-label">Give a Prescription note</label>
                                <textarea
                                    name="prescription"
                                    class="form-control"
                                    id="prescriptionNote"
                                    required
                                ></textarea>
                                <div class="invalid-feedback"></div>
                            </div>
                            <div class="col-12">
                                <label for="fileUploadPrescription" class="form-label">Choose prescription file to upload</label>
                                <input type="file" class="form-control" id="fileUploadPrescription" name="fileUpload" required/>
                                <div class="invalid-feedback"></div>
                            </div>
                            <div class="col-12">
                                <input type="text" name="text" class="form-control d-none" id="addPrescriptioAppointmentId" required />
                            </div>
                            <div class="col-12">
                                <input type="text" name="text" class="form-control d-none" id="addPrescriptionPatientId" required />
                            </div>
                            <div class="col-12">
                                <input type="text" name="text" class="form-control d-none" id="addPrescriptionDoctorId" required />
                            </div>
                            <div class="col-12">
                                <input type="text" name="text" class="form-control d-none" id="addPrescriptionPatientEmail" required />
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer border-0">
                        <button id="submitBtnPrescription" class="btn shadow" style="background-color:#fdfdfd; color:#4fa284">
                            Add Prescription
                        </button>
                        <button
                            type="button"
                            class="btn shadow"
                            data-bs-dismiss="modal"
                            style="background-color:#fdfdfd; color:#4fa284"
                        >Close</button>
                    </div>
                </div>
            </div>
        </div>
    </main>
<cfelse>
        <main id="mainProfile" class="mainProfile">
            <div class="card mb-3 mt-7 mx-3 border border-0 min-vh-100" style="margin-top: 70px; background-color: #fdfdfd;">
                
                <div class="card-body">
                    <!--- <div class="row">
                        <div class="col-8">
                            <h4>Appointments</h4>
                        </div>
                        <div class="col-4">
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                
                                <!--- <button class="btn me-md-2 btn-sm shadow" type="button" data-bs-toggle="modal" data-bs-target="#exampleModal" style="background-color:#fdfdfd; color:#4fa284">Create New Appointment</button> --->
                                
                            </div>
                        </div>
                    </div> --->
                    <!--- <ul class="container nav nav-underline mb-4">
                        <li class="nav-item">
                            <a class="nav-link active navColor" aria-current="page" id="activeTab" href="#">Active Appointments</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link navColor" aria-current="page" id="historyTab" href="#">Appointment History</a>
                        </li>
                    </ul> --->


                    <!--- <ul class="nav nav-underline">
                        <li class="nav-item">
                            <a class="nav-link active navColor" aria-current="page" id="pending-tab" href="#">Pending Appointments</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link navColor" aria-current="page" id="confirmed-tab" href="#">Confirmed Appointments</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link navColor" aria-current="page" id="cancelled-tab" href="#">Cancelled Appointments</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link navColor" aria-current="page" id="completed-tab" href="#">Completed Appointments</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link navColor" aria-current="page" id="no-show-tab" href="#">No-Show Appointments</a>
                        </li>
                    </ul> --->

                    <div class="container flex-column align-items-center justify-content-center">

                        <div class="row">
                            <div class="col d-flex justify-content-between align-items-center">
                                <ul class="nav nav-underline mb-4">
                                    <li class="nav-item">
                                        <a class="nav-link active navColor" aria-current="page" id="activeTab" href="#">Active Appointments</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link navColor" aria-current="page" id="historyTab" href="#">Appointment History</a>
                                    </li>
                                </ul>
                                <div>
                                    <button class="btn shadow" id="filterActive" style="background-color:#fdfdfd; color:#4fa284" data-bs-toggle="modal" data-bs-target="#modalFilterActive">filter 
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-filter" viewBox="0 0 16 16">
                                            <path d="M6 10.5a.5.5 0 0 1 .5-.5h3a.5.5 0 0 1 0 1h-3a.5.5 0 0 1-.5-.5m-2-3a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5m-2-3a.5.5 0 0 1 .5-.5h11a.5.5 0 0 1 0 1h-11a.5.5 0 0 1-.5-.5"/>
                                        </svg>
                                    </button>
                                    <button class="btn shadow mx-2" id="sortActive" style="background-color:#fdfdfd; color:#4fa284">
                                        <!-- Sort Down Icon (Visible by Default) -->
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-sort-down sort-icon sort-down" viewBox="0 0 16 16">
                                            <path d="M3.5 2.5a.5.5 0 0 0-1 0v8.793l-1.146-1.147a.5.5 0 0 0-.708.708l2 1.999.007.007a.497.497 0 0 0 .7-.006l2-2a.5.5 0 0 0-.707-.708L3.5 11.293zm3.5 1a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5M7.5 6a.5.5 0 0 0 0 1h5a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h3a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h1a.5.5 0 0 0 0-1z"/>
                                        </svg>
                                        
                                        <!-- Sort Up Icon (Hidden by Default) -->
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-sort-up sort-icon sort-up d-none" viewBox="0 0 16 16">
                                            <path d="M3.5 12.5a.5.5 0 0 1-1 0V3.707L1.354 4.854a.5.5 0 1 1-.708-.708l2-1.999.007-.007a.5.5 0 0 1 .7.006l2 2a.5.5 0 1 1-.707.708L3.5 3.707zm3.5-9a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5M7.5 6a.5.5 0 0 0 0 1h5a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h3a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h1a.5.5 0 0 0 0-1z"/>
                                        </svg>
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="row" id="appointmentsListNew"></div>

                        <!--- <div class="text-center mt-3">
                            <p class="card-text" id="noAppointmentAvailable"></p>
                        </div> --->
                        
                    </div>
                </div>   
            </div>

            <div class="modal fade" id="modalFilterActive" tabindex="-1" data-bs-backdrop="static" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
                <div class="modal-content">
                    <div class="modal-header border-0">
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="pt-4 pb-2">
                            <h5 class="card-title text-center pb-0 fs-4">Add Filters</h5>
                            <p class="text-center small" style="color:#4fa284">Filter Your appointments as per status</p>
                        </div>
                        <form class="row g-1" novalidate>

                            <div class="col-12">
                                <label for="dateTimeInputFilterList" class="form-label">Date and Time</label>
                                  <input type="date" name="date" class="form-control" id="dateTimeInputFilterList" required/>
                                  <div class="invalid-feedback"></div>
                            </div>
        
                            <label for="statusSelect" class="form-label">Select Status</label>
                            <select name="statusSelect" class="form-control" id="statusSelect" required>
                                <option value="default" disabled selected>-- Click here --</option>
                                <option value="">Show all</option>
                                <option value="Pending">Pending</option>
                                <option value="Confirmed">Confirmed</option>
                                <option value="Completed">Completed</option>
                                <option value="Cancelled">Cancelled</option>
                                <option value="NoShow">NoShow</option>
                            </select>
        
                        </form>
                    </div>
                    <div class="modal-footer border-0">
                        <button
                                    id="submitBtnFilterActive"
                                    class="btn shadow"
                                    style="background-color:#fdfdfd; color:#4fa284"
                                    data-bs-dismiss="modal"
                                >
                                Apply Filter
                        </button>
                        <button type="button" class="btn shadow" data-bs-dismiss="modal" style="background-color:#fdfdfd; color:#4fa284">Close</button>
                    </div>
                </div>
                </div>
            </div>
  
            <!--- <!-- Modal -->
            <div class="modal fade" id="exampleModal" tabindex="-1" data-bs-backdrop="static" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
                <div class="modal-content">
                    <div class="modal-header border-0">
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="pt-4 pb-2">
                            <h5 class="card-title text-center pb-0 fs-4">Create an Appointment</h5>
                            <p class="text-center small">Enter your details to create Appointment in Aarogya</p>
                            <div id="messageDiv" class="alert"></div>
                        </div>
                        <form class="row g-3" novalidate>

                          <div class="col-12" id="categoryDropDown"></div>

                          <div class="col-12" id="doctorDropDown"></div>

                          <div class="col-12">
                              <label for="dateTimeInput" class="form-label">Date and Time</label>
                                <input type="date" name="date" class="form-control" id="dateTimeInput" required/>
                                <div class="invalid-feedback"></div>
                          </div>

                          <div class="col-12" id="AvailableAppoitments"></div>

                        </form>
                    </div>
                    <div class="modal-footer border-0">
                        <button
                                    id="submitBtnAppointment"
                                    class="btn shadow"
                                    style="background-color:#fdfdfd; color:#4fa284"
                                >
                                Apply for appointment
                        </button>
                        <button type="button" class="btn shadow" data-bs-dismiss="modal" style="background-color:#fdfdfd; color:#4fa284">Close</button>
                    </div>
                </div>
                </div>
            </div> --->

            <div
                class="modal fade"
                id="ResheduleModal"
                tabindex="-1"
                data-bs-backdrop="static"
                aria-labelledby="exampleModalLabel"
                aria-hidden="true"
            >
                <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
                    <div class="modal-content">
                        <div class="modal-header border-0">
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="pt-4 pb-2">
                                <h5 class="card-title text-center pb-0 fs-4">Reshedule Appointment</h5>
                                <p class="text-center small">Select date and time to Reshedule Appointments</p>
                                <div id="messageDivReschedule" class="alert"></div>
                            </div>
                            <form class="row g-3" novalidate>

                                <div class="col-12">
                                    <label for="dateTimeInputReschedule" class="form-label">Date and Time</label>
                                    <input type="date" name="date" class="form-control" id="dateTimeInputReschedule" required />
                                    <div class="invalid-feedback"></div>
                                </div>

                                <div class="col-12">
                                    <input type="text" name="text" class="form-control d-none" id="resheduleAppointmentAppontment" required />
                                </div>

                                <div class="col-12">
                                    <input type="text" name="text" class="form-control d-none" id="resheduleAppointmentDoctor" required />
                                </div>

                                <div class="col-12" id="AvailableAppoitmentstoReshedule"></div>

                            </form>
                        </div>
                        <div class="modal-footer border-0">
                            <button id="submitBtnReshedule" class="btn shadow" style="background-color:#fdfdfd; color:#4fa284">
                                Reshedule appointment
                            </button>
                            <button
                                type="button"
                                class="btn shadow"
                                data-bs-dismiss="modal"
                                style="background-color:#fdfdfd; color:#4fa284"
                            >Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </main>
</cfif>
    
    
    