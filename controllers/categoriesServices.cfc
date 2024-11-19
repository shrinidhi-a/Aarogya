component output="true"{

    // NOTE: Updated with Aarogya2.0
    remote struct function getCategories() 
        returnformat="JSON" 
    {

        local.response = {
            data: structNew(),
            message: '',
            success: false
        };

        try {
            local.categories = new model.categories();

            // Check for authenticated user
            if (!session.isLoggedIn || !structKeyExists(session, "role")) {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            // Retrieve category information
            local.response.data = local.categories.getCategoriesInfo();
            local.response.message = "Successfully retrived the categories"; 
            local.response.success = true;

        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

    // NOTE: Updated with Aarogya2.0
    remote struct function getAllCategories() 
        returnformat="JSON" 
    {

        local.response = {
            data: structNew(),
            message: '',
            success: false
        };

        try {
            local.categories = new model.categories();

            // Check for authenticated user
            if (!session.isLoggedIn || !structKeyExists(session, "role")) {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            // Retrieve category information
            local.response.data = local.categories.getAllCategoriesInfo();
            local.response.message = "Successfully retrived the categories"; 
            local.response.success = true;

        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

    // NOTE: Updated with Aarogya2.0
    remote struct function createNewCategory(
        string code,
        string name
    ) 
    returnformat="JSON" {

        local.response = {
            message: '',
            success: false,
            sessionAvailable: true
        };

        try {
            // Check for authenticated admin user
            if (!(session.isLoggedIn && structKeyExists(session, "role") && session.role == "admin")) {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            local.categories = new model.categories();

            // Check if the category already exists
            if (local.categories.checkCategoryExists(arguments.code)) {
                local.response.message = "Category already present in Aarogya"; 
                return local.response;
            }

            local.sessionVal = new model.session();
            if(!local.sessionVal.getSessionValidation()){
                local.response.sessionAvailable = false; 
                return local.response;
            }

            // Attempt to create the new category
            if (local.categories.createNewCategory(arguments.code, arguments.name)) {
                local.response.success = true; 
                local.response.message = "New category created successfully"; 
            } else {
                local.response.message = "Unable to create new category"; 
            }

        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

    // NOTE: Updated with Aarogya2.0
    remote struct function updateCategoryInfo(
        string key,
        string name,
        string code
    ) 
    returnformat="JSON" 
    {

        local.response = {
            message: '',
            success: false,
            sessionAvailable: true
        };

        try {
            local.update = new model.categories();

            if (!session.isLoggedIn || !structKeyExists(session, "role") || session.role != "admin") {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            local.sessionVal = new model.session();
            if(!local.sessionVal.getSessionValidation()){
                local.response.sessionAvailable = false; 
                return local.response;
            }

            if (local.update.checkCodeExistsForOthers(arguments.code, arguments.key)) {
                local.response.message = "Category Code Already present in the system";
                return local.response;
            }

            if (local.update.updateCategoryInfo(
                arguments.key,
                arguments.name,
                arguments.code
                )) {
                local.response.success = true;
                local.response.message = "Category Details updated successfully";
            } else {
                local.response.message = "Failed to update Category details";
            }

        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }

    // NOTE: Updated with Aarogya2.0
    remote struct function removeCategoryInfo(
        string categoryId
    ) 
    returnformat="JSON" 
    {
        local.response = {
            message: '',
            success: false,
            sessionAvailable: true
        };

        try {
            local.remove = new model.categories();

            if (!session.isLoggedIn || !structKeyExists(session, "role") || session.role != "admin") {
                local.response.message = "Unauthenticated access"; 
                return local.response;
            }

            local.sessionVal = new model.session();
            if(!local.sessionVal.getSessionValidation()){
                local.response.sessionAvailable = false; 
                return local.response;
            }

            local.categoryRemoveInfo = local.remove.removeCategoryInfo(arguments.categoryId)

            if (local.categoryRemoveInfo.success) {
                local.response.success = true;
                local.response.message = local.categoryRemoveInfo.message;
            } else {
                local.response.message = local.categoryRemoveInfo.message;
            }

        } catch (any e) {
            local.response.message = "Error: " & e.message;
        }

        return local.response;
    }
}
