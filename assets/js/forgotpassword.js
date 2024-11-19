$(document).ready(function () {
    //Forgot password page submit handler.
    $("#sendLink").on("click", function (event) {
        event.preventDefault();

        if (!validateForm()) return;

        let $messageDiv = $("#messageDiv");

        let formData = {
            email: $("#yourEmail").val().trim(),
        };

        $.ajax({
            type: "POST",
            url: "./controllers/userServices.cfc?method=forgotUser",
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
                    }, 5000);
                }
            },
            error: function (xhr, status, error) {
                console.warn("AJAX error: " + error);
            },
        });
    });

    function validateForm() {
        const validators = [validateEmail];
        const results = validators.map((validator) => validator());
        console.log(results);
        return results.every((result) => result);
    }

    function showError(field, message) {
        $(field)
            .next(".invalid-feedback")
            .text(message)
            .toggle(message !== "")
            .show();
    }

    function validateEmail() {
        var email = $("#yourEmail").val().trim();
        var regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (email === "") {
            showError("#yourEmail", "Please enter your email.");
            return false;
        } else if (!regex.test(email)) {
            showError("#yourEmail", "Please enter a valid email address.");
            return false;
        } else {
            showError("#yourEmail", "");
            return true;
        }
    }
});
