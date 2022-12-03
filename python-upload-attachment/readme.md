# Upload a file attachment to a BookStack page

This script will take a path to any local file and attempt
to upload it to a BookStack page as an attachment
using the API using a multipart/form-data request.

This is a simplistic example of a Python script. You will likely want to
alter and extend this script to suit your use-case.

This was written without in-depth knowledge of Python nor experience
of Python common conventions, so the style and approaches may appear unconventional.

## Requirements

You will need Python 3 installed (3.10.7).
This also uses pip to import requests as a dependency. 

## Running

First, download all the files in the same directory as this readme to a folder on your system
and run the below from within that directory.

```bash
# Install dependencies via PIP
pip install -r requirements.txt

# Setup
# ALTERNATIVELY: Open the script and add to the empty strings in the variables at the top.
export BS_URL=https://bookstack.example.com # Set to be your BookStack base URL
export BS_TOKEN_ID=abc123 # Set to be your API token_id
export BS_TOKEN_SECRET=123abc # Set to be your API token_secret

# Running the script
python main.py <page_id> <file_path>
```

- `<page_id>` - The ID of the page you want to upload the attachment to.
- `<file_path>` - File you want to upload as an attachment.
        
## Examples

```bash
# Upload the 'cat-image-collection.zip' file as an attachment to page of ID 205
python main.py 205 ./cat-image-collection.zip
```