<main>
    <div class="container"> 
        <section class="section register min-vh-100 d-flex flex-column align-items-center justify-content-center py-4">
          <div class="container">
            <div class="row justify-content-center">
              <div class="col-lg-4 col-md-6 d-flex flex-column align-items-center justify-content-center">
                <div class="card mb-3 mt-5 border-0 shadow">
                  <div class="card-body">
                    <div class="pt-4 pb-2">
                      <h5 class="card-title text-center pb-0 fs-4">Forgot Password</h5>
                      <p class="text-center small">Enter your registered email to receive a password reset link.</p>
                      <div id="messageDiv" class="alert"></div>
                    </div>
    
                    <form class="row g-3" novalidate>
    
                      <div class="col-12">
                        <label for="yourEmail" class="form-label">Email Address</label>
                        <div class="input-group has-validation">
                          <span class="input-group-text" id="inputGroupPrepend">@</span>
                          <input type="text" name="email" class="form-control" id="yourEmail" required>
                          <div class="invalid-feedback"></div>
                        </div>
                      </div>
    
                      <div class="col-12">
                        <button class="btn shadow w-100" id="sendLink" style="background-color:#fdfdfd; color:#4fa284">Send Link</button>
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