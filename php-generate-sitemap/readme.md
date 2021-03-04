# Generate Sitemap

This script will scan through all pages, chapters books and shelves via the API to generate a sitemap XML file.

**This is a very simplistic single-script-file example of using the endpoints API together**
, it is not a fully-featured & validated script. 

Keep in mind, The sitemap generated will reflect content visible to the API user used when running the script. 

## Requirements

You will need php (~7.2+) installed on the machine you want to run this script on.
You will also need BookStack API credentials (TOKEN_ID & TOKEN_SECRET) at the ready.

## Running

```bash
# Downloading the script
# ALTERNATIVELY: Clone the project from GitHub and run locally.
curl https://raw.githubusercontent.com/BookStackApp/api-scripts/main/php-generate-sitemap/generate-sitemap.php > generate-sitemap.php

# Setup
# ALTERNATIVELY: Open the script and edit the variables at the top.
export BS_URL=https://bookstack.example.com # Set to be your BookStack base URL
export BS_TOKEN_ID=abc123 # Set to be your API token_id
export BS_TOKEN_SECRET=123abc # Set to be your API token_secret

# Running the script
php generate-sitemap.php <output_file_name>
```

## Examples

```bash
# Create a sitemap called "sitemap.xml within the current directory
php generate-sitemap.php ./sitemap.xml
```