# List All Pages

This project, written in [Rust](https://www.rust-lang.org/), will list out all pages in a BookStack instance in the following format:

```txt
ID=1; Name=My Page
ID=2; Name=Another Page
ID=3; Name=Custom Homepage page
...
```

Note: This is only provided as an example. The project lacks full error handling, performing non-sync blocking requests & timeouts, and was written with only beginner rust knowledge.

## Requirements

Rust, and it's tooling, is required to build this project. 
You will also need BookStack API credentials at the ready.

This was built with the following versions:

- cargo 1.61.0 (a028ae4 2022-04-29)
- rustc 1.61.0 (fe5b13d68 2022-05-18)

## Running & Building

```bash
# Clone down the api-scripts repo and enter this directory
git clone https://github.com/BookStackApp/api-scripts.git
cd api-scripts/rust-list-all-pages

# Run the project
cargo run

# Build and run the project
cargo build -r
./target/release/rust-list-all-pages
```

## API Configuration

You'll need to provide your API credentials for this application to find and access your BookStack instance.
By default, it will look for `BS_URL`, `BS_TOKEN_ID`, `BS_TOKEN_SECRET` environment variables.
You can expose this within your current shell environment by using something like the below:

```bash
export BS_URL=https://bookstack.example.com # Set to be your BookStack base URL, excluding any trailing `/api`
export BS_TOKEN_ID=abc123 # Set to be your API token_id
export BS_TOKEN_SECRET=123abc # Set to be your API token_secret
```

Alternatively, before building/running, you could edit the `src/main.rs` file and edit the values in the `ApiCredentials::from_env` function to hard-code your values.