<main>
<cfif structKeyExists(session, "isLoggedIn") AND session.role == 'admin'>
    <div class="container">
      <section class="section register min-vh-100 d-flex flex-column align-items-center justify-content-center py-4 min-vw-90">
        <div class="container">
            <div class="row justify-content-center" id="adminProfileView"></div>
        </div>
      </section>
    </div>
<cfelse>
    <div class="container">
        <section class="section register min-vh-100 d-flex flex-column align-items-center justify-content-center py-4 min-vw-90">
            <div class="container">
                <div class="col justify-content-center" id="userProfileView"></div>
            </div>
        </section>
    </div>
</cfif>
</main>