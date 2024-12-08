<main id="main" class="main">
    <div class="container mb-3 mt-7 min-vh-100 border-0" style="margin-top: 90px;">
        <div class="card-body">
            <div class="row">
                <div class="col-8">
                    <h4>Manage User Profiles</h4>
                </div>
                <div class="col-4">
                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <button class="btn shadow me-md-2 btn-sm" type="button" id="" data-bs-toggle="modal" data-bs-target="#exampleModalAddDoctor" style="background-color:#fdfdfd; color:#4fa284">Add New User</button>
                    </div>
                </div>
            </div>
            <br>
            <div class="row align-items-center">
                <input 
                id="userSerchInput"
                  type="text" 
                  class="form-control col" 
                  placeholder="Enter Email Address here to search for users." 
                  aria-label="Recipient's username"
                >
                <div
                  title="Search Users" 
                  style="cursor: pointer;" 
                  class="col d-flex align-items-center"
                  id="userSearchBtn"
                >
                  <svg 
                    xmlns="http://www.w3.org/2000/svg" 
                    style="fill:#40C057;"
                    width="25" 
                    height="25" 
                    fill="currentColor" 
                    class="bi bi-search" 
                    viewBox="0 0 16 16"
                  >
                    <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001q.044.06.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1 1 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0"/>
                  </svg>
                </div>
            </div>
              
            
            <div id="UserList"></div>
        </div>   
    </div>

    <div class="modal fade" id="exampleModalAddDoctor" tabindex="-1" data-bs-backdrop="static" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header border-0">
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

            <div class="modal-body">

                <div class="pt-4 pb-2">
                    <h5 class="card-title text-center pb-0 fs-4">Add a New User</h5> 
                    <p class="text-center small">Please fill in the details below to register a new User.</p>
                    <div id="messageDiv" class="alert"></div>
                </div>

                <form class="row g-3" novalidate>

                    <div class="col-12">
                        <label for="yourRoleManage" class="form-label">Select Your Account Type</label>
                        <div class="input-group has-validation">
                            <select name="role" class="form-control" id="yourRoleManage" required>
                                <option value="patient" selected>Patient</option>
                                <option value="admin">Admin</option>
                            </select>
                            <div class="invalid-feedback"></div>
                        </div>
                    </div>
                      <div class="col-12">
                        <label for="yourName" class="form-label">Full Name</label>
                        <input type="text" name="name" class="form-control" id="yourName" required>
                        <div class="invalid-feedback"></div>
                      </div>
                      <div class="col-12" id="dataOfBirthContainerManage">
                          <label for="yourDob" class="form-label">Date of Birth</label>
                          <input type="date" name="dateofbirth" class="form-control" id="yourDob" required>
                          <div class="invalid-feedback"></div>
                        </div>
                      <div class="col-12">
                        <label for="yourEmail" class="form-label">Email Address</label>
                        <div class="input-group has-validation">
                          <span class="input-group-text" id="inputGroupPrepend">@</span>
                          <input type="email" name="email" class="form-control" id="yourEmail" required>
                          <div class="invalid-feedback"></div>
                        </div>
                      </div>
                      <div class="col-12" id="phoneContainerManage">
                        <label for="yourPhoneNumber" class="form-label">Phone Number</label>
                        <div class="input-group has-validation">
                          <input type="tel" name="phoneNumber" class="form-control" id="yourPhoneNumber" required>
                          <div class="invalid-feedback"></div>
                        </div>
                      </div>
                      <div class="col-12" id="insuranceProviderContainerManage">
                        <label for="yourInPr" class="form-label">Insurance provider</label>
                        <input type="text" name="insuranceProvider" class="form-control" id="yourInPr" required>
                        <div class="invalid-feedback"></div>
                      </div>
                      <div class="col-12" id="insuranceCoverageContainerManage">
                          <label for="yourInVal" class="form-label">Insurance coverage expiration date</label>
                          <input type="date" name="insuranceExpiration" class="form-control" id="yourInVal" required>
                          <div class="invalid-feedback"></div>
                        </div>
                      <div class="col-12">
                        <label for="yourPassword" class="form-label">Password</label>
                        <input type="password" name="password" class="form-control" id="yourPassword" required>
                        <div class="invalid-feedback"></div>
                      </div>
                      <div class="col-12">
                        <label for="confirmPassword" class="form-label">Confirm Password</label>
                        <input type="password" name="confirmPassword" class="form-control" id="confirmPassword" required>
                        <div class="invalid-feedback"></div>
                      </div>

                    
                    
                    <div class="modal-footer border-0">
                        <button
                                id="submitBtnNewUser"
                                class="btn shadow"
                                style="background-color:#fdfdfd; color:#4fa284"
                            >
                            Add New User
                        </button>
                        <button type="button" class="btn shadow" data-bs-dismiss="modal" style="background-color:#fdfdfd; color:#4fa284">Close</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>