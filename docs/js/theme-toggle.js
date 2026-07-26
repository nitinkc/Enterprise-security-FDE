function saveThemePreference() {
  const body = document.body;
  if (!body) {
    return;
  }

  const scheme = body.getAttribute('data-md-color-scheme') || 'default';
  localStorage.setItem('fde-security-theme', scheme);
}

function restoreThemePreference() {
  const saved = localStorage.getItem('fde-security-theme');
  if (!saved) {
    return;
  }

  const body = document.body;
  if (body) {
    body.setAttribute('data-md-color-scheme', saved);
  }
}

document$.subscribe(() => {
  restoreThemePreference();

  const observer = new MutationObserver(() => {
    saveThemePreference();
  });

  observer.observe(document.body, {
    attributes: true,
    attributeFilter: ['data-md-color-scheme']
  });
});
