$(document).ready(function () {
    //Generating dynamic Appointment cards.
    function handlebarsAppointments(context) {
        $.get("./assets/templates/appointmentsAdmin.hbs", function (templateData) {
            var source = templateData;
            var template = Handlebars.compile(source);
            var html = template(context);
            $("#appointmentsForAdmin").html(html);
        });
    }

    function handlebarsNotification(context) {
        $.get("./assets/templates/notificationAdmin.hbs", function (templateData) {
            var source = templateData;
            var template = Handlebars.compile(source);
            var html = template(context);
            $("#notificationButtonAdmin").html(html);
        });
    }

    getAdminNotification();

    function getAdminNotification() {
        $.ajax({
            type: "POST",
            url: "./controllers/appointmentServices.cfc?method=getNotificationData",
            dataType: "json",
            success: function (response) {
                console.log(response);
                handlebarsNotification(response.DATA);
            },
            error: function (xhr, status, error) {
                console.warn("AJAX error: " + error);
            },
        });
    }

    //Getting appointment details.
    function appointmentDetails(status) {
        const formData = { status };

        $.ajax({
            type: "POST",
            url: "./controllers/appointmentServices.cfc?method=getAppointmentDetailsForAdmin",
            dataType: "json",
            data: formData,
            success: function (response) {
                // console.log(response);

                if (response.SUCCESS) {
                    if ($.isEmptyObject(response.DATA)) {
                        handlebarsAppointments(response.DATA);
                        $("#noAppointmentAvailableVerify").text("No Appointments available");
                    } else {
                        const sortedAppointments = getSortedAppointments(response.DATA);
                        handlebarsAppointments(sortedAppointments);
                        $("#noAppointmentAvailableVerify").text("");

                        for (const appointmentKey in sortedAppointments) {
                            if (sortedAppointments.hasOwnProperty(appointmentKey)) {
                                const appointment = sortedAppointments[appointmentKey];
                                console.log(appointment);
                                const key = appointment.key;
                                const doctorID = appointment.DOCTOR.ID;
                                const patientID = appointment.USER.ID;
                                const patientname = appointment.USER.FULLNAME;
                                const patientEmail = appointment.USER.EMAIL;
                                const appointmentDate = appointment.DATE;
                                const appointmentTime = appointment.TIME;

                                const actionPrefix = getActionPrefix(status);

                                $(document)
                                    .off("click", `#displayAppointmentInfoBtn_${key}`)
                                    .on("click", `#displayAppointmentInfoBtn_${key}`, function (event) {
                                        event.preventDefault();
                                        $(`#displayAppointmentInfo_${key}`).toggleClass("d-none");
                                        $(`#displayAppointmentDateInfo_${key}`).toggleClass("d-none");
                                    });

                                $(document)
                                    .off("click", `#updatePrescription_${key}`)
                                    .on("click", `#updatePrescription_${key}`, function (event) {
                                        event.preventDefault();
                                        // console.log("Test");
                                        $("#addPrescriptioAppointmentId").val(key);
                                        $("#addPrescriptionDoctorId").val(doctorID);
                                        $("#addPrescriptionPatientId").val(patientID);
                                        $("#addPrescriptionPatientEmail").val(patientEmail);
                                    });

                                if (actionPrefix.actions) {
                                    for (const action in actionPrefix.actions) {
                                        if (actionPrefix.actions.hasOwnProperty(action)) {
                                            const actionid = actionPrefix.actions[action];

                                            $(document)
                                                .off("click", `#${actionid}_${key}`)
                                                .on("click", `#${actionid}_${key}`, function (event) {
                                                    event.preventDefault();
                                                    handleAction(
                                                        actionid,
                                                        key,
                                                        status,
                                                        doctorID,
                                                        patientID,
                                                        patientname,
                                                        patientEmail,
                                                        appointmentDate,
                                                        appointmentTime
                                                    );
                                                });
                                        }
                                    }
                                } else {
                                    if (actionPrefix.action != "") {
                                        $(document)
                                            .off("click", `#${actionPrefix.action}_${key}`)
                                            .on("click", `#${actionPrefix.action}_${key}`, function (event) {
                                                event.preventDefault();
                                                handleAction(
                                                    actionPrefix.action,
                                                    key,
                                                    status,
                                                    doctorID,
                                                    patientID,
                                                    patientname,
                                                    patientEmail,
                                                    appointmentDate,
                                                    appointmentTime
                                                );
                                            });
                                    }
                                }
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

    appointmentDetails("pending");

    //Handling tabs in the admin profile page.
    $("#requests-tab").click(function (e) {
        e.preventDefault();
        $(".nav-link").removeClass("active");
        $(this).addClass("active");
        appointmentDetails("pending");
        getAdminNotification();
    });

    $("#confirmedApp-tab").click(function (e) {
        e.preventDefault();
        $(".nav-link").removeClass("active");
        $(this).addClass("active");
        appointmentDetails("confirmed");
        getAdminNotification();
    });

    $("#completedApp-tab").click(function (e) {
        e.preventDefault();
        $(".nav-link").removeClass("active");
        $(this).addClass("active");
        appointmentDetails("completed");
        getAdminNotification();
    });

    $("#concelledApp-tab").click(function (e) {
        e.preventDefault();
        $(".nav-link").removeClass("active");
        $(this).addClass("active");
        appointmentDetails("cancelled");
        getAdminNotification();
    });

    $("#no-show-tab").click(function (e) {
        e.preventDefault();
        $(".nav-link").removeClass("active");
        $(this).addClass("active");
        appointmentDetails("NoShow");
        getAdminNotification();
    });

    //Sorting the appointment list to display in the admin profile page.
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

    function getActionPrefix(status) {
        switch (status) {
            // case "completed":
            //     return { action: "updatePrescription" };
            case "confirmed":
                return { actions: ["confirmedCancel", "confirmedComplete", "confirmedNoShow", "confirmedNotify"] };
            case "cancelled":
                return { action: "" };
            default:
                return { actions: ["pendingAccept", "pendingReject"] };
        }
    }

    function handleAction(
        action,
        key,
        status,
        // doctorID,
        // patientID,
        patientname,
        patientEmail,
        appointmentDate,
        appointmentTime
    ) {
        switch (action) {
            // case "updatePrescription":
            //     updatePrescription(key, status, doctorID, patientID, patientname, patientEmail);
            //     break;
            case "confirmedCancel":
            case "pendingReject":
                cancelAppointment(key, status, patientname, patientEmail);
                break;
            case "confirmedComplete":
                completeAppointment(key, status);
                break;
            case "pendingAccept":
                acceptAppointment(key, status, patientname, patientEmail);
                break;
            case "confirmedNoShow":
                makeNoShowAppointment(key, status, patientname, patientEmail);
                break;
            case "confirmedNotify":
                notifyPatientsForAppontment(key, status, patientname, patientEmail, appointmentDate, appointmentTime);
                break;
        }
    }

    // //Function to update the prescription.
    // function updatePrescription(key, status, doctorID, patientID, patientname, patientEmail) {
    //     console.log(`update prescription of ${key}`);
    //     $(`#prescriptionCardContainer_${key}`).removeClass("d-none");

    //     $(`#prescriptionCardCancel_${key}`)
    //         .off("click")
    //         .on("click", function (event) {
    //             event.preventDefault();
    //             $(`#prescriptionCardContainer_${key}`).addClass("d-none");
    //         });

    //     $(`#prescriptionCardConfirm_${key}`)
    //         .off("click")
    //         .on("click", function (event) {
    //             event.preventDefault();

    //             let prescription = $(`#prescription_${key}`).val().trim();

    //             const formData = {
    //                 key: key,
    //                 prescription: prescription,
    //                 doctorID: doctorID,
    //                 patientID: patientID,
    //                 patientName: patientname,
    //                 patientEmail: patientEmail,
    //             };

    //             $.ajax({
    //                 type: "POST",
    //                 url: "./controllers/prescriptionService.cfc?method=createPrescription",
    //                 dataType: "json",
    //                 data: formData,
    //                 success: function (response) {
    //                     if (response.SESSIONAVAILABLE == false) {
    //                         alert("New login detected! You’ve been logged out for security.");
    //                         window.location.href = "./index.cfm?action=restart";
    //                     }
    //                     if (response.SUCCESS) {
    //                         $(`#prescriptionCardContainer_${key}`).addClass("d-none");
    //                         alert(response.MESSAGE);
    //                         appointmentDetails(status);
    //                     } else {
    //                         console.log(response.MESSAGE);
    //                     }
    //                 },
    //                 error: function (xhr, status, error) {
    //                     console.warn("AJAX error: " + error);
    //                 },
    //             });
    //         });
    // }

    //Function to mark the appointment as complete.
    function completeAppointment(key, status) {
        console.log(`Complete Appointment of ${key}`);
        $(`#messageDivComplete_${key}`).removeClass("d-none");

        $(`#messageDivCompleteNo_${key}`)
            .off("click")
            .on("click", function (event) {
                event.preventDefault();
                $(`#messageDivComplete_${key}`).addClass("d-none");
            });

        $(`#messageDivCompleteYes_${key}`)
            .off("click")
            .on("click", function (event) {
                event.preventDefault();

                const formData = {
                    key: key,
                };

                $.ajax({
                    type: "POST",
                    url: "./controllers/appointmentServices.cfc?method=completeAppointment",
                    dataType: "json",
                    data: formData,
                    success: function (response) {
                        // console.log(response);
                        if (response.SESSIONAVAILABLE == false) {
                            alert("New login detected! You’ve been logged out for security.");
                            window.location.href = "./index.cfm?action=restart";
                        }
                        if (response.SUCCESS) {
                            $(`#messageDivComplete_${key}`).addClass("d-none");
                            appointmentDetails(status);
                            getAdminNotification();
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

    //Function to mark the appointment as no show.
    function makeNoShowAppointment(key, status, patientname, patientEmail) {
        $(`#messageDivNoShow_${key}`).removeClass("d-none");

        $(`#messageDivNoShowNo_${key}`)
            .off("click")
            .on("click", function (event) {
                event.preventDefault();
                $(`#messageDivNoShow_ ${key}`).addClass("d-none");
            });

        $(`#messageDivNoShowYes_${key}`)
            .off("click")
            .on("click", function (event) {
                event.preventDefault();

                const formData = {
                    key: key,
                    patientname: patientname,
                    patientEmail: patientEmail,
                };

                $.ajax({
                    type: "POST",
                    url: "./controllers/appointmentServices.cfc?method=noshowAppointment",
                    dataType: "json",
                    data: formData,
                    success: function (response) {
                        // console.log(response);
                        if (response.SESSIONAVAILABLE == false) {
                            alert("New login detected! You’ve been logged out for security.");
                            window.location.href = "./index.cfm?action=restart";
                        }
                        if (response.SUCCESS) {
                            appointmentDetails(status);
                            getAdminNotification();
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

    //Function to mark the appointment as cancelled.
    function cancelAppointment(key, status, patientname, patientEmail) {
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
                    patientname: patientname,
                    patientEmail: patientEmail,
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
                            getAdminNotification();
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

    //Function to mark the appointment as accepted.
    function acceptAppointment(key, status, patientname, patientEmail) {
        console.log(`Accept Appointment of ${key}`);
        $(`#messageDivAccept_${key}`).removeClass("d-none");

        $(`#messageDivAcceptNo_${key}`)
            .off("click")
            .on("click", function (event) {
                event.preventDefault();
                $(`#messageDivAccept_${key}`).addClass("d-none");
            });

        $(`#messageDivAcceptYes_${key}`)
            .off("click")
            .on("click", function (event) {
                event.preventDefault();

                const formData = {
                    key: key,
                    patientname: patientname,
                    patientEmail: patientEmail,
                };

                $.ajax({
                    type: "POST",
                    url: "./controllers/appointmentServices.cfc?method=acceptAppointment",
                    dataType: "json",
                    data: formData,
                    success: function (response) {
                        // console.log(response);
                        if (response.SESSIONAVAILABLE == false) {
                            alert("New login detected! You’ve been logged out for security.");
                            window.location.href = "./index.cfm?action=restart";
                        }
                        if (response.SUCCESS) {
                            $(`#messageDivAccept_${key}`).addClass("d-none");
                            appointmentDetails(status);
                            getAdminNotification();
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

    //Function to mark the appointment as accepted.
    function notifyPatientsForAppontment(key, status, patientname, patientEmail, appointmentDate, appointmentTime) {
        $(`#messageDivNotify_${key}`).removeClass("d-none");

        $(`#messageDivNotifyNo_${key}`)
            .off("click")
            .on("click", function (event) {
                event.preventDefault();
                $(`#messageDivNotify_${key}`).addClass("d-none");
            });

        $(`#messageDivNotifyYes_${key}`)
            .off("click")
            .on("click", function (event) {
                event.preventDefault();

                const formData = {
                    key: key,
                    patientname: patientname,
                    patientEmail: patientEmail,
                    appointmentDate: appointmentDate,
                    appointmentTime: appointmentTime,
                };

                console.log(formData);

                $.ajax({
                    type: "POST",
                    url: "./controllers/appointmentServices.cfc?method=notifyAppointment",
                    dataType: "json",
                    data: formData,
                    success: function (response) {
                        console.log(response);
                        if (response.SESSIONAVAILABLE == false) {
                            alert("New login detected! You’ve been logged out for security.");
                            window.location.href = "./index.cfm?action=restart";
                        }
                        if (response.SUCCESS) {
                            $(`#messageDivNotify_${key}`).addClass("d-none");
                            appointmentDetails(status);
                            getAdminNotification();
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

    $(document).on("click", "#submitBtnPrescription", function (event) {
        if (!validateForm()) return;

        // const formData = {
        //     key: $("#addPrescriptioAppointmentId").val(),
        //     file: $("#fileUploadPrescription")[0].files[0] || 0,
        //     Note: $("#prescriptionNote").val(),
        //     PatientId: $("#addPrescriptionPatientId").val(),
        //     DoctorId: $("#addPrescriptionDoctorId").val(),
        // };

        const appointmentID = $("#addPrescriptioAppointmentId").val();
        const file = $("#fileUploadPrescription")[0].files[0] || null; // Changed to null
        var Note = $("#prescriptionNote").val();
        const PatientId = $("#addPrescriptionPatientId").val();
        const DoctorId = $("#addPrescriptionDoctorId").val();
        const patientEmail = $("#addPrescriptionPatientEmail").val();

        console.log(file);
        let formDetails = {
            appointmentID,
            file,
            Note,
            PatientId,
            DoctorId,
            patientEmail,
        };
        var formData = new FormData();

        for (var key in formDetails) {
            if (formDetails.hasOwnProperty(key)) {
                formData.append(key, formDetails[key]);
            }
        }

        // Check final output
        console.log(formData);

        let $messageDivPrescription = $("#messageDivPrescription");

        $.ajax({
            type: "POST",
            url: "./controllers/prescriptionService.cfc?method=createPrescription",
            data: formData,
            processData: false,
            contentType: false,
            dataType: "json",
            success: function (response) {
                // console.log(response);
                if (response.SESSIONAVAILABLE == false) {
                    alert("New login detected! You’ve been logged out for security.");
                    window.location.href = "./index.cfm?action=restart";
                }
                appointmentDetails("completed");
                getAdminNotification();
                const isSuccess = response.SUCCESS;
                $messageDivPrescription
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
        const validators = [validateNote, validateFile];

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

    function validateNote() {
        return validateField("#prescriptionNote", "Please Add Prescription Note");
    }

    function validateFile() {
        var prescriptionInput = $("#fileUploadPrescription");
        var prescriptionPath = prescriptionInput.val().toLowerCase();
        var allowedExtensions = /(\.pdf)$/i;
        if (!allowedExtensions.exec(prescriptionPath)) {
            showError("#fileUploadPrescription", "Please select a valid file (pdf).");
            return false;
        }
        return true;
    }
});
