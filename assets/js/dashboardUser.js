$(document).ready(function () {
    $(`#exportDataMessage`).text("");

    // const today = new Date();
    // const formattedToday = today.toISOString().split("T")[0];
    // $("#dateTimeInputReschedule").attr("min", formattedToday);

    // // Calculate the date one month from today
    // const nextMonth = new Date();
    // nextMonth.setMonth(today.getMonth() + 1);
    // const formattedNextMonth = nextMonth.toISOString().split("T")[0];
    // $("#dateTimeInputReschedule").attr("max", formattedNextMonth);

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

    // function handlebarsAvailableAppointments(context) {
    //     $.get("./assets/templates/availableAppointmentReshedule.hbs", function (templateData) {
    //         var source = templateData;
    //         var template = Handlebars.compile(source);
    //         var html = template(context);
    //         $("#AvailableAppoitmentstoReshedule").html(html);
    //     });
    // }

    // handlebarsAvailableAppointments(context);

    //Handlebar to dynamically display appointments cards.
    function handlebarsAppointments(context) {
        $.get("./assets/templates/appointments.hbs", function (templateData) {
            var source = templateData;
            var template = Handlebars.compile(source);
            var html = template(context);
            $("#appointmentsList").html(html);
        });
    }

    //Function to get appointment details.
    function appointmentDetails(status) {
        const formData = { status };
        $.ajax({
            type: "POST",
            url: "./controllers/appointmentServices.cfc?method=getAppointmentDetails",
            dataType: "json",
            data: formData,
            success: function (response) {
                console.log(response);
                if (response.SUCCESS) {
                    if ($.isEmptyObject(response.DATA)) {
                        handlebarsAppointments(response.DATA);
                        $("#noAppointmentAvailable").text("No Appointments available");
                    } else {
                        const sortedAppointments = getSortedAppointments(response.DATA);
                        handlebarsAppointments(sortedAppointments);
                        $("#noAppointmentAvailable").text("");

                        for (const appointmentKey in sortedAppointments) {
                            if (sortedAppointments.hasOwnProperty(appointmentKey)) {
                                const appointment = sortedAppointments[appointmentKey];
                                const key = appointment.key;

                                // console.log(appointment.DOCTOR.DOCTORID);

                                $(`#prescriptionMessage_${key}`).text("");

                                const actionPrefix = getActionPrefix(status);

                                $(document)
                                    .off("click", `#displayAppointmentInfoBtn_${key}`)
                                    .on("click", `#displayAppointmentInfoBtn_${key}`, function (event) {
                                        event.preventDefault();
                                        $(`#displayAppointmentInfo_${key}`).toggleClass("d-none");
                                        $(`#displayAppointmentDateInfo_${key}`).toggleClass("d-none");
                                    });

                                $(document)
                                    .off("click", `#pendingReschedule_${key}`)
                                    .on("click", `#pendingReschedule_${key}`, function (event) {
                                        event.preventDefault();
                                        // console.log("Test");
                                        $("#resheduleAppointmentAppontment").val(key);
                                        $("#resheduleAppointmentDoctor").val(appointment.DOCTOR.DOCTORID);
                                    });

                                $(document)
                                    .off("click", `#cancelledReschedule_${key}`)
                                    .on("click", `#cancelledReschedule_${key}`, function (event) {
                                        event.preventDefault();
                                        // console.log("Test");
                                        $("#resheduleAppointmentAppontment").val(key);
                                        $("#resheduleAppointmentDoctor").val(appointment.DOCTOR.DOCTORID);
                                    });

                                // if (actionPrefix.actions) {
                                //     for (const action in actionPrefix.actions) {
                                //         if (actionPrefix.actions.hasOwnProperty(action)) {
                                //             const actionid = actionPrefix.actions[action];

                                //             $(document)
                                //                 .off("click", `#${actionid}_${key}`)
                                //                 .on("click", `#${actionid}_${key}`, function (event) {
                                //                     event.preventDefault();
                                //                     handleAction(actionid, key, status);
                                //                 });
                                //         }
                                //     }
                                // } else {
                                $(document)
                                    .off("click", `#${actionPrefix.action}_${key}`)
                                    .on("click", `#${actionPrefix.action}_${key}`, function (event) {
                                        event.preventDefault();
                                        handleAction(actionPrefix.action, key, status);
                                    });
                                // }
                            }
                        }
                    }
                } else {
                    console.log(response.MESSAGE);
                }
            },
            error: function (xhr, status, error) {
                console.warn("AJAX error: " + error);
            },
        });
    }

    function getActionPrefix(status) {
        switch (status) {
            case "completed":
                return { action: "completedPrescription" };
            case "confirmed":
                return { action: "confirmedCancel" };
            // case "cancelled":
            //     return { action: "cancelledReschedule" };
            default:
                return { action: "pendingCancel" };
            // return { actions: ["pendingReschedule", "pendingCancel"] };
        }
    }

    function handleAction(action, key, status) {
        switch (action) {
            case "completedPrescription":
                getPrescription(key, status);
                break;
            case "confirmedCancel":
                cancelAppointment(key, status);
                break;
            // case "cancelledReschedule":
            // case "pendingReschedule":
            //     resheduleAppointment(key, status);
            // break;
            case "pendingCancel":
                cancelAppointment(key, status);
                break;
        }
    }

    function getPrescription(key) {
        console.log(`Get prescription of ${key}`);

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
                    $(`#prescriptionMessage_${key}`).text(response.MESSAGE);
                }
            },
            error: function (xhr, status, error) {
                console.warn("AJAX error: " + error);
            },
        });
    }

    function cancelAppointment(key, status) {
        console.log(`Cancel Appointment of ${key}`);
        $(`#messageDivCancel_${key}`).removeClass("d-none");

        $(`#messageDivCancelNo_${key}`)
            .off("click")
            .on("click", function (event) {
                event.preventDefault();
                $(`#messageDivCancel_${key}`).addClass("d-none");
            });

        $(`#messageDivCancelYes_${key}`)
            .off("click")
            .on("click", function (event) {
                event.preventDefault();

                const formData = {
                    key: key,
                };

                $.ajax({
                    type: "POST",
                    url: "./controllers/appointmentServices.cfc?method=cancelAppointment",
                    dataType: "json",
                    data: formData,
                    success: function (response) {
                        // console.log(response);
                        if (response.SESSIONAVAILABLE == false) {
                            alert("New login detected! You’ve been logged out for security.");
                            window.location.href = "./index.cfm?action=restart";
                        }
                        if (response.SUCCESS) {
                            $(`#messageDivCancel_${key}`).addClass("d-none");
                            appointmentDetails(status);
                        } else {
                            console.log(response.MESSAGE);
                        }
                    },
                    error: function (xhr, status, error) {
                        console.warn("AJAX error: " + error);
                    },
                });
            });
    }

    // $(document).on("change", "#dateTimeInputReschedule", function (event) {
    //     const selectedDate = $("#dateTimeInputReschedule").val();
    //     if (selectedDate != "") {
    //         const selectedDoctor = $("#resheduleAppointmentDoctor").val().trim();

    //         console.log(selectedDoctor);

    //         let formData = {
    //             selectedDate: selectedDate,
    //             selectedDoctor: selectedDoctor,
    //         };

    //         $.ajax({
    //             url: "./controllers/appointmentServices.cfc?method=getBookedAppointments",
    //             method: "POST",
    //             data: formData,
    //             dataType: "json",
    //             success: function (response) {
    //                 handlebarsAvailableAppointments(response.DATA);
    //                 $(document).ready(function () {
    //                     let selectedButtonId = null;

    //                     context.APPOINTMENTS.forEach((appointment) => {
    //                         const id = appointment.ID;
    //                         $(document).off("click", `#selectAppointmentsBtn_${id}`);
    //                         $(document).on("click", `#selectAppointmentsBtn_${id}`, function (event) {
    //                             event.preventDefault();

    //                             if (selectedButtonId && selectedButtonId !== id) {
    //                                 $(`#selectAppointmentsBtn_${selectedButtonId}`)
    //                                     .removeClass("active btn-secondary")
    //                                     .addClass("btn-outline-secondary");
    //                             }

    //                             $(this).removeClass("btn-outline-secondary").addClass("active btn-secondary");
    //                             $("#selectedAppointmentReshedule").val(id);
    //                             selectedButtonId = id;
    //                         });
    //                     });
    //                 });
    //             },
    //             error: function (xhr, status, error) {
    //                 console.error("Error loading doctors:", error);
    //             },
    //         });
    //     }
    // });

    // $(document).on("click", "#submitBtnReshedule", function (event) {
    //     if (!validateForm()) return;

    //     const formData = {
    //         key: $("#resheduleAppointmentAppontment").val(),
    //         updatedScheduleDate: $("#dateTimeInputReschedule").val(),
    //         updatedScheduleTime: $("#selectedAppointmentReshedule").val(),
    //     };

    //     let $messageDivReschedule = $("#messageDivReschedule");

    //     $.ajax({
    //         type: "POST",
    //         url: "./controllers/appointmentServices.cfc?method=rescheduleAppointment",
    //         dataType: "json",
    //         data: formData,
    //         success: function (response) {
    //             // console.log(response);
    //             if (response.SESSIONAVAILABLE == false) {
    //                 alert("New login detected! You’ve been logged out for security.");
    //                 window.location.href = "./index.cfm?action=restart";
    //             }
    //             appointmentDetails("pending");
    //             const isSuccess = response.SUCCESS;
    //             $messageDivReschedule
    //                 .removeClass(isSuccess ? "alert-danger" : "alert-success")
    //                 .addClass(isSuccess ? "alert-success" : "alert-danger")
    //                 .html(response.MESSAGE);

    //             if (isSuccess) {
    //                 setTimeout(() => {
    //                     window.location.href = "./index.cfm?action=profile";
    //                 }, 3000);
    //             } else {
    //                 console.warn(response.MESSAGE);
    //             }
    //         },
    //         error: function (xhr, status, error) {
    //             console.warn("AJAX error: " + error);
    //         },
    //     });
    // });

    // function validateForm() {
    //     const validators = [validateDate, validateAppointmentTime];

    //     const results = validators.map((validator) => validator());
    //     console.log(results);
    //     return results.every((result) => result);
    // }

    // function showError(field, message) {
    //     $(field)
    //         .next(".invalid-feedback")
    //         .text(message)
    //         .toggle(message !== "")
    //         .show();
    // }

    // function validateField(selector, message) {
    //     if ($(selector).length === 0) {
    //         console.warn(`Selector "${selector}" does not exist.`);
    //     }

    //     const value = $(selector).val()?.trim();
    //     if (value === "" || value === undefined) {
    //         showError(selector, message);
    //         return false;
    //     }

    //     showError(selector, "");
    //     return true;
    // }

    // function validateAppointmentTime() {
    //     return validateField("#selectedAppointmentReshedule", "Please Select Appointment date");
    // }

    // function validateDate() {
    //     let dob = $("#dateTimeInputReschedule").val().trim();
    //     let dobDate = new Date(dob);

    //     if (isNaN(dobDate.getTime())) {
    //         showError("#dateTimeInputReschedule", "Please enter a valid date and time");
    //         return false;
    //     }

    //     let today = new Date();
    //     let maxDate = new Date(today.getTime() + 10 * 24 * 60 * 60 * 1000);

    //     if (dobDate < today) {
    //         showError("#dateTimeInputReschedule", "The date and time cannot be in the past");
    //         return false;
    //     }

    //     if (dobDate > maxDate) {
    //         showError("#dateTimeInputReschedule", "The date and time must be within the next 10 days");
    //         return false;
    //     }

    //     showError("#dateTimeInputReschedule", "");
    //     return true;
    // }

    // function resheduleAppointment(key, status) {
    //     console.log(`Reschedule Appointment of ${key}`);
    //     $(`#dateTimeInputCardContainer_${key}`).removeClass("d-none");

    //     $(`#dateTimeInputCardCancel_${key}`)
    //         .off("click")
    //         .on("click", function (event) {
    //             event.preventDefault();
    //             $(`#dateTimeInputCardContainer_${key}`).addClass("d-none");
    //         });

    //     $(`#dateTimeInputCardConfirm_${key}`)
    //         .off("click")
    //         .on("click", function (event) {
    //             event.preventDefault();

    //             let updatedSchedule = $(`#dateTimeInputCard_${key}`).val().trim();

    //             if (!validateDate(updatedSchedule, key)) return;

    // const formData = {
    //     key: key,
    //     updatedSchedule: updatedSchedule,
    // };

    // $.ajax({
    //     type: "POST",
    //     url: "./controllers/appointmentServices.cfc?method=rescheduleAppointment",
    //     dataType: "json",
    //     data: formData,
    //     success: function (response) {
    //         // console.log(response);
    //         if (response.SESSIONAVAILABLE == false) {
    //             alert("New login detected! You’ve been logged out for security.");
    //             window.location.href = "./index.cfm?action=restart";
    //         }
    //         if (response.SUCCESS) {
    //             $(`#dateTimeInputCardContainer_${key}`).addClass("d-none");
    //             appointmentDetails(status);
    //         } else {
    //             console.log(response.MESSAGE);
    //         }
    //     },
    //     error: function (xhr, status, error) {
    //         console.warn("AJAX error: " + error);
    //     },
    // });
    //         });
    // }

    // function showError(field, message) {
    //     $(field)
    //         .next(".invalid-feedback")
    //         .text(message)
    //         .toggle(message !== "")
    //         .show();
    // }

    // function validateDate(schedule, key) {
    //     let dobDate = new Date(schedule);

    //     if (isNaN(dobDate.getTime())) {
    //         showError(`#dateTimeInputCard_${key}`, "Please enter a valid date and time");
    //         return false;
    //     }

    //     let today = new Date();
    //     let maxDate = new Date(today.getTime() + 10 * 24 * 60 * 60 * 1000);

    //     if (dobDate < today) {
    //         showError(`#dateTimeInputCard_${key}`, "The date and time cannot be in the past");
    //         return false;
    //     }

    //     if (dobDate > maxDate) {
    //         showError(`#dateTimeInputCard_${key}`, "The date and time must be within the next 10 days");
    //         return false;
    //     }

    //     showError(`#dateTimeInputCard_${key}`, "");
    //     return true;
    // }

    function getSortedAppointments(data) {
        const appointmentsArray = Object.entries(data).map(([key, value]) => ({
            key,
            ...value,
        }));

        appointmentsArray.sort((a, b) => new Date(a.DATEANDTIME) - new Date(b.DATEANDTIME));

        const sortedAppointments = appointmentsArray.reduce((acc, appointment, index) => {
            const newKey = String(index + 1).padStart(2, "0");
            acc[newKey] = appointment;
            return acc;
        }, {});

        return sortedAppointments;
    }

    appointmentDetails("pending");

    $("#pending-tab").click(function (e) {
        e.preventDefault();
        $(".nav-link").removeClass("active");
        $(this).addClass("active");
        appointmentDetails("pending");
    });

    $("#confirmed-tab").click(function (e) {
        e.preventDefault();
        $(".nav-link").removeClass("active");
        $(this).addClass("active");
        appointmentDetails("confirmed");
    });

    $("#completed-tab").click(function (e) {
        e.preventDefault();
        $(".nav-link").removeClass("active");
        $(this).addClass("active");
        appointmentDetails("completed");
    });

    $("#cancelled-tab").click(function (e) {
        e.preventDefault();
        $(".nav-link").removeClass("active");
        $(this).addClass("active");
        appointmentDetails("cancelled");
    });

    $("#no-show-tab").click(function (e) {
        e.preventDefault();
        $(".nav-link").removeClass("active");
        $(this).addClass("active");
        appointmentDetails("NoShow");
    });

    //Handling export data button submition.
    $("#ExportData").on("click", function (event) {
        event.preventDefault();
        $.ajax({
            type: "POST",
            url: "./controllers/fileServices.cfc?method=generateXLS",
            dataType: "json",
            success: function (response) {
                // console.log(response);
                if (response.SESSIONAVAILABLE == false) {
                    alert("New login detected! You’ve been logged out for security.");
                    window.location.href = "./index.cfm?action=restart";
                }
                if (response.SUCCESS) {
                    downloadFile(
                        `${window.location.protocol}//${window.location.host}${window.location.pathname.substring(
                            0,
                            window.location.pathname.lastIndexOf("/")
                        )}${response.PATH}`,
                        "your-info.xlsx"
                    );
                    console.log(response.MESSAGE);
                } else {
                    console.warn(response.MESSAGE);
                }
            },
            error: function (xhr, status, error) {
                console.warn("AJAX error: " + error);
            },
        });
    });

    function downloadFile(url, filename) {
        const link = document.createElement("a");
        link.href = url;
        link.download = filename;
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }
});
