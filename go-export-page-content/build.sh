#!/bin/sh

GOOS=windows GOARCH=amd64 go build -ldflags "-s -w" -o bin/bookstack-export.exe
GOOS=linux GOARCH=amd64 go build -ldflags "-s -w" -o bin/bookstack-export
GOOS=darwin GOARCH=amd64 go build -ldflags "-s -w" -o bin/bookstack-export-macos

upx bin/*