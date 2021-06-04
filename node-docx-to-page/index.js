// Libraries used
const fs = require('fs');
const path = require('path');
const axios = require('axios');
const mammoth = require('mammoth');

// BookStack API variables
// Uses values on the environment unless hardcoded
// To hardcode, add values to the empty strings in the below.
const bookStackConfig = {
    base_url: '' || process.env.BS_URL,
    token_id: '' || process.env.BS_TOKEN_ID,
    token_secret: '' || process.env.BS_TOKEN_SECRET,
};

// Script Logic
////////////////

// Check arguments provided
if (process.argv.length < 4) {
    console.error('Both <docx_file> and <book_slug> arguments need to be provided');
    return;
}

// Get arguments passed via command
const [_exec, _script, docxFile, bookSlug] = process.argv;

// Check the docx file exists
if (!fs.existsSync(docxFile)) {
    console.error(`Provided docx file "${docxFile}" could not be found`);
    return;
}

// Create an axios instance for our API
const api = axios.create({
    baseURL: bookStackConfig.base_url.replace(/\/$/, '') + '/api/',
    timeout: 5000,
    headers: { 'Authorization' : `Token ${bookStackConfig.token_id}:${bookStackConfig.token_secret}` },
});

// Wrap the rest of our code in an async function so we can await within.
(async function() {

    // Fetch the related book to ensure it exists
    const {data: bookSearch} = await api.get(`/books?filter[slug]=${encodeURIComponent(bookSlug)}`);
    if (bookSearch.data.length === 0) {
        console.error(`Book with a slug of "${bookSlug}" could not be found`);
        return;
    }
    const book = bookSearch.data[0];

    // Convert our document
    const {value: html, messages} = await mammoth.convertToHtml({path: docxFile});

    // Create a name from our document file name
    let {name} = path.parse(docxFile);
    name = name.replace(/[-_]/g, ' ');

    // Upload our page
    const {data: page} = await api.post('/pages', {
        book_id: book.id,
        name,
        html,
    });

    // Output the results
    console.info(`File converted and created as a page.`);
    console.info(` - Page ID: ${page.id}`);
    console.info(` - Page Name: ${page.name}`);
    console.info(`====================================`);
    console.info(`Conversion occurred with ${messages.length} message(s):`);
    for (const message of messages) {
        console.warn(`[${message.type}] ${message.message}`);
    }

})().catch(err => {
    // Handle API errors
    if (err.response) {
        console.error(`Request failed with status ${err.response.status} [${err.response.statusText}]`);
        return;
    }
    // Output all other errors
    console.error(err)
});