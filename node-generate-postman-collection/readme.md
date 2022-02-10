# Generate Postman Collection

This script will scan the BookStack API documentation and generate
out an importable collection for [Postman](https://www.postman.com/).

**Note:** This has been built quite hastily so the output may not be
100% accurate but should massively speed up most use-cases.

[An example of the output can be found here](https://gist.githubusercontent.com/ssddanbrown/de805abfdf1a1defb54500055de5e7ea/raw/7ec246a4d140c98313f3bcda00e1bac6d9e68b68/bs.postman_collection.json).

The output collection will contain a folder for each of the API categories.
Collection variables are used to configure the API base url, token ID
and token secret. 

## Requirements

You will need NodeJS installed (Tested on v16, may work on earlier versions).

## Running

First, download all the files in the same directory as this readme to a folder on your system
and run the below from within that directory.

```bash
# Install NodeJS dependencies via NPM
npm install 

# Setup
# ALTERNATIVELY: Open the script and add to the empty strings in the variables at the top.
export BS_URL=https://bookstack.example.com # Set to be your BookStack base URL
export BS_TOKEN_ID=abc123 # Set to be your API token_id
export BS_TOKEN_SECRET=123abc # Set to be your API token_secret

# Running the script
node index.js
```

The script outputs stdout on the command line, so you'll most likely want to redirect the output to a file.
        
## Examples

```bash
# Generate the collection to a 'bookstack.postman_collection.json' file. 
node index.js > bookstack.postman_collection.json
```