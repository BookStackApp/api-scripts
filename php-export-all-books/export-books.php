#!/usr/bin/env php
<?php

// API Credentials
// You can either provide them as environment variables
// or hard-code them in the empty strings below.
$apiUrl = getenv('BS_URL') ?: ''; // http://bookstack.local/
$clientId = getenv('BS_TOKEN_ID') ?: '';
$clientSecret = getenv('BS_TOKEN_SECRET') ?: '';

// Export Format & Location
// Can be provided as a arguments when calling the script
// or be hard-coded as strings below.
$exportFormat = $argv[1] ?? 'pdf';
$exportLocation = $argv[2] ?? './';

// Script logic
////////////////

$books = getAllBooks();
$outDir = realpath($exportLocation);

$extensionByFormat = [
    'pdf' => 'pdf',
    'html' => 'html',
    'plaintext' => 'txt',
];

foreach ($books as $book) {
    $id = $book['id'];
    $extension = $extensionByFormat[$exportFormat] ?? $exportFormat;
    $content = apiGet("api/books/{$id}/export/{$exportFormat}");
    $outPath = $outDir  . "/{$book['slug']}.{$extension}";
    file_put_contents($outPath, $content);
}

/**
 * Get all books from the system API.
 */
function getAllBooks() {
    $count = 100;
    $offset = 0;
    $total = 0;
    $allBooks = [];

    do {
        $endpoint = 'api/books?' . http_build_query(['count' => $count, 'offset' => $offset]);
        $resp = apiGetJson($endpoint);

        // Only set total on first request, due to API bug:
        // https://github.com/BookStackApp/BookStack/issues/2043
        if ($offset == 0) {
            $total = $resp['total'] ?? 0;
        }

        $newBooks = $resp['data'] ?? [];
        array_push($allBooks, ...$newBooks);
        $offset += $count;
    } while ($offset < $total);

    return $allBooks;
}

/**
 * Make a simple GET HTTP request to the API.
 */
function apiGet(string $endpoint): string {
    global $apiUrl, $clientId, $clientSecret;
    $url = rtrim($apiUrl, '/') . '/' . ltrim($endpoint, '/');
    $opts = ['http' => ['header' => "Authorization: Token {$clientId}:{$clientSecret}"]];
    $context = stream_context_create($opts);
    return file_get_contents($url, false, $context);
}

/**
 * Make a simple GET HTTP request to the API &
 * decode the JSON response to an array.
 */
function apiGetJson(string $endpoint): array {
    $data = apiGet($endpoint);
    return json_decode($data, true);
}

/**
 * DEBUG: Dump out the given variables and exit.
 */
function dd(...$args) {
    foreach ($args as $arg) {
        var_dump($arg);
    }
    exit(1);
}