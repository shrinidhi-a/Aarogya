<main>
    <div class="container">
       
        <section class="section register min-vh-100 d-flex flex-column align-items-center justify-content-center py-4">
          <div class="container">
            <div class="row justify-content-center">
              <div class="col-lg-4 col-md-6 d-flex flex-column align-items-center justify-content-center">
                <div class="card mb-3 mt-5 border-0 shadow">
    
                  <div class="card-body">
    
                    <div class="pt-4 pb-2">
                      <h5 class="card-title text-center pb-0 fs-4">Reset Password</h5>
                        <p class="text-center small">Enter New Password</p>
                        <div id="messageDiv" class="alert"></div>
                    </div>
    
                    <form class="row g-3" novalidate>
    
                        <div class="col-12">
                            <input type="hidden" id="token" value="<cfoutput>#url.resetToken#</cfoutput>">
                            <label for="yourPassword" class="form-label">Password</label>
                            <input type="password" name="password" class="form-control" id="yourPassword" required>
                            <div class="invalid-feedback"></div>
                          </div>
                          <div class="col-12">
                            <label for="confirmPassword" class="form-label">Confirm Password</label>
                            <input type="password" name="password" class="form-control" id="confirmPassword" required>
                            <div class="invalid-feedback"></div>
                          </div>
    
                      <div class="col-12">
                        <button class="btn shadow w-100" id="resetButton" style="background-color:#fdfdfd; color:#4fa284">Reset Password</button>
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