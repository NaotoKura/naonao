// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Turbo method and confirm handlers
document.addEventListener('DOMContentLoaded', function() {
  // Handle turbo-method links
  document.addEventListener('click', function(event) {
    const link = event.target.closest('a[data-turbo-method]');
    if (!link) return;
    
    const method = link.dataset.turboMethod;
    const confirm = link.dataset.turboConfirm;
    
    if (confirm && !window.confirm(confirm)) {
      event.preventDefault();
      return;
    }
    
    if (method && method !== 'get') {
      event.preventDefault();
      
      const form = document.createElement('form');
      form.method = 'POST';
      form.action = link.href;
      form.style.display = 'none';
      
      const methodInput = document.createElement('input');
      methodInput.type = 'hidden';
      methodInput.name = '_method';
      methodInput.value = method;
      form.appendChild(methodInput);
      
      const csrfToken = document.querySelector('meta[name="csrf-token"]');
      if (csrfToken) {
        const csrfInput = document.createElement('input');
        csrfInput.type = 'hidden';
        csrfInput.name = 'authenticity_token';
        csrfInput.value = csrfToken.content;
        form.appendChild(csrfInput);
      }
      
      document.body.appendChild(form);
      form.submit();
    }
  });
});
