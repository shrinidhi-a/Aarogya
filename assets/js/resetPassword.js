$(document).ready(function () {
    $("#resetButton").on("click", function (event) {
        event.preventDefault();

        if (!validateForm()) return;

        let $messageDiv = $("#messageDiv");

        let formData = {
            password: $("#yourPassword").val().trim(),
            token: $("#token").val(),
        };

        $.ajax({
            type: "POST",
            url: "./controllers/userServices.cfc?method=resetUser",
            data: formData,
            dataType: "json",
            success: function (response) {
                const isSuccess = response.SUCCESS;
                $messageDiv
                    .removeClass(isSuccess ? "alert-danger" : "alert-success")
                    .addClass(isSuccess ? "alert-success" : "alert-danger")
                    .html(response.MESSAGE)
                    .show();

                if (isSuccess) {
                    setTimeout(() => {
                        window.location.href = "./index.cfm?action=login";
                    }, 3000);
                }
            },
            error: function (xhr, status, error) {
                console.warn("AJAX error: " + error);
            },
        });
    });

    function validateForm() {
        const validators = [validatePassword, validatePasswordMatch];
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

    function validatePassword() {
        var password = $("#yourPassword").val().trim();
        var regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]{8,}$/;
        if (password === "") {
            showError("#yourPassword", "Please Enter Password");
            return false;
        } else if (!regex.test(password)) {
            showError(
                "#yourPassword",
                "Password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, one digit, and one special character."
            );
            return false;
        } else {
            showError("#yourPassword", "");
            return true;
        }
    }

    function validatePasswordMatch() {
        var password = $("#yourPassword").val().trim();
        var confirmPassword = $("#confirmPassword").val().trim();
        if (confirmPassword === "") {
            showError("#confirmPassword", "Please Confirm password");
            return false;
        } else if (password !== confirmPassword) {
            showError("#confirmPassword", "Passwords do not match");
            return false;
        } else {
            showError("#confirmPassword", "");
            return true;
        }
    }
});
