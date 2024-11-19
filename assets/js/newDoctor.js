$(document).ready(function () {
    Handlebars.registerHelper("isEqual", function (a, b) {
        return a === b;
    });

    //Dynamically creating category dropdown.
    loadCategories();

    function loadCategories() {
        $.ajax({
            url: "./controllers/categoriesServices.cfc?method=getCategories",
            method: "GET",
            dataType: "json",
            success: function (response) {
                // console.log(response.DATA);
                handlebarsCategory(response.DATA);
            },
            error: function (xhr, status, error) {
                console.error("Error loading categories:", error);
            },
        });
    }

    function handlebarsCategory(context) {
        $.get("./assets/templates/categoryNewDoctor.hbs", function (templateData) {
            var source = templateData;
            var template = Handlebars.compile(source);
            var html = template(context);
            $("#categoryDropDownNewDoc").html(html);
        });
    }

    //Handling new doctor submition.
    $(document).on("click", "#submitBtnNewDoctor", function (event) {
        event.preventDefault();

        if (!validateForm()) return;

        let $messageDiv = $("#messageDiv");

        let formData = {
            name: $("#yourName").val().trim(),
            email: $("#yourEmail").val().trim(),
            phone: $("#yourPhoneNumber").val().trim(),
            qualification: $("#yourQualification").val().trim(),
            category: $("#categorySelectNewDoc").val().trim(),
        };

        $.ajax({
            type: "POST",
            url: "./controllers/doctorsServices.cfc?method=createNewDoctorProfile",
            data: formData,
            dataType: "json",
            success: function (response) {
                // console.log(response);
                if (response.SESSIONAVAILABLE == false) {
                    alert("New login detected! You’ve been logged out for security.");
                    window.location.href = "./index.cfm?action=restart";
                }
                const isSuccess = response.SUCCESS;

                $messageDiv
                    .removeClass(isSuccess ? "alert-danger" : "alert-success")
                    .addClass(isSuccess ? "alert-success" : "alert-danger")
                    .html(response.MESSAGE);

                if (isSuccess) {
                    setTimeout(() => {
                        window.location.href = "./index.cfm?action=manageDoctors";
                    }, 3000);
                }
            },
            error: function (xhr, status, error) {
                console.warn("AJAX error: " + error);
            },
        });

        function validateForm() {
            const validators = [
                validateFullName,
                validateEmail,
                validatePhoneNumber,
                validateSpecialization,
                validateCategory,
            ];

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

        function validateField(selector, message, field = null, regex = null) {
            if ($(selector).length === 0) {
                console.warn(`Selector "${selector}" does not exist.`);
            }

            console.log(selector);

            const value = $(selector).val()?.trim();
            if (value === "" || value === undefined) {
                showError(selector, message);
                return false;
            }
            if (regex && !regex.test(value)) {
                showError(selector, `Please enter a valid ${field.toLowerCase()}`);
                return false;
            }
            showError(selector, "");
            return true;
        }

        function validateFullName() {
            return validateField("#yourName", "Please Enter Full Name");
        }

        function validateEmail() {
            const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return validateField("#yourEmail", "Please Enter Email Address", "Email Address", regex);
        }

        function validatePhoneNumber() {
            const regex = /^\d{10}$/;
            return validateField("#yourPhoneNumber", "Please Enter phone number", "phone number", regex);
        }

        function validateSpecialization() {
            return validateField("#yourQualification", "Please Enter Specialization");
        }

        function validateCategory() {
            return validateField("#categorySelectNewDoc", "Please Select Category");
        }
    });
});
