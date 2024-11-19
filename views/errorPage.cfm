<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error</title>
</head>
<body style="font-family: Arial, sans-serif; background-color: #f8f9fa; color: #343a40; margin: 0; padding: 20px;">
    <div style="max-width: 600px; margin: 50px auto; padding: 20px; border: 1px solid #dee2e6; border-radius: 5px; background-color: #ffffff; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
        <h1 style="color: #dc3545;">Oops!</h1>
        <p>An unexpected error has occurred. Please try again later.</p>
        
        <h2>What to do next:</h2>
        <ul style="list-style-type: none; padding: 0;">
            <cfif structKeyExists(session, "isLoggedIn") AND session.isLoggedIn EQ true>
                <li><a href="./index.cfm?action=profile" style="color: #007bff; text-decoration: none;">Return to dashboard</a></li>
            <cfelse>
                <li><a href="./index.cfm?action=home" style="color: #007bff; text-decoration: none;">Return to Home</a></li>
            </cfif>
        </ul>
        
        <p style="margin-top: 20px;">If the problem persists, please reach out to our support team.</p>
    </div>
</body>
</html>
