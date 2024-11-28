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
                  type="text" 
                  class="form-control col" 
                  placeholder="Enter Email ID here to search for users." 
                  aria-label="Recipient's username"
                >
                <div
                  title="Search Users" 
                  style="cursor: pointer;" 
                  class="col d-flex align-items-center"
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
                    <h5 class="card-title text-center pb-0 fs-4">Add a New Doctor</h5> 
                    <p class="text-center small">Please fill in the details below to register a new doctor and enhance our Aarogya appointment system.</p>
                    <div id="messageDiv" class="alert"></div>
                </div>

                <form class="row g-3" novalidate>

                    <div class="col-12">
                        <label for="yourName" class="form-label">Full Name</label>
                        <input type="text" name="name" class="form-control" id="yourName" required>
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

                    <div class="col-12">
                        <label for="yourPhoneNumber" class="form-label">Phone Number</label>
                        <div class="input-group has-validation">
                            <input type="tel" name="phoneNumber" class="form-control" id="yourPhoneNumber" required>
                            <div class="invalid-feedback"></div>
                        </div>
                    </div>

                    <div class="col-12">
                        <label for="yourQualification" class="form-label">Qualification</label>
                        <input type="text" name="Qualification" class="form-control" id="yourQualification" required>
                        <div class="invalid-feedback"></div>
                    </div>

                    <div class="col-12">
                        <label for="fileUploadDoctor" class="form-label">Choose Doctor image to upload</label>
                        <input type="file" class="form-control" id="fileUploadDoctor" name="fileUpload" required/>
                        <div class="invalid-feedback"></div>
                    </div>

                    <div class="col-12" id="categoryDropDownNewDoc"></div>
                    </div>
                    <div class="modal-footer border-0">
                        <button
                                id="submitBtnNewDoctor"
                                class="btn shadow"
                                style="background-color:#fdfdfd; color:#4fa284"
                            >
                            Add New Doctor
                        </button>
                        <button type="button" class="btn shadow" data-bs-dismiss="modal" style="background-color:#fdfdfd; color:#4fa284">Close</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>