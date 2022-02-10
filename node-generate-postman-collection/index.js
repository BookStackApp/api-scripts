// Libraries used
const axios = require('axios');

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

// Create an axios instance for our API
const api = axios.create({
    baseURL: bookStackConfig.base_url.replace(/\/$/, '') + '/api/',
    timeout: 5000,
    headers: {'Authorization': `Token ${bookStackConfig.token_id}:${bookStackConfig.token_secret}`},
});

// Wrap the rest of our code in an async function, so we can await within.
(async function () {

    // Get our default schema structure and look up to BookStack
    // to get a JSON view of the BookStack docs.
    const postmanSchema = getBaseCollectionSchema();
    const {data: docs} = await api.get('/docs.json');

    // Cycle over the endpoint categories within the API docs
    for (const [category, endpoints] of Object.entries(docs)) {
        // Create the schema for the postman collection, which represents
        // a BookStack API category.
        const postmanFolderSchema = {
            name: category.toUpperCase(),
            item: [],
        };

        // Cycle over the endpoints within the category
        for (const endpoint of endpoints) {
            postmanFolderSchema.item.push(getEndpointSchema(endpoint));
        }

        // Push our endpoint data into the postman collection
        postmanSchema.item.push(postmanFolderSchema);
    }

    // Output the postman collection data to the command line
    console.log(JSON.stringify(postmanSchema, null, 2));

})().catch(err => {

    // Handle API errors
    if (err.response) {
        console.error(`Request failed with status ${err.response.status} [${err.response.statusText}]`);
        return;
    }

    // Output all other errors
    console.error(err)
});


/**
 * Get the postman collection data for a specific endpoint.
 * @param {Object} apiEndpoint
 * @return {{request: {method, header: *[]}, response: *[], name: string}}
 */
function getEndpointSchema(apiEndpoint) {
    // Create our base format for the postman schema for a single endpoint
    const postmanEndpointSchema = {
        name: `${apiEndpoint.name}`,
        request: {
            method: apiEndpoint.method,
            header: [],
        },
        response: []
    };

    // Create the base format used to represent a URL
    const url = {
        raw: `{{BASE_URL}}/${apiEndpoint.uri}`,
        host: ['{{BASE_URL}}'],
        path: apiEndpoint.uri.split('/'),
        query: []
    };

    // If a listing endpoint, add the standard list params,
    // although we leave them disabled by default.
    if (apiEndpoint.controller_method === 'list') {
        url.query = [
            {
                "key": "count",
                "value": "100",
                "disabled": true
            },
            {
                "key": "offset",
                "value": "0",
                "disabled": true
            },
            {
                "key": "sort",
                "value": "+name",
                "disabled": true
            },
            {
                "key": "filter[id]",
                "value": "5",
                "disabled": true
            }
        ];
    }

    // Add the url to the request schema
    postmanEndpointSchema.request.url = url;

    // Build a description for the endpoint
    // Formats the body parameters, if existing, to shown their validations.
    const description = [apiEndpoint.description];
    if (apiEndpoint.body_params) {
        description.push('', '', 'Available body parameters:', '');
        for (const [name, validations] of Object.entries(apiEndpoint.body_params)) {
            description.push(`${name}: ${validations.join(' :: ')}`);
        }
    }
    postmanEndpointSchema.request.description = description.join('\n');

    // If we have an example request, push it as default body JSON data
    if (apiEndpoint.example_request) {
        postmanEndpointSchema.request.header.push({
            "key": "Content-Type",
            "value": "application/json"
        });
        postmanEndpointSchema.request.body = {
            mode: "raw",
            raw: apiEndpoint.example_request,
            options: {
                raw: {
                    language: 'json'
                }
            }
        }
    }

    // Push an example of a response if we have one
    if (apiEndpoint.example_response) {
        postmanEndpointSchema.response.push({
            name: 'Example Response',
            "status": "OK",
            "code": 200,
            "_postman_previewlanguage": "json",
            header: [
                {
                    "key": "Content-Type",
                    "value": "application/json"
                },
            ],
            body: apiEndpoint.example_response,
        });
    }

    // Provide back the postman schema data
    return postmanEndpointSchema;
}

/**
 * Get the base Postman collection schema data structure.
 * Contains auth data and variables.
 * @return {{item: *[], auth: {apikey: [{type: string, value: string, key: string},{type: string, value: string, key: string}], type: string}, variable: [{type: string, value: string, key: string},{type: string, value: string, key: string},{type: string, value: string, key: string}], event: [{listen: string, script: {type: string, exec: string[]}},{listen: string, script: {type: string, exec: string[]}}], info: {schema: string, name: string}}}
 */
function getBaseCollectionSchema() {
    return {
        info: {
            name: "BookStack REST API",
            schema: "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
        },
        item: [
        ],
        auth: {
            type: "apikey",
            apikey: [
                {
                    key: "value",
                    value: "Token {{TOKEN_ID}}:{{TOKEN_SECRET}}",
                    type: "string"
                },
                {
                    key: "key",
                    value: "Authorization",
                    type: "string"
                }
            ]
        },
        event: [
            {
                listen: "prerequest",
                script: {
                    type: "text/javascript",
                    exec: [
                        ""
                    ]
                }
            },
            {
                listen: "test",
                script: {
                    type: "text/javascript",
                    exec: [
                        ""
                    ]
                }
            }
        ],
        variable: [
            {
                key: "TOKEN_ID",
                value: "",
                type: "default"
            },
            {
                key: "TOKEN_SECRET",
                value: "",
                type: "default"
            },
            {
                key: "BASE_URL",
                value: "",
                type: "default"
            }
        ]
    };
}