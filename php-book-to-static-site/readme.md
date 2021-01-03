# Book to Static Site

This script will export all chapters and pages within a given book to a folder
of basic HTML and image files which could act as a static site.

Once ran, you should be able to open `index.html` within the output folder to start browsing.

**This is a very simplistic single-script-file example of using the book, chapter and pages
API together**, the output lacks a lot of detail including styling and inter-content link transforming. 

## Requirements

You will need php (~7.2+) installed on the machine you want to run this script on.
You will also need BookStack API credentials (TOKEN_ID & TOKEN_SECRET) at the ready.

## Running

```bash
# Downloading the script
curl https://raw.githubusercontent.com/BookStackApp/api-scripts/main/php-book-to-static-site/book-to-static.php > book-to-static.php

# Setup
# ALTERNATIVELY: Open the script and edit the variables at the top.
export BS_URL=https://bookstack.example.com # Set to be your BookStack base URL
export BS_TOKEN_ID=abc123 # Set to be your API token_id
export BS_TOKEN_SECRET=123abc # Set to be your API token_secret

# Running the script
php book-to-static.php <book_url_slug> <output_dir>
```

## Examples

```bash
# Export a book with URL slug of my_book to an "out" directory
php book-to-static.php my_book ./out
```