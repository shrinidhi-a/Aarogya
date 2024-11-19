$(document).ready(function () {
    //Handling new category submition.
    $(document).on("click", "#submitBtnNewCategory", function (event) {
        event.preventDefault();

        if (!validateForm()) return;

        let $messageDiv = $("#messageDiv");

        let formData = {
            name: $("#categotyName").val().trim(),
            code: $("#categotyCode").val().trim(),
        };

        $.ajax({
            type: "POST",
            url: "./controllers/categoriesServices.cfc?method=createNewCategory",
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
                        window.location.href = "./index.cfm?action=manageCategory";
                    }, 3000);
                }
            },
            error: function (xhr, status, error) {
                console.warn("AJAX error: " + error);
            },
        });

        function validateForm() {
            const validators = [validateCategoryName, validateCategoryCode];

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

        function validateCategoryName() {
            return validateField("#categotyName", "Please Enter Category Name");
        }

        function validateCategoryCode() {
            const regex = /^CAT\d{3}$/;
            return validateField("#categotyCode", "Please Enter Category Code", "Category Code", regex);
        }
    });
});
