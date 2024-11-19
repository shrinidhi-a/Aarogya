<main>
    <div class="container mt-5">
        <div class="row">

            <h5 class="mt-5"></h5>

            <div id="confirmedAppointment"></div>

            <div class="row mt-5">
                <div class="col d-flex justify-content-between align-items-center">
                    <h5 class="mt-5">Create an appointment <span>&#10151;</span></h5>
                    <button class="btn shadow" style="background-color:#fdfdfd; color:#4fa284" data-bs-toggle="modal" data-bs-target="#modalFilter">filter 
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-filter" viewBox="0 0 16 16">
                            <path d="M6 10.5a.5.5 0 0 1 .5-.5h3a.5.5 0 0 1 0 1h-3a.5.5 0 0 1-.5-.5m-2-3a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5m-2-3a.5.5 0 0 1 .5-.5h11a.5.5 0 0 1 0 1h-11a.5.5 0 0 1-.5-.5"/>
                          </svg>
                    </button>
                </div>
            </div>

            <div id="doctorCards"></div>

        </div>
    </div>

    <div class="modal fade" id="modalFilter" tabindex="-1" data-bs-backdrop="static" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header border-0">
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="pt-4 pb-2">
                    <h5 class="card-title text-center pb-0 fs-4">Add Filters</h5>
                    <p class="text-center small" style="color:#4fa284">Find best doctor for you in Aarogya</p>
                </div>
                <form class="row g-3" novalidate>

                  <div class="col-12" id="categoryDropDownFilter"></div>

                  <div class="col-12">
                      <label for="dateTimeInputFilter" class="form-label">Date and Time</label>
                        <input type="date" name="date" class="form-control" id="dateTimeInputFilter" required/>
                        <div class="invalid-feedback"></div>
                  </div>

                </form>
            </div>
            <div class="modal-footer border-0">
                <button
                            id="submitBtnFilter"
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

    
</main>