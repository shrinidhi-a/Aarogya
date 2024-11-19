<footer id="footer" class="footer 
  <cfif structKeyExists(url, "action") AND listFindNoCase("login,register,adminLogin,forgotpassword,resetPassword", url.action)>
    fixed-bottom
  </cfif>
">

<cfif structKeyExists(url, "action") AND listFindNoCase("home,login,register,adminLogin,forgotpassword,resetPassword", url.action)>
  <div class="copyright">
      &copy; Copyright <strong><span>Aarogya</span></strong>. All Rights Reserved
  </div>
</cfif>
    
</footer>


<script src="./assets/js/register.js"></script>
<script src="./assets/js/login.js"></script>
<script src="./assets/js/forgotpassword.js"></script>
<script src="./assets/js/resetPassword.js"></script>
<script src="./assets/js/header.js"></script>
<!--- <script src="./assets/js/sheduler.js"></script> --->
<cfif structKeyExists(session, "isLoggedIn") AND session.isLoggedIn EQ true>
  <script src="./assets/js/helpers.js"></script>
  <cfif structKeyExists(session, "isLoggedIn") AND session.role EQ "patient">
    <script src="./assets/js/dashboardUser.js"></script>
    <script src="./assets/js/newAppointment.js"></script>
    <script src="./assets/js/profileUser.js"></script>
    <script src="./assets/js/landing.js"></script>
    <script src="./assets/js/profile.js"></script>
  </cfif>
  <cfif structKeyExists(session, "isLoggedIn") AND session.role EQ "admin">
    <script src="./assets/js/dashboardAdmin.js"></script>
    <script src="./assets/js/newDoctor.js"></script>
    <script src="./assets/js/newCategory.js"></script>
    <script src="./assets/js/profileAdmin.js"></script>
    <script src="./assets/js/manageDoctors.js"></script>
    <script src="./assets/js/manageCategory.js"></script>
    <script src="./assets/js/reports.js"></script>
  </cfif>
</cfif>
