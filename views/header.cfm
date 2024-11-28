<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
  
    <title>Aarogya</title>
    <meta content="" name="description">
    <meta content="" name="keywords">
  
    <link href="./assets/img/favicon.png" rel="icon">
  
    <link href="https://fonts.gstatic.com" rel="preconnect">
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Nunito:300,300i,400,400i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
 
    <link href="./assets/css/style.css" rel="stylesheet">
    
    <!--handlebars--> 
    <script src="https://cdn.jsdelivr.net/npm/handlebars@4.7.7/dist/handlebars.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.10.377/pdf.min.js"></script>
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    
</head>

<nav class="navbar fixed-top navbar-expand-lg navbar-dark mx-5 border-bottom" style="background-color: #fdfdfd">
    <div class="container-fluid">
        <div class="d-flex align-items-center justify-content-between">
            <a class="navbar-brand d-flex align-items-center" href="./index.cfm?action=profile">
                <i class="bi bi-mortarboard-fill"></i>
                <h3 class="fst-italic mb-0 ms-2" style="color: black;">Aarogya</h3>
            </a>
        </div>

        <button class="navbar-toggler d-block d-md-none" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation" style="background-color: #4fa284">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Navbar links -->
        <cfif structKeyExists(session, "isLoggedIn") AND session.isLoggedIn EQ false >
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                
                <cfif NOT structKeyExists(url, "action") OR url.action NEQ "home">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                        <li class="nav-item">
                            <a class="nav-link active" aria-current="page"  style="color: #4fa284;" href="./index.cfm?action=home">Home</a>
                        </li>
                    </ul>
                </cfif>

            <cfif NOT structKeyExists(url, "action") OR url.action EQ "home">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page"  style="color: #4fa284;" href="#"></a>
                    </li>
                </ul>
                <!-- Login/Signup buttons -->
                <div class="d-flex">
                    <ul class="navbar-nav">   
                        <li class="nav-item mx-2" id="loginLink" style="">
                            <a href=./index.cfm?action=login style="text-decoration:none; color:black;">Login</a>
                        </li>

                        <li class="nav-item mx-3" id="signupLink" style="">
                            <a href=./index.cfm?action=register style="text-decoration:none; color:#4fa284;">Sign Up</a>
                        </li>

            </cfif>
                
        <cfelse>
            <cfif structKeyExists(session, "role") AND session.role == "patient" AND structKeyExists(url, "action") AND url.action NEQ "landing">

            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" style="color: #4fa284;" href="./index.cfm?action=landing">Go Back to Home</a>
                    </li>
                </ul>

            </cfif>

            <cfif structKeyExists(session, "role") AND session.role == "admin" AND structKeyExists(url, "action") AND url.action NEQ "profile">

                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                        <li class="nav-item">
                            <a class="nav-link active" aria-current="page" style="color: #4fa284;" href="./index.cfm?action=landing">Go Back to Home</a>
                        </li>
                    </ul>
                    
            </cfif>
                
                        <!--- <a class="nav-link d-flex align-items-center pe-0 mx-3" href="#" data-bs-toggle="dropdown">
                            <span class="d-none d-md-block dropdown-toggle ps-2" style="color: #4fa284; font-size: 1.2rem;"><cfoutput>#session.userFullname#</cfoutput></span>
                        </a> --->

                        <a class="nav-link d-none d-md-flex align-items-center pe-0 mx-3" href="#" data-bs-toggle="dropdown">
                            <cfif structKeyExists(session, "isLoggedIn")>
                                <span class="dropdown-toggle ps-2" style="color: #4fa284; font-size: 1.2rem;"><cfoutput>#session.userFullname#</cfoutput></span>
                            </cfif>
                        </a>
                
                        <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow mx-5">
                            <li class="dropdown-header">
                                <cfif structKeyExists(session, "isLoggedIn")>
                                    <h6 style="color: black;"><cfoutput>#session.userEmail#</cfoutput></h6>
                                </cfif>
                                <hr class="dropdown-divider">
                            </li>
                            <cfif structKeyExists(url, "action") AND url.action NEQ "myprofile">
                            <li>
                                <a href=./index.cfm?action=myprofile class="dropdown-item d-flex align-items-center" id="" style="color: #4fa284; cursor: pointer;">
                                    <i class="bi bi-box-arrow-right"></i>
                                    <span>My Profile</span>
                                </a>
                            </li> 
                            
                                <cfif structKeyExists(session, "isLoggedIn") AND session.isLoggedIn EQ true AND session.role == "patient">
                                    <li>
                                        <a class="dropdown-item d-flex align-items-center" id="ExportData" style="color: #4fa284; cursor: pointer;">
                                            <i class="bi bi-box-arrow-right"></i>
                                            <span>Export My Information</span>
                                        </a>
                                    </li> 
                                </cfif> 
                                <cfif structKeyExists(session, "isLoggedIn") AND session.isLoggedIn EQ true AND session.role == "admin">
                                    <li>
                                        <a href=./index.cfm?action=manageDoctors class="dropdown-item d-flex align-items-center" id="" style="color: #4fa284; cursor: pointer;">
                                            <i class="bi bi-box-arrow-right"></i>
                                            <span>Manage Doctors</span>
                                        </a>
                                    </li> 
                                    <li>
                                        <a href=./index.cfm?action=manageCategory class="dropdown-item d-flex align-items-center" id="" style="color: #4fa284; cursor: pointer;">
                                            <i class="bi bi-box-arrow-right"></i>
                                            <span>Manage Categories</span>
                                        </a>
                                    </li>
                                    <li>
                                        <a href=./index.cfm?action=manageUser class="dropdown-item d-flex align-items-center" id="" style="color: #4fa284; cursor: pointer;">
                                            <i class="bi bi-box-arrow-right"></i>
                                            <span>Manage Users</span>
                                        </a>
                                    </li>
                                    <li>
                                        <a href=./index.cfm?action=reports class="dropdown-item d-flex align-items-center" id="" style="color: #4fa284; cursor: pointer;">
                                            <i class="bi bi-box-arrow-right"></i>
                                            <span>Reports</span>
                                        </a>
                                    </li> 
                                </cfif> 
                            </cfif>
                            <li>
                                <a class="dropdown-item d-flex align-items-center" id="logoutLink" style="color: #4fa284; cursor: pointer;">
                                    <i class="bi bi-box-arrow-right"></i>
                                    <span>Log Out</span>
                                </a>
                            </li>                            
                        </ul>
                    </ul
        </cfif>
                </div>
            </div>
        </div>
    </nav>
    
  