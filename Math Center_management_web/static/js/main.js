// Initialize tooltips
document.addEventListener('DOMContentLoaded', function() {
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function(tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
});

// Initialize popovers
document.addEventListener('DOMContentLoaded', function() {
    var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
    var popoverList = popoverTriggerList.map(function(popoverTriggerEl) {
        return new bootstrap.Popover(popoverTriggerEl);
    });
});

// Auto-hide alerts after 5 seconds
document.addEventListener('DOMContentLoaded', function() {
    var alerts = document.querySelectorAll('.alert');
    alerts.forEach(function(alert) {
        setTimeout(function() {
            var bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });
});

// Confirm delete actions
document.addEventListener('DOMContentLoaded', function() {
    var deleteButtons = document.querySelectorAll('.delete-confirm');
    deleteButtons.forEach(function(button) {
        button.addEventListener('click', function(e) {
            if (!confirm('Bạn có chắc chắn muốn xóa mục này?')) {
                e.preventDefault();
            }
        });
    });
});

// Form validation
document.addEventListener('DOMContentLoaded', function() {
    var forms = document.querySelectorAll('.needs-validation');
    Array.prototype.slice.call(forms).forEach(function(form) {
        form.addEventListener('submit', function(event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    });
});

// Dynamic form fields
function addFormField(containerId, templateId) {
    var container = document.getElementById(containerId);
    var template = document.getElementById(templateId);
    var clone = template.content.cloneNode(true);
    container.appendChild(clone);
}

function removeFormField(button) {
    var field = button.closest('.form-field');
    field.remove();
}

// Date picker initialization
document.addEventListener('DOMContentLoaded', function() {
    var dateInputs = document.querySelectorAll('.datepicker');
    dateInputs.forEach(function(input) {
        new Datepicker(input, {
            format: 'dd/mm/yyyy',
            language: 'vi'
        });
    });
});

// File input preview
document.addEventListener('DOMContentLoaded', function() {
    var fileInputs = document.querySelectorAll('.custom-file-input');
    fileInputs.forEach(function(input) {
        input.addEventListener('change', function(e) {
            var fileName = e.target.files[0].name;
            var label = e.target.nextElementSibling;
            label.textContent = fileName;
        });
    });
});

// Dynamic table search
document.addEventListener('DOMContentLoaded', function() {
    var searchInputs = document.querySelectorAll('.table-search');
    searchInputs.forEach(function(input) {
        input.addEventListener('keyup', function() {
            var searchText = this.value.toLowerCase();
            var table = this.closest('.card').querySelector('table');
            var rows = table.querySelectorAll('tbody tr');
            
            rows.forEach(function(row) {
                var text = row.textContent.toLowerCase();
                row.style.display = text.includes(searchText) ? '' : 'none';
            });
        });
    });
}); 