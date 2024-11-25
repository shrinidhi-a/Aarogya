$(document).ready(function () {
    Handlebars.registerHelper("lower", function (str) {
        if (typeof str === "string") {
            return str.toLowerCase();
        }
        return str;
    });

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

    function handlebarsAvailableAppointments(context) {
        $.get("./assets/templates/availableAppointmentReshedule.hbs", function (templateData) {
            var source = templateData;
            var template = Handlebars.compile(source);
            var html = template(context);
            $("#AvailableAppoitmentstoReshedule").html(html);
        });
    }

    handlebarsAvailableAppointments(context);

    const today = new Date();

    const formattedToday = today.toISOString().split("T")[0];
    const nextMonth = new Date();
    nextMonth.setMonth(today.getMonth() + 1);

    const tomorrow = new Date(today);
    tomorrow.setDate(today.getDate() + 1);
    const formattedTomorrow = tomorrow.toISOString().split("T")[0];

    if ($(".nav-link.active").attr("id") == undefined || $(".nav-link.active").attr("id") == "activeTab") {
        $("#dateTimeInputFilterList").attr("min", formattedToday);
    } else {
        $("#dateTimeInputFilterList").attr("max", formattedToday);
    }

    $("#dateTimeInputReschedule").attr("min", formattedTomorrow);
    nextMonth.setMonth(today.getMonth() + 1);
    const formattedNextMonth = nextMonth.toISOString().split("T")[0];
    $("#dateTimeInputReschedule").attr("max", formattedNextMonth);

    showAppointmentListActive();

    function handlebarsActiveAppointments(context) {
        $.get("./assets/templates/activeAppointments.hbs", function (templateData) {
            var source = templateData;
            var template = Handlebars.compile(source);
            var html = template(context);
            $("#appointmentsListNew").html(html);
        });
    }

    function showAppointmentListActive(status = "", order = "ascending", date = "") {
        let formData = {
            status: status,
            date: date,
        };

        // console.log(formData);

        $.ajax({
            type: "POST",
            url: "./controllers/appointmentServices.cfc?method=getAllAppointmentDetails",
            data: formData,
            dataType: "json",
            success: function (response) {
                console.log(response);
                let sortedActiveAppointments = getSortedAppointments(response.DATA, order);
                console.log(sortedActiveAppointments);
                handlebarsActiveAppointments(sortedActiveAppointments);

                for (const appointmentKey in sortedActiveAppointments) {
                    if (sortedActiveAppointments.hasOwnProperty(appointmentKey)) {
                        const appointment = sortedActiveAppointments[appointmentKey];
                        const key = appointment.APPOINTMENTID;
                        const status = appointment.APPOINTMENTSTATUS;
                        const actionPrefix = getActionPrefix(status);
                        console.log(actionPrefix);
                        // console.log(`${actionPrefix.action}_${key}`);

                        if (actionPrefix.actions) {
                            for (const action in actionPrefix.actions) {
                                if (actionPrefix.actions.hasOwnProperty(action)) {
                                    const actionid = actionPrefix.actions[action];

                                    console.log(`#${actionid}_${key}`);

                                    if (actionid == "reschedule") {
                                        $("#resheduleAppointmentAppontment").val(key);
                                        $("#resheduleAppointmentDoctor").val(appointment.DOCTOR.DOCTORID);
                                    }

                                    $(document)
                                        .off("click", `#${actionid}_${key}`)
                                        .on("click", `#${actionid}_${key}`, function (event) {
                                            event.preventDefault();
                                            handleAction(actionid, key, status);
                                        });
                                }
                            }
                        } else {
                            if (actionPrefix.action == "reschedule") {
                                $("#resheduleAppointmentAppontment").val(key);
                                $("#resheduleAppointmentDoctor").val(appointment.DOCTOR.DOCTORID);
                            }

                            $(document)
                                .off("click", `#${actionPrefix.action}_${key}`)
                                .on("click", `#${actionPrefix.action}_${key}`, function (event) {
                                    event.preventDefault();
                                    handleAction(actionPrefix.action, key, status);
                                });
                        }
                    }
                }
            },
            error: function (xhr, status, error) {
                console.warn("AJAX error: " + error);
            },
        });
    }

    function showAppointmentListHistory(status = "", order = "descending", date = "") {
        let formData = {
            status: status,
            date: date,
        };

        console.log(formData);

        $.ajax({
            type: "POST",
            url: "./controllers/appointmentServices.cfc?method=getAllPastAppointmentDetails",
            data: formData,
            dataType: "json",
            success: function (response) {
                console.log(response);
                let sortedPastAppointments = getSortedAppointments(response.DATA, order);
                handlebarsActiveAppointments(sortedPastAppointments);

                for (const appointmentKey in sortedPastAppointments) {
                    if (sortedPastAppointments.hasOwnProperty(appointmentKey)) {
                        const appointment = sortedPastAppointments[appointmentKey];
                        const key = appointment.APPOINTMENTID;
                        const status = appointment.APPOINTMENTSTATUS;
                        const actionPrefix = getActionPrefix(status);
                        console.log(actionPrefix);
                        // console.log(`${actionPrefix.action}_${key}`);

                        if (actionPrefix.actions) {
                            for (const action in actionPrefix.actions) {
                                if (actionPrefix.actions.hasOwnProperty(action)) {
                                    const actionid = actionPrefix.actions[action];

                                    // console.log(`#${actionid}_${key}`);
                                    if (actionid == "reschedule") {
                                        $("#resheduleAppointmentAppontment").val(key);
                                        $("#resheduleAppointmentDoctor").val(appointment.DOCTOR.DOCTORID);
                                    }

                                    $(document)
                                        .off("click", `#${actionid}_${key}`)
                                        .on("click", `#${actionid}_${key}`, function (event) {
                                            event.preventDefault();
                                            handleAction(actionid, key, status);
                                        });
                                }
                            }
                        } else {
                            if (actionPrefix.action == "reschedule") {
                                $("#resheduleAppointmentAppontment").val(key);
                                $("#resheduleAppointmentDoctor").val(appointment.DOCTOR.DOCTORID);
                            }

                            $(document)
                                .off("click", `#${actionPrefix.action}_${key}`)
                                .on("click", `#${actionPrefix.action}_${key}`, function (event) {
                                    event.preventDefault();
                                    handleAction(actionPrefix.action, key, status);
                                });
                        }
                    }
                }

                console.log(sortedPastAppointments);
            },
            error: function (xhr, status, error) {
                console.warn("AJAX error: " + error);
            },
        });
    }

    function getActionPrefix(status) {
        switch (status?.toLowerCase()) {
            case "confirmed":
                return { action: "confirmedCancel" };
            case "pending":
                return { actions: ["reschedule", "confirmedCancel"] };
            case "completed":
                return { action: "completedPrescription" };
            case "noshow":
                return { action: "reschedule" };
            default:
                return { action: "pendingCancel" };
            // return { actions: ["pendingReschedule", "pendingCancel"] };
        }
    }

    function handleAction(action, key, status) {
        switch (action) {
            case "confirmedCancel":
                cancelAppointment(key, status);
                break;
            case "completedPrescription":
                getPrescription(key, status);
                break;
            // case "cancelledReschedule":
            case "reschedule":
                resheduleAppointment(key, status);
                break;
            case "pendingCancel":
                cancelAppointment(key, status);
                break;
        }
    }

    function cancelAppointment(key, status) {
        console.log(`Cancel Appointment of ${key}`);

        const formData = {
            key: key,
        };

        $.ajax({
            type: "POST",
            url: "./controllers/appointmentServices.cfc?method=cancelAppointment",
            dataType: "json",
            data: formData,
            success: function (response) {
                if (response.SESSIONAVAILABLE == false) {
                    alert("New login detected! You’ve been logged out for security.");
                    window.location.href = "./index.cfm?action=restart";
                }
                if (response.SUCCESS) {
                    filterSubmit();
                } else {
                    console.log(response.MESSAGE);
                }
            },
            error: function (xhr, status, error) {
                console.warn("AJAX error: " + error);
            },
        });
    }

    $(document).on("click", "#submitBtnFilterActive", function (event) {
        event.preventDefault();
        filterSubmit();
    });

    function filterSubmit() {
        const selectedStatus = $("#statusSelect").val() || "";
        const selectedDate = $("#dateTimeInputFilterList").val() || "";

        console.log(selectedDate);

        var activeTab = $(".nav-link.active").attr("id");

        if (activeTab == undefined) activeTab = "activeTab";

        if (activeTab === "activeTab") {
            showAppointmentListActive(selectedStatus, "ascending", selectedDate);
        } else if (activeTab === "historyTab") {
            showAppointmentListHistory(selectedStatus, "descending", selectedDate);
        }
    }

    $(document).on("click", "#sortActive", function () {
        $(this).find(".sort-up").toggleClass("d-none");
        $(this).find(".sort-down").toggleClass("d-none");

        const selectedStatus = $("#statusSelect").val();
        const selectedDate = $("#dateTimeInputFilterList").val();
        var activeTab = $(".nav-link.active").attr("id");

        if (activeTab == undefined) activeTab = "activeTab";

        if (activeTab === "activeTab") {
            if ($(this).find(".sort-up").is(":visible")) {
                showAppointmentListActive(selectedStatus, "descending", selectedDate);
            } else {
                showAppointmentListActive(selectedStatus, "ascending", selectedDate);
            }
        } else if (activeTab === "historyTab") {
            if ($(this).find(".sort-up").is(":visible")) {
                showAppointmentListHistory(selectedStatus, "ascending");
            } else {
                showAppointmentListHistory(selectedStatus, "descending");
            }
        }
    });

    $("#activeTab").click(function (e) {
        e.preventDefault();
        $(".nav-link").removeClass("active");
        $(this).addClass("active");
        $("#dateTimeInputFilterList").attr("min", formattedToday);
        $("#dateTimeInputFilterList").removeAttr("max");
        showAppointmentListActive();
    });

    $("#historyTab").click(function (e) {
        e.preventDefault();
        $(".nav-link").removeClass("active");
        $(this).addClass("active");
        $("#dateTimeInputFilterList").attr("max", formattedToday);
        $("#dateTimeInputFilterList").removeAttr("min");
        showAppointmentListHistory();
    });

    function getSortedAppointments(data, order = "descending") {
        const appointmentsArray = Object.entries(data).map(([key, value]) => ({
            key,
            ...value,
        }));

        // Function to convert 12-hour time format (e.g., "11:00 AM") to a 24-hour format time
        function convertTo24Hour(timeStr) {
            const [time, modifier] = timeStr.split(" ");
            let [hours, minutes] = time.split(":").map(Number);

            if (modifier === "PM" && hours !== 12) {
                hours += 12;
            } else if (modifier === "AM" && hours === 12) {
                hours = 0;
            }

            return new Date(1970, 0, 1, hours, minutes); // Return time as Date object
        }

        // Sorting by full DATE (YYYY-MM-DD) and TIME
        appointmentsArray.sort((a, b) => {
            const dateA = new Date(`${a.DATE}T${convertTo24Hour(a.TIME).toISOString().slice(11, 19)}`);
            const dateB = new Date(`${b.DATE}T${convertTo24Hour(b.TIME).toISOString().slice(11, 19)}`);

            // If order is 'ascending', return the result of dateA - dateB
            return order === "ascending" ? dateA - dateB : dateB - dateA;
        });

        // Return as array (no need for reindexing)
        return appointmentsArray;
    }

    $(document).on("change", "#dateTimeInputReschedule", function (event) {
        const selectedDate = $("#dateTimeInputReschedule").val();
        if (selectedDate != "") {
            const selectedDoctor = $("#resheduleAppointmentDoctor").val().trim();

            console.log(selectedDoctor);

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
                                $("#selectedAppointmentReshedule").val(id);
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
    });

    $(document).on("click", "#submitBtnReshedule", function (event) {
        if (!validateForm()) return;

        const formData = {
            key: $("#resheduleAppointmentAppontment").val(),
            updatedScheduleDate: $("#dateTimeInputReschedule").val(),
            updatedScheduleTime: $("#selectedAppointmentReshedule").val(),
        };

        let $messageDivReschedule = $("#messageDivReschedule");

        $.ajax({
            type: "POST",
            url: "./controllers/appointmentServices.cfc?method=rescheduleAppointment",
            dataType: "json",
            data: formData,
            success: function (response) {
                // console.log(response);
                if (response.SESSIONAVAILABLE == false) {
                    alert("New login detected! You’ve been logged out for security.");
                    window.location.href = "./index.cfm?action=restart";
                }
                // appointmentDetails("pending");
                filterSubmit();
                const isSuccess = response.SUCCESS;
                $messageDivReschedule
                    .removeClass(isSuccess ? "alert-danger" : "alert-success")
                    .addClass(isSuccess ? "alert-success" : "alert-danger")
                    .html(response.MESSAGE);

                if (isSuccess) {
                    setTimeout(() => {
                        window.location.href = "./index.cfm?action=profile";
                    }, 3000);
                } else {
                    console.warn(response.MESSAGE);
                }
            },
            error: function (xhr, status, error) {
                console.warn("AJAX error: " + error);
            },
        });
    });

    function validateForm() {
        const validators = [validateDate, validateAppointmentTime];

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

    function validateAppointmentTime() {
        return validateField("#selectedAppointmentReshedule", "Please Select Appointment date");
    }

    function validateDate() {
        let dob = $("#dateTimeInputReschedule").val().trim();
        let dobDate = new Date(dob);

        if (isNaN(dobDate.getTime())) {
            showError("#dateTimeInputReschedule", "Please enter a valid date and time");
            return false;
        }

        let today = new Date();
        let maxDate = new Date(today.getTime() + 10 * 24 * 60 * 60 * 1000);

        if (dobDate < today) {
            showError("#dateTimeInputReschedule", "The date and time cannot be in the past");
            return false;
        }

        if (dobDate > maxDate) {
            showError("#dateTimeInputReschedule", "The date and time must be within the next 10 days");
            return false;
        }

        showError("#dateTimeInputReschedule", "");
        return true;
    }

    function getPrescription(key) {
        const formData = {
            appointmentID: key,
        };

        $.ajax({
            type: "POST",
            url: "./controllers/prescriptionService.cfc?method=getPrescriptionLinks",
            dataType: "json",
            data: formData,
            success: function (response) {
                console.log(response);
                if (response.SESSIONAVAILABLE == false) {
                    alert("New login detected! You’ve been logged out for security.");
                    window.location.href = "./index.cfm?action=restart";
                }
                if (response.SUCCESS) {
                    console.log(response.MESSAGE);

                    const basePath = `${window.location.protocol}//${
                        window.location.host
                    }${window.location.pathname.substring(0, window.location.pathname.lastIndexOf("/"))}`;

                    function downloadPrescription(path, fileName) {
                        downloadFile(`${basePath}/${path}`, fileName);
                    }

                    // Download both prescription files
                    downloadPrescription(response.PATH.generatedPrescription, "your-prescription-autogenerated.pdf");
                    downloadPrescription(response.PATH.uploadedPrescription, "your-prescription-uploaded.pdf");
                } else {
                    alert(response.MESSAGE);
                }
            },
            error: function (xhr, status, error) {
                console.warn("AJAX error: " + error);
            },
        });
    }

    function downloadFile(url, filename) {
        const link = document.createElement("a");
        link.href = url;
        link.download = filename;
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }
});
