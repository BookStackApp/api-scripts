const url = new URL(window.location.href);
const query = url.searchParams.get("q");
const resultContainer = document.getElementById('search');

// If we have a query in the URL, and a '#search' section, we are 
// likely on a search results page so we kick-off the display of 
// results by messaging the back-end to make the request to BookStack.
if (query && resultContainer) {

    chrome.runtime.sendMessage({query}, function(response) {
        // If re receive results back from our background script API call,
        // show them on the current page.
        if (response.results) {
            showResults(response.results);
        }
    });

}

/**
 * Display the given API search result objects as a list of links on 
 * the current page, within the '#search' section.
 * @param {Object[]} results 
 */
function showResults(results) {
    const resultHTML = results.map(result => {
        return `
        <a href="${result.url}">
            <h3>${result.type.toUpperCase()}: ${result.preview_html.name}</h3>
            <p style="color: #444; text-decoration: none;font-size:0.8em;">${result.preview_html.content}</p>
        </a>
        `;
    }).join('\n');

    const header = `<h4>BookStack Results</h4>`;
    const container = document.createElement('div');
    container.innerHTML = header + resultHTML + '<hr>';
    resultContainer.prepend(container);
}