# BookStack in Google Search Results Chrome Extension

This is a very rough and simplistic example of a Google chrome extension that will inject BookStack 
search results into the page when making google.com searches.

**This is only meant as an example or foundation**, it is not a fully featured/finished/tested extension.
The styles are quite bad and it may be prone to breaking. I am not looking to improve or expand this extension
so PRs, unless minor issue fixes, will not be accepted. 

If you look to build this out into a proper chrome-store extension, please don't use the "BookStack" name
or logo alone and make it clear your extension is unofficial.

## Requirements

You will need a Chrome (or Chromium based browser) instance where you can enable developer mode in extensions.
You will also need BookStack API credentials (TOKEN_ID & TOKEN_SECRET) at the ready.

## Usage

This extension is not on the app store but you can side-load it with relative ease. 
Within chrome:

- Go to "Manage Extensions"
- Toggle "Developer mode" on.
- Click the "Load unpacked" option.
- Select this folder.

You will need to configure the extension options and fill in your BookStack instance API details.
You can get to this by right-clicking the extension in the top of the browser and clicking "Options", or via "Manage Extension" > Click "Details" on the extension > "Extension Options".