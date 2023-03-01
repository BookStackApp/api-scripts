# Create BookStack Pages from HTML Files

This script will scan through a local `files/` directory for `*.html` files then create pages for each within BookStack, where the name of the files is used for the name of the page and the contents of the file is used for the BookStack page content.

**Note:** This is a very simplistic single-script-file example of sending data via PowerShell and was written with little prior PowerShell knowledge.

## Requirements

You will need PowerShell available.
You will also need BookStack API credentials (TOKEN_ID & TOKEN_SECRET) at the ready.

*This script was written using PowerShell (Core) 7.2.10 on Linux".*

A `docker-compose.yml` file exists just as a convenient way to run PowerShell, particularly for Linux users. 

## Running

First of all, download the `files-to-pages.ps1` script file.
Then you'll need to setup your environment to point to your BookStack instance with the right credentials:

```powershell
# Environment Setup
# ALTERNATIVELY: Open the script and edit the variables at the top
Set-Item -Path env:BS_URL -Value "https://bookstack.example.com" # Set to be your BookStack base URL
Set-Item -Path env:BS_TOKEN_ID -Value "abc123" # Set to be your API token_id
Set-Item -Path env:BS_TOKEN_SECRET -Value "123abc" # Set to be your API token_secret
```

Once configured, then create a `files` folder containing HTML files you want to upload as pages. See the `files` directory of this repo as a very basic example.
Now it's time to run the script like so:

```powershell
./files-to-pages.ps1 <target_book_id>
```

## Example

```powershell
# Upload HTML files in the relative `files` directory as BookStack pages
# into the existing BookStack "Book" that has an ID of 5:
./files-to-pages.ps1 5
```