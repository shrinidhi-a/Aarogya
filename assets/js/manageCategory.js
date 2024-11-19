$(document).ready(function () {
    // doctorDetails();

    loadCategories();

    function loadCategories() {
        $.ajax({
            url: "./controllers/categoriesServices.cfc?method=getAllCategories",
            method: "GET",
            dataType: "json",
            success: function (response) {
                // console.log(response.DATA);
                handlebarsCategory(response.DATA);

                let categoryData = response.DATA;

                for (const key in categoryData) {
                    if (categoryData.hasOwnProperty(key)) {
                        console.log(key);

                        $(document)
                            .off("click", `#confirmedRemoveCategory_${key}`)
                            .on("click", `#confirmedRemoveCategory_${key}`, function (event) {
                                event.preventDefault();
                                $(`#messageDivRemoveCategory_${key}`).removeClass("d-none");
                            });

                        $(document)
                            .off("click", `#cancelRemoveCategory_${key}`)
                            .on("click", `#cancelRemoveCategory_${key}`, function (event) {
                                event.preventDefault();
                                $(`#messageDivRemoveCategory_${key}`).addClass("d-none");
                            });

                        $(document)
                            .off("click", `#submitBtnUpdateCategory_${key}`)
                            .on("click", `#submitBtnUpdateCategory_${key}`, function (event) {
                                event.preventDefault();

                                if (!validateForm(key)) return;

                                let formData = {
                                    key: key,
                                    name: $(`#yourNameCategory_${key}`).val().trim(),
                                    code: $(`#yourCodeCategory_${key}`).val().trim(),
                                };
                                updateCategoryDetails(formData, key);
                            });

                        $(document)
                            .off("click", `#confirmRemoveCategory_${key}`)
                            .on("click", `#confirmRemoveCategory_${key}`, function (event) {
                                event.preventDefault();
                                removeCategoryDetails(key);
                            });
                    }
                }
            },
            error: function (xhr, status, error) {
                console.error("Error loading categories:", error);
            },
        });
    }

    function handlebarsCategory(context) {
        $.get("./assets/templates/categoryCard.hbs", function (templateData) {
            var source = templateData;
            var template = Handlebars.compile(source);
            var html = template(context);
            $("#CategoryList").html(html);
        });
    }

    function updateCategoryDetails(formdata, key) {
        let $messageDivCategory = $(`#messageDivUpdateCategoryModal_${key}`);

        $.ajax({
            type: "POST",
            url: "./controllers/categoriesServices.cfc?method=updateCategoryInfo",
            data: formdata,
            dataType: "json",
            success: function (response) {
                // console.log(response);
                if (response.SESSIONAVAILABLE == false) {
                    alert("New login detected! You’ve been logged out for security.");
                    window.location.href = "./index.cfm?action=restart";
                }
                const isSuccess = response.SUCCESS;

                $messageDivCategory
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
    }

    function removeCategoryDetails(categoryId) {
        let formData = {
            categoryId: categoryId,
        };

        $.ajax({
            type: "POST",
            url: "./controllers/categoriesServices.cfc?method=removeCategoryInfo",
            data: formData,
            dataType: "json",
            success: function (response) {
                // console.log(response);
                if (response.SESSIONAVAILABLE == false) {
                    alert("New login detected! You’ve been logged out for security.");
                    window.location.href = "./index.cfm?action=restart";
                }
                if (response.SUCCESS) {
                    alert(response.MESSAGE);
                    loadCategories();
                } else {
                    alert(response.MESSAGE);
                }
            },
            error: function (xhr, status, error) {
                console.warn("AJAX error: " + error);
            },
        });
    }

    function validateForm(key) {
        const validators = [() => validateCategoryName(key), () => validateCategoryCode(key)];

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

    function validateCategoryName(key) {
        return validateField(`#yourNameCategory_${key}`, "Please Enter Category Name");
    }

    function validateCategoryCode(key) {
        const regex = /^CAT\d{3}$/;
        return validateField(`#yourCodeCategory_${key}`, "Please Enter Category Code", "Category Code", regex);
    }
});
