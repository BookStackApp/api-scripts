# Export All Books

This script will export all books in your preferred format (PDF, HTML or TXT).

## Requirements

You will need php (~7.1+) installed on the machine you want to run this script on.
You will also need BookStack API credentials (TOKEN_ID & TOKEN_SECRET) at the ready.

## Running

```bash
# Downloading the script
curl https://raw.githubusercontent.com/BookStackApp/api-scripts/main/php-export-all-books/export-books.php > export-books.php

# Setup
# ALTERNATIVELY: Open the script and edit the variables at the top.
export BS_URL=https://bookstack.example.com # Set to be your BookStack base URL
export BS_TOKEN_ID=abc123 # Set to be your API token_id
export BS_TOKEN_SECRET=123abc # Set to be your API token_secret

# Running the script
php export-books.php <format> <output_dir>
```

## Examples

```bash
# Export as plaintext to an existing "out" directory
php export-books.php plaintext ./out

# Export as pdf to the current directory
php export-books.php pdf ./

# Export as HTML to an existing "html" directory
php export-books.php html ./html
```