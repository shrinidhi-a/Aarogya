$(document).ready(function () {
    //Generating dynamic Appointment cards.

    if (window.location.search == "?action=reports") {
        appointmentDetails("pending");
    }

    function handlebarsAppointments(context) {
        $.get("./assets/templates/reportsCards.hbs", function (templateData) {
            var source = templateData;
            var template = Handlebars.compile(source);
            var html = template(context);
            $("#reportsAppointment").html(html);
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
                                const key = appointment.key;
                                $(document)
                                    .off("click", `#downloadReport_${key}`)
                                    .on("click", `#downloadReport_${key}`, function (event) {
                                        console.log(key);
                                        downloadReport(key);
                                    });
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

    //Handling tabs in the admin profile page.
    $("#requests-tab").click(function (e) {
        e.preventDefault();
        $(".nav-link").removeClass("active");
        $(this).addClass("active");
        appointmentDetails("pending");
    });

    $("#confirmedApp-tab").click(function (e) {
        e.preventDefault();
        $(".nav-link").removeClass("active");
        $(this).addClass("active");
        appointmentDetails("confirmed");
    });

    $("#completedApp-tab").click(function (e) {
        e.preventDefault();
        $(".nav-link").removeClass("active");
        $(this).addClass("active");
        appointmentDetails("completed");
    });

    $("#concelledApp-tab").click(function (e) {
        e.preventDefault();
        $(".nav-link").removeClass("active");
        $(this).addClass("active");
        appointmentDetails("cancelled");
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

    function downloadReport(appontmentID) {
        let formData = {
            appontmentID: appontmentID,
        };

        $.ajax({
            type: "POST",
            url: "./controllers/fileServices.cfc?method=generateXLSForAppointment",
            dataType: "json",
            data: formData,
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
                        "appontment-info.xlsx"
                    );
                    console.log(response.MESSAGE);
                } else {
                    alert(response.MESSAGE);
                }
            },
            error: function (xhr, status, error) {
                console.warn("AJAX error: " + error);
            },
        });
    }

    //Handling export data button submition.
    $("#downloadAllReports").on("click", function (event) {
        event.preventDefault();
        $.ajax({
            type: "POST",
            url: "./controllers/fileServices.cfc?method=generateAllXLS",
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
                        "all-appontment-info.xlsx"
                    );
                    console.log(response.MESSAGE);
                } else {
                    alert(response.MESSAGE);
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
