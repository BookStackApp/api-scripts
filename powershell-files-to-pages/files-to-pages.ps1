# We receive the book ID as an argument from when the script is ran.
# This will be the ID of the book we're uploaded pages into.
param(
    [Parameter(Mandatory=$true)]
    [string]$parentBookId
)

# BookStack API variables
# Uses values from the environment otherwise could be hardcoded here
$baseUrl = $env:BS_URL
$tokenId = $env:BS_TOKEN_ID
$tokenSecret = $env:BS_TOKEN_SECRET

# Function to create a page in BookStack
function Create-BookstackPage {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Name,

        [Parameter(Mandatory=$true)]
        [string]$Html,

        [Parameter(Mandatory=$true)]
        [int]$BookId
    )

    # Create the data to send to the API
    $body = @{
        name = $Name
        html = $Html
        book_id = $BookId
    } | ConvertTo-Json

    # Ready the HTTP headers, including our auth header
    $authHeader = "Token {0}:{1}" -f $tokenId, $tokenSecret
    $headers = @{
        "Content-Type" = "application/json"
        "Authorization" = $authHeader
    }

    # Send the request to our API endpoint as a POST request
    $url = "{0}/api/pages" -f $baseUrl
    Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $body
}

# Get the html files in the relative "./files" directory
$files = Get-ChildItem -Path ".\files" -Filter "*.html" -File

# For each of our HTML files, get the file data and name
# then create a page with name matching the filename
# and HTML content using the contents of the file.
foreach ($file in $files) {
    $fileContent = Get-Content -Path $file.FullName
    Create-BookStackPage $file.Name $fileContent $parentBookId
}

