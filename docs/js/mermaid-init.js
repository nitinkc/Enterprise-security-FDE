function mermaidTheme() {
  const colorScheme = document.body.getAttribute('data-md-color-scheme');
  return colorScheme === 'slate' ? 'dark' : 'default';
}

function renderMermaidDiagrams() {
  if (!window.mermaid) {
    return;
  }

  window.mermaid.initialize({
    startOnLoad: false,
    securityLevel: 'loose',
    theme: mermaidTheme()
  });

  document.querySelectorAll('.mermaid').forEach((el, index) => {
    const graphDefinition = el.textContent;
    const graphId = `mermaid-graph-${index}`;
    window.mermaid.render(graphId, graphDefinition).then(({ svg }) => {
      el.innerHTML = svg;
    });
  });
}

document$.subscribe(() => {
  renderMermaidDiagrams();
});
