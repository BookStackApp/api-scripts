extern crate core;

use serde::{Deserialize, Serialize};
use std::thread::sleep;
use std::time::Duration;
use std::{env, process};

fn main() {
    // Gather and validate our credentials
    let credentials = ApiCredentials::from_env();
    match credentials.validate() {
        Ok(()) => (),
        Err(issues) => {
            for issue in issues {
                eprintln!("Error found in API credentials: {}", issue)
            }
            process::exit(1)
        }
    }

    // Get all our pages from the BookStack API and list them out
    let pages = get_all_pages(credentials);
    for page in pages {
        println!("ID={}; Name={}", page.id, page.name);
    }
}

// Get all pages from the BookStack instance
fn get_all_pages(credentials: ApiCredentials) -> Vec<BookStackPage> {
    // Create a new vector of pages to contain results
    let mut results: Vec<BookStackPage> = Vec::new();

    // Variables to track and perform API endpoint paging
    let mut total = 100;
    let mut offset = 0;
    let page_size = 500;

    // Make API requests while there's still data to retrieve
    while offset < total {
        // Delay to respect rate limits
        if offset > 0 {
            sleep(Duration::from_millis(500));
        }

        let response: BookStackApiListingResult<BookStackPage> =
            get_page_of_pages(&credentials, page_size, offset);

        // Update our paging variables
        total = response.total;
        offset += page_size;

        // Append the fetched data to our results
        results.append(&mut response.data.clone());
    }

    return results;
}

// Get a single listing page of "pages" from the BookStack API
fn get_page_of_pages(
    credentials: &ApiCredentials,
    page_size: i64,
    offset: i64,
) -> BookStackApiListingResult<BookStackPage> {
    // Build our API endpoint to call
    let endpoint = format!(
        "{}/api/pages?count={}&offset={}",
        credentials.url, page_size, offset
    );

    // Build the authorization header value to authenticate with the BookStack API
    let auth_header_val = format!(
        "Token {}:{}",
        credentials.token_id, credentials.token_secret
    );

    // Create a client for making API requests
    let api = reqwest::blocking::Client::new();

    // Perform the API request
    let api_result = api
        .get(endpoint)
        .header("Authorization", auth_header_val)
        .send();

    // Gather, parse and return our response data
    let response: BookStackApiListingResult<BookStackPage> = api_result.unwrap().json().unwrap();
    return response;
}

// A struct to represent a BookStack API listing response
#[derive(Default, Debug, Clone, PartialEq, Serialize, Deserialize)]
struct BookStackApiListingResult<T> {
    data: Vec<T>,
    total: i64,
}

// A struct to represent a BookStack page provided via an API listing response
#[derive(Default, Debug, Clone, PartialEq, Serialize, Deserialize)]
struct BookStackPage {
    id: i64,
    book_id: i64,
    chapter_id: i64,
    name: String,
    slug: String,
    priority: i64,
    draft: bool,
    template: bool,
    created_at: String,
    updated_at: String,
    created_by: i64,
    updated_by: i64,
    owned_by: i64,
}

// A struct to hold BookStack API details
struct ApiCredentials {
    url: String,
    token_id: String,
    token_secret: String,
}

impl ApiCredentials {
    // Construct ApiCredentials by reading from possible environment variables
    fn from_env() -> ApiCredentials {
        let mut credentials = ApiCredentials {
            url: String::from(""),
            token_id: String::from(""),
            token_secret: String::from(""),
        };

        credentials.url = match env::var("BS_URL") {
            Ok(val) => val,
            Err(_e) => credentials.url,
        };

        credentials.token_id = match env::var("BS_TOKEN_ID") {
            Ok(val) => val,
            Err(_e) => credentials.token_id,
        };

        credentials.token_secret = match env::var("BS_TOKEN_SECRET") {
            Ok(val) => val,
            Err(_e) => credentials.token_secret,
        };

        return credentials;
    }

    // Validate the current set API credentials
    fn validate(&self) -> Result<(), Vec<String>> {
        let mut issues: Vec<String> = Vec::new();

        if self.url.is_empty() {
            issues.push("API Base URL not set!".to_string());
        }

        if self.token_id.is_empty() {
            issues.push("API Token ID not set!".to_string());
        }

        if self.token_secret.is_empty() {
            issues.push("API Token Secret not set!".to_string());
        }

        if !issues.is_empty() {
            return Err(issues);
        }

        Ok(())
    }
}
