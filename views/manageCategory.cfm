<main id="main" class="main">
    <div class="container mb-3 mt-10 min-vh-100 border-0" style="margin-top: 90px;">
        <div class="card-body">
            <div class="row">
                <div class="col-8">
                    <h4>Manage Categories</h4>
                </div>
                <div class="col-4">
                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <button class="btn shadow me-md-2 btn-sm" type="button" id="" data-bs-toggle="modal" data-bs-target="#exampleModalAddCategories" style="background-color:#fdfdfd; color:#4fa284">Add New Categories</button>
                    </div>
                </div>
            </div>
            <div id="CategoryList"></div>
        </div>   
    </div>

    <div class="modal fade" id="exampleModalAddCategories" tabindex="-1" data-bs-backdrop="static" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header border-0">
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="pt-4 pb-2">
                    <h5 class="card-title text-center pb-0 fs-4">Add a New Category</h5> 
                    <p class="text-center small">Please fill in the details below to create a new category and enhance our Aarogya appointment system.</p>
                    <div id="messageDiv" class="alert"></div>
                </div>
                <form class="row g-3" novalidate>

                    <div class="col-12">
                        <label for="categotyName" class="form-label">Category Name</label>
                        <input type="text" name="name" class="form-control" id="categotyName" required>
                        <div class="invalid-feedback"></div>
                    </div>
                    
                    <div class="col-12">
                        <label for="categotyCode" class="form-label">Category Code (CATXXX)</label>
                        <input type="text" name="categotyCode" class="form-control" id="categotyCode" required>
                        <div class="invalid-feedback"></div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-0">
                <button
                            id="submitBtnNewCategory"
                            class="btn shadow"
                            style="background-color:#fdfdfd; color:#4fa284"
                        >
                        Add New Category
                </button>
                <button type="button" class="btn shadow" data-bs-dismiss="modal" style="background-color:#fdfdfd; color:#4fa284">Close</button>
            </div>
        </div>
        </div>
    </div>
</main>