$(document).ready(function () {
    $("#submitBtn").on("click", function (event) {
        event.preventDefault();

        const isAdmin = $("#yourRole").val().trim() === "admin";
        if ((isAdmin && !validateFormAdmin()) || (!isAdmin && !validateFormPatient())) return;

        let formData = {
            role: $("#yourRole").val().trim(),
            name: $("#yourName").val().trim(),
            email: $("#yourEmail").val().trim(),
            password: $("#yourPassword").val().trim(),
        };

        if (!isAdmin) {
            formData.dob = $("#yourDob").val().trim();
            formData.phoneNumber = $("#yourPhoneNumber").val().trim();
            formData.insuranceProvider = $("#yourInPr").val().trim();
            formData.insuranceCoverage = $("#yourInVal").val().trim();
        }

        let $messageDiv = $("#messageDiv");

        $.ajax({
            type: "POST",
            url: "./controllers/userServices.cfc?method=userRegistration",
            data: formData,
            dataType: "json",
            success: function (response) {
                const isSuccess = response.SUCCESS;
                const message = isSuccess ? "Registered successfully" : "Registration failed: " + response.MESSAGE;

                $messageDiv
                    .removeClass(isSuccess ? "alert-danger" : "alert-success")
                    .addClass(isSuccess ? "alert-success" : "alert-danger")
                    .html(message);

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

    $(document).on("change", "#yourRole", function (event) {
        var selectedCategory = $(this).val();
        if (selectedCategory == "admin") {
            $(`#dataOfBirthContainer`).addClass("d-none");
            $(`#phoneContainer`).addClass("d-none");
            $(`#insuranceProviderContainer`).addClass("d-none");
            $(`#insuranceCoverageContainer`).addClass("d-none");
        } else {
            $(`#dataOfBirthContainer`).removeClass("d-none");
            $(`#phoneContainer`).removeClass("d-none");
            $(`#insuranceProviderContainer`).removeClass("d-none");
            $(`#insuranceCoverageContainer`).removeClass("d-none");
        }
        console.log(selectedCategory);
    });

    function validateFormAdmin() {
        const validators = [validateFullName, validateEmail, validatePassword, validatePasswordMatch, validateCheckbox];

        const results = validators.map((validator) => validator());
        console.log(results);
        return results.every((result) => result);
    }

    function validateFormPatient() {
        const validators = [
            validateFullName,
            validateDOB,
            validateEmail,
            validatePhoneNumber,
            validateInsuranceProvider,
            validateInsuranceCoverage,
            validatePassword,
            validatePasswordMatch,
            validateCheckbox,
        ];

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
        const value = $(selector).val().trim();
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
        return validateField("#yourName", "Please Enter Full Name");
    }

    function validateDOB() {
        let dob = $("#yourDob").val().trim();
        let dobDate = new Date(dob);

        if (isNaN(dobDate.getTime())) {
            showError("#yourDob", "Please enter a valid date");
            return false;
        }

        let today = new Date();
        let age = today.getFullYear() - dobDate.getFullYear();
        let monthDifference = today.getMonth() - dobDate.getMonth();

        if (monthDifference < 0 || (monthDifference === 0 && today.getDate() < dobDate.getDate())) {
            age--;
        }

        if (age < 18) {
            showError("#yourDob", "You must be at least 18 years old");
            return false;
        }

        if (age > 130) {
            showError("#yourDob", "Please provide currect date of birth");
            return false;
        }

        showError("#yourDob", "");
        return true;
    }

    function validateEmail() {
        const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return validateField("#yourEmail", "Please Enter Email Address", regex);
    }

    function validatePhoneNumber() {
        const regex = /^\d{10}$/;
        return validateField("#yourPhoneNumber", "Enter phone number", regex);
    }

    function validateInsuranceProvider() {
        return validateField("#yourInPr", "Please Enter Insurance provider");
    }

    function validateInsuranceCoverage() {
        let doi = $("#yourInVal").val().trim();
        let doiDate = new Date(doi);

        if (isNaN(doiDate.getTime())) {
            showError("#yourInVal", "Please enter a valid date");
            return false;
        }

        let today = new Date();
        let ageOfInsurance = today.getFullYear() - doiDate.getFullYear();
        let monthDifference = today.getMonth() - doiDate.getMonth();

        if (monthDifference < 0 || (monthDifference === 0 && today.getDate() < doiDate.getDate())) {
            ageOfInsurance--;
        }

        if (ageOfInsurance > 130) {
            showError("#yourInVal", "Please provide currect coverage date");
            return false;
        }

        showError("#yourInVal", "");
        return true;
    }

    function validatePassword() {
        const regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]{8,}$/;
        if (
            !validateField(
                "#yourPassword",
                "password must be at least 8 characters long and include at least one lowercase letter, one uppercase letter, one digit, and one special character",
                regex
            )
        ) {
            return false;
        }
        return true;
    }

    function validatePasswordMatch() {
        const password = $("#yourPassword").val().trim();
        const confirmPassword = $("#confirmPassword").val().trim();
        if (confirmPassword === "") {
            showError("#confirmPassword", "Please Confirm password");
            return false;
        } else if (password !== confirmPassword) {
            showError("#confirmPassword", "Passwords do not match");
            return false;
        }
        showError("#confirmPassword", "");
        return true;
    }

    function validateCheckbox() {
        const isChecked = $("#acceptTerms").is(":checked");
        if (!isChecked) {
            showError("#acceptTermslabel", "Please accept terms and conditions");
        } else {
            showError("#acceptTermslabel", "");
        }
        return isChecked;
    }
});
