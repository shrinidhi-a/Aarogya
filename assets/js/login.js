$(document).ready(function () {
    //login submition handling.
    $("#submitBtnLogin").on("click", function (event) {
        event.preventDefault();

        if (!validateForm()) return;

        let $messageDiv = $("#messageDiv");

        let formData = {
            email: $("#yourEmail").val().trim(),
            password: $("#yourPassword").val().trim(),
        };

        $.ajax({
            type: "POST",
            url: "./controllers/userServices.cfc?method=userLogin",
            data: formData,
            dataType: "json",
            success: function (response) {
                console.log(response);
                const isSuccess = response.SUCCESS;
                const userRole = response.USERROLE;
                const message = isSuccess ? "logged in successfully" : "log in failed: " + response.MESSAGE;
                $messageDiv
                    .removeClass(isSuccess ? "alert-danger" : "alert-success")
                    .addClass(isSuccess ? "alert-success" : "alert-danger")
                    .html(message)
                    .show();

                if (isSuccess && userRole == "admin") {
                    window.location.href = "./index.cfm?action=profile";
                } else {
                    window.location.href = "./index.cfm?action=landing";
                }
            },
            error: function (xhr, status, error) {
                console.warn("AJAX error: " + error);
            },
        });
    });

    function validateForm() {
        const validators = [validateEmail, validatePassword];
        const results = validators.map((validator) => validator());
        console.log(results);
        return results.every((result) => result);
    }

    function showError(field, message) {
        $(field)
            .next(".invalid-feedback")
            .text(message)
            .toggle(message !== "");
    }

    function validateEmail() {
        var email = $("#yourEmail").val().trim();
        var regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        if (email === "") {
            return showError("#yourEmail", "Please enter your email.");
        }
        if (!regex.test(email)) {
            return showError("#yourEmail", "Please enter a valid email address.");
        }

        showError("#yourEmail", "");
        return true;
    }

    function validatePassword() {
        var password = $("#yourPassword").val().trim();

        if (password === "") {
            return showError("#yourPassword", "Please enter your password!");
        }
        showError("#yourPassword", "");
        return true;
    }
});
