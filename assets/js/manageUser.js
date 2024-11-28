$(document).ready(function () {
    function handlebarsUserList(context) {
        $.get("./assets/templates/usersCard.hbs", function (templateData) {
            var source = templateData;
            var template = Handlebars.compile(source);
            var html = template(context);
            $("#UserList").html(html);
        });
    }

    viewUsers();
    function viewUsers(email = "") {
        let formData = {
            email: email,
        };

        $.ajax({
            url: "./controllers/userServices.cfc?method=getAllUsers",
            method: "POST",
            data: formData,
            dataType: "json",
            success: function (response) {
                console.log(response);
                handlebarsUserList(response.DATA);
                // console.log(response.DATA);
                const UserData = response.DATA;

                for (const key in UserData) {
                    if (UserData.hasOwnProperty(key)) {
                        // Use a block-scoped variable to capture `key`
                        let UserKey = key;

                        $(document)
                            .off("click", `#submitBtnUpdateUser_${UserKey}`)
                            .on("click", `#submitBtnUpdateUser_${UserKey}`, function (event) {
                                event.preventDefault();

                                if (
                                    (UserData[key].USERROLE === "patient" && !validateFormPatient(UserKey)) ||
                                    (UserData[key].USERROLE !== "patient" && !validateFormAdmin(UserKey))
                                ) {
                                    return;
                                }

                                let formDataUpdate = {
                                    id: UserKey,
                                    name: $(`#yourName_${UserKey}`).val()?.trim() || "",
                                    email: $(`#yourEmail_${UserKey}`).val()?.trim() || "",
                                    originalEmail: UserData[key]?.EMAIL || "",
                                    role: UserData[key]?.USERROLE || "",
                                    dob: $(`#yourDob_${UserKey}`).val()?.trim() || "",
                                    phoneNumber: $(`#yourPhoneNumber_${UserKey}`).val()?.trim() || "",
                                    insuranceProvider: $(`#yourInPr_${UserKey}`).val()?.trim() || "",
                                    insuranceCoverage: $(`#yourInVal_${UserKey}`).val()?.trim() || "",
                                };

                                // if (UserData[key].USERROLE === "patient") {
                                //     Object.assign(formDataUpdate, {
                                //         dob: $(`#yourDob_${UserKey}`).val().trim(),
                                //         phoneNumber: $(`#yourPhoneNumber_${UserKey}`).val().trim(),
                                //         insuranceProvider: $(`#yourInPr_${UserKey}`).val().trim(),
                                //         insuranceCoverage: $(`#yourInVal_${UserKey}`).val().trim(),
                                //     });
                                // } else {
                                //     Object.assign(formDataUpdate, {
                                //         dob: "",
                                //         phoneNumber: "",
                                //         insuranceProvider: "",
                                //         insuranceCoverage: "",
                                //     });
                                // }

                                console.log(formDataUpdate);

                                updateUserDetails(formDataUpdate, UserKey);
                            });

                        $(document)
                            .off("click", `#confirmRemoveUser_${UserKey}`)
                            .on("click", `#confirmRemoveUser_${UserKey}`, function (event) {
                                event.preventDefault();

                                removeUserDetails(UserKey);
                            });
                    }
                }
            },
            error: function (xhr, status, error) {
                console.error("Error loading doctors:", error);
            },
        });
    }

    function updateUserDetails(formData, UserKey) {
        let $messageDiv = $(`#messageDivUpdateUserMadal_${UserKey}`);

        $.ajax({
            type: "POST",
            url: "./controllers/userServices.cfc?method=updateAnyUserInfo",
            data: formData,
            dataType: "json",
            success: function (response) {
                console.log(response);
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
                        window.location.href = "./index.cfm?action=manageUser";
                    }, 3000);
                }
            },
            error: function (xhr, status, error) {
                console.warn("AJAX error: " + error);
            },
        });
    }

    function removeUserDetails(UserKey) {
        let formData = {
            UserKey: UserKey,
        };

        $.ajax({
            type: "POST",
            url: "./controllers/userServices.cfc?method=removeUserInfo",
            data: formData,
            dataType: "json",
            success: function (response) {
                // console.log(response);
                if (response.SESSIONAVAILABLE == false) {
                    alert("New login detected! You’ve been logged out for security.");
                    window.location.href = "./index.cfm?action=restart";
                }
                if (response.SUCCESS) {
                    window.location.href = "./index.cfm?action=manageUser";
                } else {
                    alert(response.MESSAGE);
                }
            },
            error: function (xhr, status, error) {
                console.warn("AJAX error: " + error);
            },
        });
    }

    $(document).on("click", "#userSearchBtn", function (event) {
        event.preventDefault();
        const searchstring = $(`#userSerchInput`).val()?.trim() || "";
        viewUsers(searchstring);
        console.log(searchstring);
    });

    function validateFormPatient(key) {
        const validators = [
            () => validateFullName(key),
            () => validateDOB(key),
            () => validateEmail(key),
            () => validatePhoneNumber(key),
            () => validateInsuranceProvider(key),
            () => validateInsuranceCoverage(key),
        ];

        const results = validators.map((validator) => validator());
        console.log(results);
        return results.every((result) => result);
    }

    function validateFormAdmin(key) {
        const validators = [() => validateFullName(key), () => validateEmail(key)];

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
        return validateField(`#yourName_${key}`, "Please Enter Full Name");
    }

    function validateDOB(key) {
        let dob = $(`#yourDob_${key}`).val().trim();
        let dobDate = new Date(dob);

        if (isNaN(dobDate.getTime())) {
            showError(`#yourDob_${key}`, "Please enter a valid date");
            return false;
        }

        let today = new Date();
        let age = today.getFullYear() - dobDate.getFullYear();
        let monthDifference = today.getMonth() - dobDate.getMonth();

        if (monthDifference < 0 || (monthDifference === 0 && today.getDate() < dobDate.getDate())) {
            age--;
        }

        if (age < 18) {
            showError(`#yourDob_${key}`, "You must be at least 18 years old");
            return false;
        }

        if (age > 130) {
            showError(`#yourDob_${key}`, "Please provide currect date of birth");
            return false;
        }

        showError(`#yourDob_${key}`, "");
        return true;
    }

    function validateEmail(key) {
        const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return validateField(`#yourEmail_${key}`, "Please Enter Email Address", regex);
    }

    function validatePhoneNumber(key) {
        const regex = /^\d{10}$/;
        return validateField(`#yourPhoneNumber_${key}`, "Enter phone number", regex);
    }

    function validateInsuranceProvider(key) {
        return validateField(`#yourInPr_${key}`, "Please Enter Insurance provider");
    }

    function validateInsuranceCoverage(key) {
        let doi = $(`#yourInVal_${key}`).val().trim();
        let doiDate = new Date(doi);

        if (isNaN(doiDate.getTime())) {
            showError(`#yourInVal_${key}`, "Please enter a valid date");
            return false;
        }

        let today = new Date();
        let ageOfInsurance = today.getFullYear() - doiDate.getFullYear();
        let monthDifference = today.getMonth() - doiDate.getMonth();

        if (monthDifference < 0 || (monthDifference === 0 && today.getDate() < doiDate.getDate())) {
            ageOfInsurance--;
        }

        if (ageOfInsurance > 130) {
            showError(`#yourInVal_${key}`, "Please provide currect coverage date");
            return false;
        }

        showError(`#yourInVal_${key}`, "");
        return true;
    }
});
