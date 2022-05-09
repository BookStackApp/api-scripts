// Listen to messages from our content-script
chrome.runtime.onMessage.addListener(function(request, sender, sendResponse) {


    // If we're receiving a message with a query, search BookStack
    // and return the BookStack results in the response.
    if (request.query) {
        searchBookStack(request.query).then(results => {
            if (results) {
                sendResponse({results});
            }
        });
    }

    // Return true enables 'sendResponse' to work async
    return true;
});


// Search our BookStack instance using the given query
async function searchBookStack(query) {

    // Load BookStack API details from our options
    const options = await loadOptions();
    for (const option of Object.values(options)) {
        if (!option) {
            console.log('Missing a required option');
            return;
        }
    }

    // Query BookStack, making an authorized API search request
    const url = `${options.baseUrl}/api/search?query=${encodeURIComponent(query)}`;
    const resp = await fetch(url, {
        method: 'GET',
        headers: {
            Authorization: `Token ${options.tokenId}:${options.tokenSecret}`,
        }
    });

    // Parse the JSON response and return the results
    const data = await resp.json();
    return data.data || null;
}


/**
 * Load our options from chrome's storage.
 * @returns Promise<Object>
 */
function loadOptions() {
    return new Promise((res, rej) => {
        chrome.storage.sync.get({
            tokenId: '',
            tokenSecret: '',
            baseUrl: '',
        }, options => {
            res(options);
        })
    });
}