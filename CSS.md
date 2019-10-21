# CSS  
  
  You will need to add styling for the form, I attempted to make the classes as unopinionated as possible.

  Below is a SASS example for Bootstrap 4

  ```css
  // #############################
  // ########### TABLE ###########
  // #############################

  // div around the table
  .exz-table-wrapper {
    @extend .table-responsive;
  }

  // the table
  .exz-table {
    @extend .table;

    thead {
      @extend .thead-dark;
    }
  }

  // div around exz-pagination-div and exz-search-div
  .exz-row {
    @extend .row;
  }

  .exz-nothing-found {
    @extend .text-center
  }

  // #############################
  // ########### SEARCH ##########
  // #############################

  // div around the search box
  .exz-search-wrapper {
    @extend .col-xl-6;
  }

  //The search form (I don't need this)
  // .exz-search-form {

  // }

  .exz-search-field {
    @extend .form-control;
    @extend .mb-1;
  }

  .exz-search-field-wrapper {
    @extend .input-group;
  }

  .exz-counter-field {
    @extend .input-group-text;
  }

  .exz-counter-field-wrapper {
    @extend .input-group-append;
    @extend .mb-1;
  }

  // #############################
  // ######## PAGINATION #########
  // #############################

  // div around the pagination nav
  .exz-pagination-wrapper {
    @extend .col-xl-6;
  }

  // nav around pagination ul
  .exz-pagination-nav {
    @extend .mt-1;
    @extend .mt-xl-0;
  }

  // ul around pagination li
  .exz-pagination-ul {
    @extend .pagination;
    @extend .pagination-sm;
  }

  // li around pagination links
  .exz-pagination-li {
    @extend .page-item;
  }

  // li around pagination links when active
  .exz-pagination-li-active {
    @extend .page-item;
    @extend .active;
    color: white;
  }

  // li around pagination links when disabled
  .exz-pagination-li-disabled {
    @extend .page-item;
    @extend .disabled;
  }

  // Base class for pagination link
  .exz-pagination-a {
    @extend .page-link;
    @extend .text-center;
    @extend .mt-1;
  }

  // Fixed width for pagination link with number
  .exz-pagination-width {
    width: 50px;
  }

  // #############################
  // ####### Header Links ########
  // #############################


  // Hide link
  .exz-hide-link {
    @extend .mx-1;
    @extend .small;
    cursor: grabbing;
  }

  // Sort link
  .exz-sort-link {
    @extend .mx-1;
    @extend .small;
    cursor: grabbing;
  }

  // Buttons for showing hidden columns
  .exz-show-button {
    @extend .btn;
    @extend .btn-sm;
    @extend .btn-outline-secondary;
    @extend .m-1;
    cursor: grabbing;
  }

  // Buttons for showing hidden columns
  .exz-info-button {
    @extend .btn;
    @extend .btn-sm;
    @extend .btn-outline-info;
    @extend .m-1;
    cursor: grabbing;
  }

  // #############################
  // ###### Action Buttons #######
  // #############################

  .exz-action-delete {
    @extend .btn;
    @extend .btn-sm;
    @extend .my-1;
    @extend .mr-1;
    @extend .btn-outline-danger;
  }

  .exz-action-new {
    @extend .btn;
    @extend .btn-sm;
    @extend .my-1;
    @extend .mr-1;
    @extend .btn-outline-primary;
  }

  .exz-action-show {
    @extend .btn;
    @extend .btn-sm;
    @extend .my-1;
    @extend .mr-1;
    @extend .btn-outline-primary;
  }

  .exz-action-edit {
    @extend .btn;
    @extend .btn-sm;
    @extend .my-1;
    @extend .mr-1;
    @extend .btn-outline-info;
  }
  ```
