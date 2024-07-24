# Generate Tree

This script will scan through all pages, chapters books and shelves via the API to generate a big tree structure list in plaintext.

**This is a very simplistic single-script-file example of using the endpoints API together**
, it is not a fully-featured & validated script, it error handling is very limited.

Keep in mind, The tree generated will reflect content visible to the API user used when running the script.

This script follows a `((Shelves > Books > (Chapters > Pages | Pages)) | Books)` structure so books and their contents may be repeated if on multiple shelves. Books not on any shelves will be shown at the end.

## Requirements

You will need php (~8.1+) installed on the machine you want to run this script on.
You will also need BookStack API credentials (TOKEN_ID & TOKEN_SECRET) at the ready.

## Running

```bash
# Downloading the script
# ALTERNATIVELY: Clone the project from GitHub and run locally.
curl https://raw.githubusercontent.com/BookStackApp/api-scripts/main/php-generate-tree/generate-tree.php > generate-tree.php

# Setup
# ALTERNATIVELY: Open the script and edit the variables at the top.
export BS_URL=https://bookstack.example.com # Set to be your BookStack base URL
export BS_TOKEN_ID=abc123 # Set to be your API token_id
export BS_TOKEN_SECRET=123abc # Set to be your API token_secret

# Running the script
php generate-tree.php
```

## Examples

```bash
# Generate out the tree to the command line
php generate-tree.php

# Generate & redirect output to a file
php generate-tree.php > bookstack-tree.txt

# Generate with the output shown on the command line and write to a file
php generate-tree.php | tee bookstack-tree.txt
```

An example of the output can be seen in the [example.txt](./example.txt) file within the directory of this readme.