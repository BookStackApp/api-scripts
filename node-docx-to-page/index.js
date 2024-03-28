// Libraries used
const fs = require('fs');
const path = require('path');
const axios = require('axios');
const mammoth = require('mammoth');
const pdf2html = require('pdf2html');
const { exec } = require('child_process');

// Getting command-line arguments for file path and book slug
const filePath = process.argv[2];
const bookSlug = process.argv[3];

const bookStackConfig = {
    base_url: process.env.BS_URL,
    token_id: process.env.BS_TOKEN_ID,
    token_secret: process.env.BS_TOKEN_SECRET,
};

// Script Logic
////////////////

// Check arguments provided
if (process.argv.length < 4) {
    console.error('Both <docx_file> and <book_slug> arguments need to be provided');
    return;
}

// Check the docx file exists
if (!fs.existsSync(filePath)) {
    console.error(`Provided file path "${filePath}" could not be found`);
    return;
}

const api = axios.create({
    baseURL: bookStackConfig.base_url.replace(/\/$/, '') + '/api/',
    timeout: 5000,
    headers: { 'Authorization': `Token ${bookStackConfig.token_id}:${bookStackConfig.token_secret}` },
});

async function findBook(slug) {
    try {
        console.log(`Getting book id from slug ${slug}`);
        const response = await api.get(`/books?filter[slug]=${encodeURIComponent(slug)}`);
        if (response.data.data.length > 0) {
            return response.data.data[0]; // Return the first book matching the slug
        } else {
            console.log(`No book found with slug: ${slug}`);
            return null;
        }
    } catch (error) {
        console.error(`Error finding book: ${error}`);
        return null;
    }
}

async function convertDocument(filePath) {
    const fileExtension = path.extname(filePath).toLowerCase();
    if (fileExtension === '.docx') {
        return convertDocxToHtml(filePath);
    } else if (fileExtension === '.pdf') {
        return convertPdfToHtml(filePath);
    } else {
        console.log(`Unsupported file format: ${fileExtension}`);
        return null;
    }
}

async function convertDocxToHtml(filePath) {
    try {
        console.log(`${filePath} is a docx, using mammoth.convertToHtml`);
        const result = await mammoth.convertToHtml({ path: filePath });
        return result.value; // Return the HTML content
    } catch (error) {
        console.error(`Error converting DOCX to HTML: ${error}`);
        return null;
    }
}

async function convertPdfToHtml(filePath) {
    try {
        console.log(`${filePath} is a pdf, using pdf2html.html`);
        const result = await pdf2html.html(filePath);
        return result; // Return the HTML content
    } catch (error) {
        console.error(`Error converting PDF to HTML: ${error}`);
        return null;
    }
}

async function uploadDocument(bookId, name, htmlContent) {
    try {
        console.log(`Uploading document with name "${name}"`);
        const response = await api.post('/pages', {
            book_id: bookId,
            name,
            html: htmlContent,
        });

        // Output the results
        console.info(`File converted and created as a page.`);
        console.info(` - Page ID: ${response.data.id}`);
        console.info(` - Page Name: ${name}`);

    } catch (error) {
        console.error(`Error uploading document: ${error}`);
    }
}


function checkJavaInstallation(callback) {
    exec('java -version', (error, stdout, stderr) => {
        if (error) {
            console.error("Java is not installed or not available in the PATH.");
            console.error("Please ensure Java is installed and accessible to continue.");
            process.exit(1); // Exit the script with an error code
        } else {
            callback(); // Proceed with the rest of the script
        }
    });
}

async function run(filePath, bookSlug) {
    if (!filePath || !bookSlug) {
        console.log('Usage: node myscript.js <file-path> <book-slug>');
        return;
    }
    const book = await findBook(bookSlug);
    if (book) {
        const htmlContent = await convertDocument(filePath);
        if (htmlContent) {
            await uploadDocument(book.id, path.basename(filePath, path.extname(filePath)), htmlContent);
        }
    }
}
// Perform the Java check, then proceed with the main script if successful
checkJavaInstallation(main);

function main() {}

run(filePath, bookSlug).catch(console.error);
