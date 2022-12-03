import os
import sys
import requests

# This is where BookStack API details can be hard-coded if you prefer
# to write them in this script instead of using environment variables.
default_bookstack_options = {
    "url": "",
    "token_id": "",
    "token_secret": "",
}


# Gather the BookStack API options either from the hard-coded details above otherwise
# it defaults back to environment variables.
def gather_api_options() -> dict:
    return {
        "url": default_bookstack_options["url"] or os.getenv("BS_URL"),
        "token_id": default_bookstack_options["token_id"] or os.getenv("BS_TOKEN_ID"),
        "token_secret": default_bookstack_options["token_secret"] or os.getenv("BS_TOKEN_SECRET"),
    }


# Send a multipart post request to BookStack, at the given endpoint with the given data.
def bookstack_post_multipart(endpoint: str, data: dict) -> dict:
    # Fetch the API-specific options
    bs_api_opts = gather_api_options()

    # Format the request URL and the authorization header, so we can access the API
    request_url = bs_api_opts["url"].rstrip("/") + "/api/" + endpoint.lstrip("/")
    request_headers = {
        "Authorization": "Token {}:{}".format(bs_api_opts["token_id"], bs_api_opts["token_secret"])
    }

    # Make the request to bookstack with the gathered details
    response = requests.post(request_url, headers=request_headers, files=data)

    # Throw an error if the request was not successful
    response.raise_for_status()

    # Return the response data decoded from it's JSON format
    return response.json()


# Error out and exit the app
def error_out(message: str):
    print(message)
    exit(1)


# Run this when called on command line
if __name__ == '__main__':

    # Check arguments provided
    if len(sys.argv) < 3:
        error_out("Both <page_id> and <file_path> arguments need to be provided")

    # Gather details from the command line arguments and create a file name
    # from the file path
    page_id = sys.argv[1]
    file_path = sys.argv[2]
    file_name = os.path.basename(file_path)

    # Ensure the file exists
    if not os.path.isfile(file_path):
        error_out("Could not find provided file: {}".format(file_path))

    # Gather the data we'll be sending to BookStack.
    # The format matches that what the "requests" library expects
    # to be provided for its "files" parameter.
    post_data = {
        "file": open(file_path, "rb"),
        "name": (None, file_name),
        "uploaded_to": (None, page_id)
    }

    # Send the upload request and get back the attachment data
    try:
        attachment = bookstack_post_multipart("/attachments", post_data)
    except requests.HTTPError as e:
        error_out("Upload failed with status {} and data: {}".format(e.response.status_code, e.response.text))

    # Output the results
    print("File successfully uploaded to page {}.".format(page_id))
    print(" - Attachment ID: {}".format(attachment['id']))
    print(" - Attachment Name: {}".format(attachment['name']))
