<main>
    <div class="container">
      <section class="section register min-vh-100 d-flex flex-column align-items-center justify-content-center py-4 min-vw-80">
        <div class="container">
          <div class="row justify-content-center">
            <div class="col-lg-9 col-md-6 d-flex flex-column align-items-center justify-content-center">
              <div class="card shadow border border-0 mb-3 mt-5" style="height: 80vh; overflow-y: auto;">
                <div class="card-body">
                  <div class="pt-4 pb-2">
                    <h5 class="card-title text-center pb-0 fs-4">Create an Account</h5>
                    <p class="text-center small" style="color:#4fa284">Enter your personal details to create account in Aarogya</p>
                    <div id="messageDiv" class="alert"></div>
                  </div>
                  <form class="row g-3" novalidate>
                    <div class="col-12">
                      <label for="yourRole" class="form-label">Select Your Account Type</label>
                      <div class="input-group has-validation">
                          <select name="role" class="form-control" id="yourRole" required>
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
                    <div class="col-12" id="dataOfBirthContainer">
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
                    <div class="col-12" id="phoneContainer">
                      <label for="yourPhoneNumber" class="form-label">Phone Number</label>
                      <div class="input-group has-validation">
                        <input type="tel" name="phoneNumber" class="form-control" id="yourPhoneNumber" required>
                        <div class="invalid-feedback"></div>
                      </div>
                    </div>
                    <div class="col-12" id="insuranceProviderContainer">
                      <label for="yourInPr" class="form-label">Insurance provider</label>
                      <input type="text" name="insuranceProvider" class="form-control" id="yourInPr" required>
                      <div class="invalid-feedback"></div>
                    </div>
                    <div class="col-12" id="insuranceCoverageContainer">
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
                    <div class="col-12">
                      <div class="form-check">
                        <input class="form-check-input" name="terms" type="checkbox" id="acceptTerms">
                        <label class="form-check-label" for="acceptTerms" id="acceptTermslabel">I agree and accept the <a href="">terms and conditions</a></label>
                        <div class="invalid-feedback"></div>
                      </div>
                    </div>
                    <div class="col-12">
                      <button id="submitBtn" class="btn w-100 shadow" style="background-color:#fdfdfd; color:#4fa284">REGISTER</button>
                    </div>
                    <div class="col-12">
                      <p class="small mb-0">Already have an account? <a href="./index.cfm?action=login">Log in</a></p>
                    </div>
                  </form>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
  </main>