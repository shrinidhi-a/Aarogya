$(document).ready(function () {
    //Handlebars helper for equals.
    Handlebars.registerHelper("isEqual", function (a, b) {
        return a === b;
    });

    const today = new Date();
    const tomorrow = new Date(today);
    tomorrow.setDate(today.getDate() + 1);

    const formattedTomorrow = tomorrow.toISOString().split("T")[0];
    $("#dateTimeInput").attr("min", formattedTomorrow);

    // Calculate the date one month from today
    const nextMonth = new Date();
    nextMonth.setMonth(today.getMonth() + 1);
    const formattedNextMonth = nextMonth.toISOString().split("T")[0];
    $("#dateTimeInput").attr("max", formattedNextMonth);

    let context = {
        APPOINTMENTS: [
            { ID: "1", TIME: "09:00 AM", ISENABLED: true },
            { ID: "2", TIME: "10:00 AM", ISENABLED: true },
            { ID: "3", TIME: "11:00 AM", ISENABLED: true },
            { ID: "4", TIME: "12:00 PM", ISENABLED: true },
            { ID: "5", TIME: "02:00 PM", ISENABLED: true },
            { ID: "6", TIME: "03:00 PM", ISENABLED: true },
            { ID: "7", TIME: "04:00 PM", ISENABLED: true },
            { ID: "8", TIME: "05:00 PM", ISENABLED: true },
            { ID: "9", TIME: "06:00 PM", ISENABLED: true },
            { ID: "10", TIME: "07:00 PM", ISENABLED: true },
        ],
    };

    //Dynamically creating dropdowns for category and doctors.
    loadCategories();
    handlebarsDoctor();
    handlebarsAvailableAppointments(context);

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
            $("#categoryDropDown").html(html);
        });
    }

    function handlebarsDoctor(context) {
        $.get("./assets/templates/doctor.hbs", function (templateData) {
            var source = templateData;
            var template = Handlebars.compile(source);
            var html = template(context);
            $("#doctorDropDown").html(html);
        });
    }

    function handlebarsAvailableAppointments(context) {
        $.get("./assets/templates/availableAppointments.hbs", function (templateData) {
            var source = templateData;
            var template = Handlebars.compile(source);
            var html = template(context);
            $("#AvailableAppoitments").html(html);
        });
    }

    $(document).on("change", "#categorySelect", function (event) {
        var selectedCategory = $(this).val();

        console.log("Selected Category:", selectedCategory);

        let formData = {
            category: selectedCategory,
        };

        $.ajax({
            url: "./controllers/doctorsServices.cfc?method=getDoctors",
            method: "POST",
            data: formData,
            dataType: "json",
            success: function (response) {
                // console.log("Doctors Data:", response);
                handlebarsDoctor(response.DATA);
            },
            error: function (xhr, status, error) {
                console.error("Error loading doctors:", error);
            },
        });
    });

    $(document).on("change", "#dateTimeInput", function (event) {
        updateAvailableAppointments();
    });

    $(document).on("change", "#doctorSelect", function (event) {
        updateAvailableAppointments();
    });

    function updateAvailableAppointments() {
        const selectedDate = $("#dateTimeInput").val();
        console.log(selectedDate);
        if (selectedDate != "") {
            const selectedDoctor = $("#doctorSelect").val().trim();

            let formData = {
                selectedDate: selectedDate,
                selectedDoctor: selectedDoctor,
            };

            $.ajax({
                url: "./controllers/appointmentServices.cfc?method=getBookedAppointments",
                method: "POST",
                data: formData,
                dataType: "json",
                success: function (response) {
                    handlebarsAvailableAppointments(response.DATA);
                    $(document).ready(function () {
                        let selectedButtonId = null;

                        context.APPOINTMENTS.forEach((appointment) => {
                            const id = appointment.ID;
                            $(document).off("click", `#selectAppointmentsBtn_${id}`);
                            $(document).on("click", `#selectAppointmentsBtn_${id}`, function (event) {
                                event.preventDefault();

                                if (selectedButtonId && selectedButtonId !== id) {
                                    $(`#selectAppointmentsBtn_${selectedButtonId}`)
                                        .removeClass("active btn-secondary")
                                        .addClass("btn-outline-secondary");
                                }

                                $(this).removeClass("btn-outline-secondary").addClass("active btn-secondary");
                                $("#selectedAppointment").val(id);
                                selectedButtonId = id;
                            });
                        });
                    });
                },
                error: function (xhr, status, error) {
                    console.error("Error loading doctors:", error);
                },
            });
        }
    }

    //Handling new appointment button submition.
    $(document).on("click", "#submitBtnAppointment", function (event) {
        event.preventDefault();

        if (!validateForm()) return;

        let $messageDiv = $("#messageDiv");

        let formData = {
            category: $("#categorySelect").val().trim(),
            doctor: $("#doctorSelect").val().trim(),
            dateAndTime: $("#dateTimeInput").val().trim(),
            startTime: $("#selectedAppointment").val().trim(),
        };

        $.ajax({
            type: "POST",
            url: "./controllers/appointmentServices.cfc?method=createAppointment",
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
                        window.location.href = "./index.cfm?action=profile";
                    }, 3000);
                }
            },
            error: function (xhr, status, error) {
                console.warn("AJAX error: " + error);
            },
        });

        function validateForm() {
            const validators = [validateCategory, validateDoctor, validateDate, validateAppointmentTime];

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

        function validateField(selector, message) {
            if ($(selector).length === 0) {
                console.warn(`Selector "${selector}" does not exist.`);
            }

            const value = $(selector).val()?.trim();
            if (value === "" || value === undefined) {
                showError(selector, message);
                return false;
            }

            showError(selector, "");
            return true;
        }

        function validateCategory() {
            return validateField("#categorySelect", "Please Select Category");
        }

        function validateDoctor() {
            return validateField("#doctorSelect", "Please Select Category");
        }

        function validateAppointmentTime() {
            return validateField("#selectedAppointment", "Please Select Appointment date");
        }

        function validateDate() {
            let dob = $("#dateTimeInput").val().trim();
            let dobDate = new Date(dob);

            if (isNaN(dobDate.getTime())) {
                showError("#dateTimeInput", "Please enter a valid date and time");
                return false;
            }

            let today = new Date();
            let maxDate = new Date(today.getTime() + 10 * 24 * 60 * 60 * 1000);

            if (dobDate < today) {
                showError("#dateTimeInput", "The date and time cannot be in the past");
                return false;
            }

            if (dobDate > maxDate) {
                showError("#dateTimeInput", "The date and time must be within the next 10 days");
                return false;
            }

            showError("#dateTimeInput", "");
            return true;
        }
    });
});
