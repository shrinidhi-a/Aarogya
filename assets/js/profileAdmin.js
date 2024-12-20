$(document).ready(function () {
    profileDetails();

    function handlebars(context) {
        $.get("./assets/templates/adminProfile.hbs", function (templateData) {
            var source = templateData;
            var template = Handlebars.compile(source);
            var html = template(context);
            $("#adminProfileView").html(html);
        });
    }

    function profileDetails() {
        $.ajax({
            type: "POST",
            url: "./controllers/adminServices.cfc?method=getAdminDetails",
            dataType: "json",
            success: function (response) {
                // console.log(response);
                if (response.SUCCESS) {
                    handlebars(response.DATA);
                } else {
                    console.log(response.MESSAGE);
                }
            },
            error: function (xhr, status, error) {
                console.warn("AJAX error: " + error);
            },
        });
    }

    $(document).on("click", "#submitBtntoUpdate", function (event) {
        event.preventDefault();

        if (!validateFormBasicInfo()) return;

        let $messageDiv = $("#messageDivBasic");

        let formData = {
            name: $("#yourNametoUpdate").val().trim(),
            email: $("#yourEmailtoUpdate").val().trim(),
        };

        console.log(formData);

        $.ajax({
            type: "POST",
            url: "./controllers/adminServices.cfc?method=updateAdminBasicInfo",
            data: formData,
            dataType: "json",
            success: function (response) {
                if (response.SESSIONAVAILABLE == false) {
                    alert("New login detected! You’ve been logged out for security.");
                    window.location.href = "./index.cfm?action=restart";
                }

                console.log(response);

                // const isSuccess = response.SUCCESS;
                // const message = isSuccess
                //     ? "Information Updated successfully"
                //     : "Information Update failed: " + response.MESSAGE;

                // $messageDiv
                //     .removeClass(isSuccess ? "alert-danger" : "alert-success")
                //     .addClass(isSuccess ? "alert-success" : "alert-danger")
                //     .html(message);

                // if (isSuccess) {
                alert(response.MESSAGE);
                // setTimeout(() => {
                window.location.href = "./index.cfm?action=profile";
                // }, 3000);
                // }else{

                // }
            },
            error: function (xhr, status, error) {
                console.warn("AJAX error: " + error);
            },
        });
    });

    $(document).on("click", "#submitBtnPasswordUpdate", function (event) {
        event.preventDefault();

        if (!validateFormPasswordInfo()) return;

        let $messageDiv = $("#messageDivPassword");

        let formData = {
            oldpassword: $("#oldPasswordInput").val().trim(),
            newpassword: $("#newPasswordInput").val().trim(),
            reenterpassword: $("#reenterPasswordInput").val().trim(),
        };

        $.ajax({
            type: "POST",
            url: "./controllers/adminServices.cfc?method=updatePassword",
            data: formData,
            dataType: "json",
            success: function (response) {
                if (response.SESSIONAVAILABLE == false) {
                    alert("New login detected! You’ve been logged out for security.");
                    window.location.href = "./index.cfm?action=restart";
                }
                const isSuccess = response.SUCCESS;
                // const message = isSuccess
                //     ? "Password Updated successfully"
                //     : "Password Update failed: " + response.MESSAGE;

                // $messageDiv
                //     .removeClass(isSuccess ? "alert-danger" : "alert-success")
                //     .addClass(isSuccess ? "alert-success" : "alert-danger")
                //     .html(message);

                if (isSuccess) {
                    alert(response.MESSAGE);
                    // setTimeout(() => {
                    window.location.href = "./index.cfm?action=profile";
                    // }, 3000);
                }
            },
            error: function (xhr, status, error) {
                console.warn("AJAX error: " + error);
            },
        });
    });

    function validateFormBasicInfo() {
        const validators = [validateFullName, validateEmail];

        const results = validators.map((validator) => validator());
        console.log(results);
        return results.every((result) => result);
    }

    function validateFormPasswordInfo() {
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

    function validateField(selector, message, regex = null) {
        if ($(selector).length === 0) {
            console.warn(`Selector "${selector}" does not exist.`);
        }

        console.log(selector);

        const value = $(selector).val()?.trim();
        if (value === "") {
            showError(selector, message);
            return false;
        }
        if (regex && !regex.test(value)) {
            showError(selector, `Please enter a valid ${message.toLowerCase()}`);
            return false;
        }
        showError(selector, "");
        return true;
    }

    function validateFullName() {
        return validateField("#yourNametoUpdate", "Please Enter Full Name");
    }

    function validateEmail() {
        const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return validateField("#yourEmailtoUpdate", "Please Enter Email Address", regex);
    }

    function validatePassword() {
        const regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]{8,}$/;
        const message =
            "password must be at least 8 characters long and include at least one lowercase letter, one uppercase letter, one digit, and one special character";
        if (!validateField("#oldPasswordInput", message, regex)) {
            return false;
        }
        if (!validateField("#newPasswordInput", message, regex)) {
            return false;
        }
        if (!validateField("#reenterPasswordInput", message, regex)) {
            return false;
        }
        return true;
    }

    function validatePasswordMatch() {
        const password = $("#newPasswordInput").val().trim();
        const confirmPassword = $("#reenterPasswordInput").val().trim();
        if (confirmPassword === "") {
            showError("#reenterPasswordInput", "Please Confirm password");
            return false;
        } else if (password !== confirmPassword) {
            showError("#reenterPasswordInput", "Passwords do not match");
            return false;
        }
        showError("#confirmPassword", "");
        return true;
    }
});
