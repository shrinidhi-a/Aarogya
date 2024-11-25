$(document).ready(function () {
    // doctorDetails();

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
        $.get("./assets/templates/category.hbs", function (templateData) {
            var source = templateData;
            var template = Handlebars.compile(source);
            var html = template(context);
            $("#categoryDropDownManageDoctor").html(html);
        });
    }

    function handlebarsDoctorsList(context) {
        $.get("./assets/templates/doctorsCard.hbs", function (templateData) {
            var source = templateData;
            var template = Handlebars.compile(source);
            var html = template(context);
            $("#doctorsList").html(html);
        });
    }

    viewDoctors();
    function viewDoctors(category = "") {
        let formData = {
            category: category,
        };

        $.ajax({
            url: "./controllers/doctorsServices.cfc?method=getDoctors",
            method: "POST",
            data: formData,
            dataType: "json",
            success: function (response) {
                handlebarsDoctorsList(response.DATA);
                // console.log(response.DATA);
                const doctorsData = response.DATA;

                for (const key in doctorsData) {
                    if (doctorsData.hasOwnProperty(key)) {
                        console.log(key);
                        $(document)
                            .off("click", `#confirmedRemoveDoc_${key}`)
                            .on("click", `#confirmedRemoveDoc_${key}`, function (event) {
                                event.preventDefault();
                                $(`#messageDivRemoveDoc_${key}`).removeClass("d-none");
                            });

                        $(document)
                            .off("click", `#cancelRemoveDoc_${key}`)
                            .on("click", `#cancelRemoveDoc_${key}`, function (event) {
                                event.preventDefault();
                                $(`#messageDivRemoveDoc_${key}`).addClass("d-none");
                            });

                        $(document)
                            .off("click", `#confirmedUpdateDoc_${key}`)
                            .on("click", `#confirmedUpdateDoc_${key}`, function (event) {
                                event.preventDefault();
                                $(`#doctorInformationUpdateContainer_${key}`).removeClass("d-none");
                            });

                        $(document)
                            .off("click", `#submitBtnUpdateDoctor_${key}`)
                            .on("click", `#submitBtnUpdateDoctor_${key}`, function (event) {
                                event.preventDefault();
                                if (!validateForm(key)) return;

                                let formData = {
                                    key: key,
                                    name: $(`#yourNameDoctor_${key}`).val().trim(),
                                    email: $(`#yourEmailDoctor_${key}`).val().trim(),
                                    phone: $(`#yourPhoneNumberDoctor_${key}`).val().trim(),
                                    qualification: $(`#yourQualificationDoctor_${key}`).val().trim(),
                                };
                                updateDoctorDetails(formData, key);
                            });

                        $(document)
                            .off("click", `#confirmRemoveDoc_${key}`)
                            .on("click", `#confirmRemoveDoc_${key}`, function (event) {
                                event.preventDefault();
                                $(`#messageDivRemoveDoc_${key}`).addClass("d-none");
                                removeDoctorDetails(key, category);
                            });
                    }
                }
            },
            error: function (xhr, status, error) {
                console.error("Error loading doctors:", error);
            },
        });
    }

    $(document).on("change", "#categorySelect", function (event) {
        var selectedCategory = $(this).val();

        console.log("Selected Category:", selectedCategory);

        viewDoctors(selectedCategory);
    });

    function updateDoctorDetails(formData, key) {
        let $messageDiv = $(`#messageDivUpdateDoctorMadal_${key}`);

        $.ajax({
            type: "POST",
            url: "./controllers/doctorsServices.cfc?method=updateDoctorInfo",
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
    }

    function removeDoctorDetails(doctorId, selectedCategory) {
        let formData = {
            doctorId: doctorId,
        };

        $.ajax({
            type: "POST",
            url: "./controllers/doctorsServices.cfc?method=removeDoctorInfo",
            data: formData,
            dataType: "json",
            success: function (response) {
                // console.log(response);
                if (response.SESSIONAVAILABLE == false) {
                    alert("New login detected! You’ve been logged out for security.");
                    window.location.href = "./index.cfm?action=restart";
                }
                if (response.SUCCESS) {
                    window.location.href = "./index.cfm?action=manageDoctors";
                } else {
                    alert(response.MESSAGE);
                }
            },
            error: function (xhr, status, error) {
                console.warn("AJAX error: " + error);
            },
        });
    }

    function validateForm(key) {
        const validators = [
            () => validateFullName(key),
            () => validateEmail(key),
            () => validatePhoneNumber(key),
            () => validateSpecialization(key),
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

    function validateFullName(key) {
        return validateField(`#yourNameDoctor_${key}`, "Please Enter Full Name");
    }

    function validateEmail(key) {
        const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return validateField(`#yourEmailDoctor_${key}`, "Please Enter Email Address", "Email Address", regex);
    }

    function validatePhoneNumber(key) {
        const regex = /^\d{10}$/;
        return validateField(`#yourPhoneNumberDoctor_${key}`, "Please Enter phone number", "phone number", regex);
    }

    function validateSpecialization(key) {
        return validateField(`#yourQualificationDoctor_${key}`, "Please Enter Specialization");
    }
});
