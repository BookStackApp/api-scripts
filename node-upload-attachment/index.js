// Libraries used
const fs = require('fs');
const path = require('path');
const axios = require('axios');
const FormData = require('form-data');

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
    console.error('Both <page_id> and <file_path> arguments need to be provided');
    return;
}

// Get arguments passed via command
const [_exec, _script, pageId, filePath] = process.argv;

// Check the given file exists
if (!fs.existsSync(filePath)) {
    console.error(`File at "${filePath}" could not be found`);
    return;
}

// Get the file name and create a read stream from the given file
const fileStream = fs.createReadStream(filePath);
const fileName = path.basename(filePath);

// Gather our form data with all the required bits
const formPostData = new FormData();
formPostData.append('file', fileStream);
formPostData.append('name', fileName);
formPostData.append('uploaded_to', pageId);

// Create an axios instance for our API
const api = axios.create({
    baseURL: bookStackConfig.base_url.replace(/\/$/, '') + '/api/',
    timeout: 30000,
    headers: { 'Authorization' : `Token ${bookStackConfig.token_id}:${bookStackConfig.token_secret}` },
});

// Wrap the rest of our code in an async function, so we can await within.
(async function() {

    // Upload the file using the gathered data
    // Sends it with a "Content-Type: multipart/form-data" with the post
    // body formatted as multipart/form-data content, with the "FormData" object
    // from the "form-data" library does for us.
    const {data: attachment} = await api.post('/attachments', formPostData, {
        headers: formPostData.getHeaders(),
    });

    // Output the results
    console.info(`File successfully uploaded to page ${pageId}.`);
    console.info(` - Attachment ID: ${attachment.id}`);
    console.info(` - Attachment Name: ${attachment.name}`);

})().catch(err => {
    // Handle API errors
    if (err.response) {
        console.error(`Request failed with status ${err.response.status} [${err.response.statusText}]`);
        console.error(JSON.stringify(err.response.data));
        return;
    }
    // Output all other errors
    console.error(err)
});