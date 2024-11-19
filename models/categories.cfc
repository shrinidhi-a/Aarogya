component {

    // NOTE: Updated with new Database.
    public struct function getCategoriesInfo() {
        local.data = structNew();
        
        try {
            local.categoryInfo = queryExecute(
                "SELECT CategoryID, CategoryName, CategoryCode FROM Categories WHERE CategoryStatus = :CategoryStatus",
                {
                    CategoryStatus: application.CATEGORY_STATUS_AVAILABLE
                }
            );
    
            if (local.categoryInfo.recordCount > 0) {
                for (local.row in local.categoryInfo) {
                    local.data[local.row.CategoryID] = local.row.CategoryName;
                }
            }
            return local.data;
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error fetching categories: " & e.message);
            return local.data;
        }
    }

    // NOTE: Updated with new Database.
    public struct function getAllCategoriesInfo() {
        local.data = structNew();
        
        try {
            local.categoryInfo = queryExecute(
                "SELECT CategoryID, CategoryName, CategoryCode FROM Categories WHERE CategoryStatus = :CategoryStatus",
                {
                    CategoryStatus: application.CATEGORY_STATUS_AVAILABLE
                }
            );
    
            if (local.categoryInfo.recordCount > 0) {
                for (local.row in local.categoryInfo) {
                    local.data[local.row.CategoryID] = {
                        "name" : local.row.CategoryName,
                        "code" : local.row.CategoryCode
                    }
                }
            }
            return local.data;
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error fetching categories: " & e.message);
            return local.data;
        }
    }

    // NOTE: Updated with new Database.
    public boolean function createNewCategory(
        string code,
        string name
    ) {
        
        try {
            queryExecute(
                "INSERT INTO Categories(
                    CategoryName,
                    CategoryCode
                )
                VALUES(
                    :CategoryName,
                    :CategoryCode
                )",
                {
                    CategoryName:arguments.name,
                    CategoryCode:arguments.code
                }
            );
            return true;
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error creating categories: " & e.message);
            return false;
        }
    }

    // NOTE: Updated with new Database.
    public boolean function checkCategoryExists(
        string code
    )
    {
        try{
            local.codeCountResult = queryExecute(
                "SELECT COUNT(*) AS codeCount FROM Categories WHERE CategoryCode = :code AND CategoryStatus = :CategoryStatus;",
                {code: arguments.code, CategoryStatus: application.CATEGORY_STATUS_AVAILABLE}
            );
            if(local.codeCountResult.recordCount > 0 && local.codeCountResult.codeCount[1] > 0) {
                return true;
            }
            else{
                return false;
            }
        }
        catch (any e) {
            writeLog(file="Aarogyalogs", text="Error checking category exists: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }

    // NOTE: Updated with new Database.
    public boolean function checkCodeExistsForOthers(
        string code,
        string excludeId
    )
    {
        try {
            local.codeCountResult = queryExecute(
                "SELECT COUNT(*) AS codeCount FROM Categories WHERE CategoryCode = :code AND CategoryID != :excludeId AND CategoryStatus = :CategoryStatus;",
                {
                    code: arguments.code,
                    excludeId: arguments.excludeId,
                    CategoryStatus: application.CATEGORY_STATUS_AVAILABLE
                }
            );

            if (local.codeCountResult.recordCount > 0 && local.codeCountResult.codeCount[1] > 0) {
                return true;
            } else {
                return false;
            }
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error checking category code: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }

    // NOTE: Updated with new Database.
    public boolean function updateCategoryInfo(
        string key,
        string name,
        string code
    ) 
    {
        try {
            queryExecute(
                "UPDATE Categories
                SET CategoryName = :Name,
                CategoryCode = :Code
                WHERE CategoryID = :CategoryID",
                {
                    Name: arguments.name,
                    Code: arguments.code,
                    CategoryID: arguments.key
                }
            );

            return true;
        } catch (any e) {
            writeLog(file="Aarogyalogs", text="Error updating category: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }

    // NOTE: Updated with new Database.
    public struct function removeCategoryInfo(
        string categoryId
    ) 
    {
        local.response = {
            success: false,
            message: ''
        };

        try {
            queryExecute(
               "UPDATE Categories
                SET CategoryStatus = :CategoryStatus
                WHERE CategoryID = :CategoryID",
                {
                    CategoryStatus: application.CATEGORY_STATUS_UNAVAILABLE,
                    CategoryID: arguments.categoryId
                }
            );

            local.response.success = true;
            local.response.message = "Category removed successfully.";
        } catch (any e) {
            // Check for foreign key constraint violation using a more precise condition
            if (findNoCase("The DELETE statement conflicted with the REFERENCE constraint", e.detail) > 0) {
                local.response.message = "Cannot delete category because there are doctors belongs to this category.";
            } else {
                local.response.message = "Error deleting category info: " & e.message;
            }
            writeLog(file="Aarogyalogs", text="Error deleting category info: " & e.message & "; Details: " & e.detail);
        }

        return local.response;
    }




}