<main id="main" class="main">
    <div class="card w-90 mb-3 mt-7 mx-3 min-vh-100 border-0" style="margin-top: 70px;">
        <div class="card-body">
            <div class="row">
                <div class="col-8">
                    <h4>Manage Doctors</h4>
                </div>
                <div class="col-4">
                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <button class="btn shadow me-md-2 btn-sm" type="button" id="" data-bs-toggle="modal" data-bs-target="#exampleModalAddDoctor" style="background-color:#fdfdfd; color:#4fa284">Add New Doctor</button>
                    </div>
                </div>
            </div>
            <br>
            <div id="categoryDropDownManageDoctor"></div>
            <div id="doctorsList"></div>
            <div class="mt-5 text-center" id="doctorsDisplayInformation">Please select category to display doctors</div>
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