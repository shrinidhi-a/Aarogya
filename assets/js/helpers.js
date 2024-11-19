$(document).ready(function () {
    // Handlebar Helpers.
    Handlebars.registerHelper("isEqual", function (a, b) {
        return a === b;
    });

    Handlebars.registerHelper("formatDate", function (dateString) {
        const options = { year: "numeric", month: "long", day: "numeric" };
        return new Date(dateString).toLocaleDateString(undefined, options);
    });

    Handlebars.registerHelper("formatTime", function (dateString) {
        const options = { hour: "2-digit", minute: "2-digit", hour12: true };
        return new Date(dateString).toLocaleTimeString(undefined, options);
    });

    Handlebars.registerHelper("eq", function (arg1, arg2) {
        return arg1 === arg2;
    });

    Handlebars.registerHelper("eqCase", function (arg1, arg2) {
        return arg1.toLowerCase() === arg2.toLowerCase();
    });

    Handlebars.registerHelper("lower", function (str) {
        if (typeof str === "string") {
            return str.toLowerCase();
        }
        return str;
    });
});
