# BookStack Data Exporter

This Ruby script allows you to export data from a BookStack instance into a CSV file. The exported data includes information about pages, books, and shelves, along with their respective URLs and modification dates.

## Prerequisites

Before running the script, make sure you have the following:

- Ruby installed on your system
- Access to a BookStack instance with API enabled
- BookStack API token ID and token secret

## Installation

1. Clone this repository or download the script file.
2. Install the required dependencies by running the following command:

   ```
   bundle install
   ```

3. Create a `.env` file in the same directory as the script and provide the following environment variables:

   ```
   BS_URL=<your_bookstack_url>
   BS_TOKEN_ID=<your_api_token_id>
   BS_TOKEN_SECRET=<your_api_token_secret>
   ```

   Replace `<your_bookstack_url>`, `<your_api_token_id>`, and `<your_api_token_secret>` with your actual BookStack URL, API token ID, and API token secret, respectively.

## Usage

To run the script and export the data, execute the following command:

```
ruby export_bookstack_data.rb
```

The script will retrieve data from your BookStack instance and generate a CSV file named `bookstack_data.csv` in the same directory.

## CSV Output

The generated CSV file will have the following columns:

- Type: Indicates whether the row represents a page or a book.
- ID: The unique identifier of the page or book.
- Name: The name of the page or book.
- URL: The URL of the page or book, formatted as an Excel hyperlink.
- Book ID: The ID of the book to which the page belongs (applicable only for pages).
- Book Name: The name of the book to which the page belongs (applicable only for pages).
- Book URL: The URL of the book, formatted as an Excel hyperlink (applicable only for pages).
- Shelf Name: The name of the shelf to which the book belongs.
- Date Modified: The last modification date of the page or book.

The URLs in the 'URL' and 'Book URL' columns are wrapped in the `=HYPERLINK()` function, allowing you to easily access the respective pages and books directly from the CSV file when opened in Excel.
HYPERLINK() - is an Excel shortcut to make URL clickable, feel free to remove, if you don't use Excel.

## Logging

Logging to STDOUT, but can be adjusted to a file.

## Example

Here's an example of how the generated CSV file might look.

```
Type,ID,Name,URL,Book ID,Book Name,Book URL,Shelf Name,Date Modified
Page,1,Introduction,=HYPERLINK("https://example.com/books/1/page/1"),1,User Guide,=HYPERLINK("https://example.com/books/1"),Getting Started,2023-05-01T10:00:00.000000Z
Page,2,Installation,=HYPERLINK("https://example.com/books/1/page/2"),1,User Guide,=HYPERLINK("https://example.com/books/1"),Getting Started,2023-05-02T11:30:00.000000Z
Book,1,User Guide,=HYPERLINK("https://example.com/books/1"),,,,Getting Started,2023-05-01T09:00:00.000000Z
```

## License

This script is released under the [MIT License](LICENSE).

Feel free to customize and adapt the script to suit your specific requirements.
