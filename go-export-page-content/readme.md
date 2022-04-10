# Export Page Content

This project, written in Go, will export all page content in its original written form (HTML or Markdown).
Content will be written into a directory structure that mirrors the page's location within the BookStack content hierarchy (Book > Chapter > Page).

Note: This is only provided as an example. The project lacks full error handling and also disables HTTPS verification for easier use with self-signed certificates.

This project uses timeouts, and lacks async requesting, to respect potential rate limits.

## Requirements

[Go](https://go.dev/) is required to build this project.
This project was built and tested using Go 1.18.

You will need your BookStack API credentials at the ready.

## Building

```bash
# Clone down the api-scripts repo and enter this directory
git clone https://github.com/BookStackApp/api-scripts.git
cd api-scripts/go-export-page-content
go build
```

This will output a `bookstack-export` executable file.

A `build.sh` script is provided to build compressed binaries for multiple platforms.
This requires `upx` for the compression element.

## Running

You can run the project by running the executable file like so:

```bash
./bookstack-export --baseurl=https://bookstack.example.com --tokenid=abc123 --tokensecret=def456
```

By default, this will output to a `page-export` directory within the current working directory.
You can define the output directory via a `--exportdir=<dir>` option.