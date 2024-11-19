$(document).ready(function () {
    showConfirmedAppointment();
    showDoctorsList();
    loadCategories();

    const today = new Date();

    const formattedToday = today.toISOString().split("T")[0];
    $("#dateTimeInputFilter").attr("min", formattedToday);

    // Calculate the date one month from today
    const nextMonth = new Date();
    nextMonth.setMonth(today.getMonth() + 1);
    const formattedNextMonth = nextMonth.toISOString().split("T")[0];
    $("#dateTimeInputFilter").attr("max", formattedNextMonth);

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

    function handlebarsConfirmedCard(context) {
        $.get("./assets/templates/confirmedAppointment.hbs", function (templateData) {
            var source = templateData;
            var template = Handlebars.compile(source);
            var html = template(context);
            $("#confirmedAppointment").html(html);
        });
    }

    function handlebarsDoctorCards(context) {
        $.get("./assets/templates/doctorListCards.hbs", function (templateData) {
            var source = templateData;
            var template = Handlebars.compile(source);
            var html = template(context);
            $("#doctorCards").html(html);
        });
    }

    function handlebarsCategory(context) {
        $.get("./assets/templates/categoryFilter.hbs", function (templateData) {
            var source = templateData;
            var template = Handlebars.compile(source);
            var html = template(context);
            $("#categoryDropDownFilter").html(html);
        });
    }

    function showConfirmedAppointment() {
        $.ajax({
            type: "POST",
            url: "./controllers/appointmentServices.cfc?method=getUpcomingAppointment",
            dataType: "json",
            success: function (response) {
                console.log(response);
                if (response.SUCCESS) {
                    handlebarsConfirmedCard(response.DATA);
                    console.log(response);
                } else {
                    console.log(response.MESSAGE);
                }
            },
            error: function (xhr, status, error) {
                console.warn("AJAX error: " + error);
            },
        });
    }

    function showDoctorsList(date = "", category = "") {
        let formData = {
            date: date,
            category: category,
        };

        $.ajax({
            type: "POST",
            url: "./controllers/appointmentServices.cfc?method=getDoctorInformation",
            data: formData,
            dataType: "json",
            success: function (response) {
                console.log(response);
                handlebarsDoctorCards(response.DATA);

                let doctorData = response.DATA;

                for (const key in doctorData) {
                    if (doctorData.hasOwnProperty(key)) {
                        context.APPOINTMENTS.forEach((appointment) => {
                            const id = appointment.ID;
                            $(document).off("click", `#selectAppointmentsBtn_${id}_${key}`);
                            $(document).on("click", `#selectAppointmentsBtn_${id}_${key}`, function (event) {
                                event.preventDefault();
                                $(`#categoryIdDoctorList`).val(doctorData[key].CATEGOTYID);
                                $("#doctorIdDoctorList").val(key);
                                $("#dateTimeDoctorList").val(doctorData[key].DATE);
                                $("#startTimeDoctorList").val(id);
                            });
                        });
                    }
                }
            },
            error: function (xhr, status, error) {
                console.warn("AJAX error: " + error);
            },
        });
    }

    function loadCategories() {
        $.ajax({
            url: "./controllers/categoriesServices.cfc?method=getCategories",
            method: "GET",
            dataType: "json",
            success: function (response) {
                handlebarsCategory(response.DATA);
            },
            error: function (xhr, status, error) {
                console.error("Error loading categories:", error);
            },
        });
    }

    $(document).on("click", "#submitBtnFilter", function (event) {
        event.preventDefault();

        const selectedCategory = $("#categorySelectFilter").val();
        const selectedDate = $("#dateTimeInputFilter").val();

        // Normalize input: Check if the selected values are empty strings
        const isCategorySelected = selectedCategory && selectedCategory.trim() !== "";
        const isDateSelected = selectedDate && selectedDate.trim() !== "";

        // Pass parameters in correct order: date, category
        if (isCategorySelected && !isDateSelected) {
            showDoctorsList("", selectedCategory);
        } else if (!isCategorySelected && isDateSelected) {
            showDoctorsList(selectedDate, "");
        } else if (isCategorySelected && isDateSelected) {
            showDoctorsList(selectedDate, selectedCategory);
        } else {
            showDoctorsList("", "");
        }
    });

    $(document).on("click", "#submitBtnConfirmAppointment", function (event) {
        event.preventDefault();

        let formData = {
            category: $("#categoryIdDoctorList").val().trim(),
            doctor: $("#doctorIdDoctorList").val().trim(),
            dateAndTime: $("#dateTimeDoctorList").val().trim(),
            startTime: $("#startTimeDoctorList").val().trim(),
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
                window.location.href = "./index.cfm?action=landing";
            },
            error: function (xhr, status, error) {
                console.warn("AJAX error: " + error);
            },
        });
    });
});
