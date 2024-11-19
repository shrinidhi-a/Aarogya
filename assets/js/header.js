$(document).ready(function () {
    //handling logout submition.
    $("#logoutLink").on("click", function (event) {
        event.preventDefault();

        $.ajax({
            type: "POST",
            url: "./controllers/userServices.cfc?method=logoutUser",
            dataType: "json",
            success: function (response) {
                console.log(response);
                if (response.SUCCESS) {
                    window.location.href = "./index.cfm?action=home";
                } else {
                    console.log(response.MESSAGE);
                }
            },
            error: function (xhr, status, error) {
                console.warn("AJAX error: " + error);
            },
        });
    });
});
