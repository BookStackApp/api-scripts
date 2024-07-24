#!/usr/bin/env php
<?php

// API Credentials
// You can either provide them as environment variables
// or hard-code them in the empty strings below.
$baseUrl = getenv('BS_URL') ?: '';
$clientId = getenv('BS_TOKEN_ID') ?: '';
$clientSecret = getenv('BS_TOKEN_SECRET') ?: '';

// Script logic
////////////////

// Define the time we wait in between making API requests,
// to help keep within rate limits and avoid exhausting resources.
$apiPauseMicrosecs = 100;

// Clean up the base path
$baseUrl = rtrim($baseUrl, '/');

// Get all items from the system keyed by ID
$shelvesById = keyById(getAllOfAtListEndpoint("api/shelves", []));
$booksById = keyById(getAllOfAtListEndpoint("api/books", []));

// Fetch books that are on each shelf
foreach ($shelvesById as $id => $shelf) {
    $shelvesById[$id]['books'] = getBooksForShelf($id);
    usleep($apiPauseMicrosecs);
}

// For each book, fetch its contents list
foreach ($booksById as $id => $book) {
    $booksById[$id]['contents'] = apiGetJson("api/books/{$id}")['contents'] ?? [];
    usleep($apiPauseMicrosecs);
}

// Cycle through the shelves and display their contents
$isBookShownById = [];
foreach ($shelvesById as $id => $shelf) {
    output($shelf, 'bookshelf', [false]);
    $bookCount = count($shelf['books']);
    for ($i=0; $i < $bookCount; $i++) {
        $bookId = $shelf['books'][$i];
        $book = $booksById[$bookId] ?? null;
        if ($book) {
            outputBookAndContents($book, [false, $i === $bookCount - 1]);
            $isBookShownById[strval($book['id'])] = true;
        }
    }
}

// Cycle through books and display any that have not been
// part of a shelve's output
foreach ($booksById as $id => $book) {
    if (isset($isBookShownById[$id])) {
        continue;
    }

    outputBookAndContents($book, [false]);
}

/**
 * Output a book for display, along with its contents.
 */
function outputBookAndContents(array $book, array $depthPath): void
{
    output($book, 'book', $depthPath);
    $childCount = count($book['contents']);
    for ($i=0; $i < $childCount; $i++) {
        $child = $book['contents'][$i];
        $childPath = array_merge($depthPath, [($i === $childCount - 1)]);
        output($child, $child['type'], $childPath);
        $pages = $child['pages'] ?? [];
        $pageCount = count($pages);
        for ($j=0; $j < count($pages); $j++) { 
            $page = $pages[$j];
            $innerPath = array_merge($childPath, [($j === $pageCount - 1)]);
            output($page, 'page', $innerPath);
        }
    }
}

/**
 * Output a single item for display.
 */
function output(array $item, string $type, array $depthPath): void
{
    $upperType = strtoupper($type);
    $prefix = '';
    $depth = count($depthPath);
    for ($i=0; $i < $depth; $i++) { 
        $isLastAtDepth = $depthPath[$i];
        $end = ($i === $depth - 1);
        if ($end) {
            $prefix .= $isLastAtDepth ? '└' : '├';
        } else {
            $prefix .= $isLastAtDepth ? '    ' : '│   ';
        }
    }
    echo $prefix . "── {$upperType} {$item['id']}: {$item['name']}\n";
}

/**
 * Key an array of array-based data objects by 'id' value. 
 */
function keyById(array $data): array 
{
    $byId = [];
    foreach ($data as $item) { 
        $id = $item['id'];
        $byId[$id] = $item;
    }
    return $byId;
}

/**
 * Get the books for the given shelf ID.
 * Returns an array of the book IDs.
 */
function getBooksForShelf(int $shelfId): array
{
    $resp = apiGetJson("api/shelves/{$shelfId}");
    return array_map(function ($bookData) {
        return $bookData['id'];
    }, $resp['books'] ?? []);
}

/**
 * Consume all items from the given API listing endpoint.
 */
function getAllOfAtListEndpoint(string $endpoint, array $params): array
{
    global $apiPauseMicrosecs;
    $count = 100;
    $offset = 0;
    $all = [];

    do {
        $endpoint = $endpoint . '?' . http_build_query(array_merge($params, ['count' => $count, 'offset' => $offset]));
        $resp = apiGetJson($endpoint);

        $total = $resp['total'] ?? 0;
        $new = $resp['data'] ?? [];
        array_push($all, ...$new);
        $offset += $count;
        usleep($apiPauseMicrosecs);
    } while ($offset < $total);

    return $all;
}

/**
 * Make a simple GET HTTP request to the API.
 */
function apiGet(string $endpoint): string
{
    global $baseUrl, $clientId, $clientSecret;
    $url = rtrim($baseUrl, '/') . '/' . ltrim($endpoint, '/');
    $opts = ['http' => ['header' => "Authorization: Token {$clientId}:{$clientSecret}"]];
    $context = stream_context_create($opts);
    return @file_get_contents($url, false, $context);
}

/**
 * Make a simple GET HTTP request to the API &
 * decode the JSON response to an array.
 */
function apiGetJson(string $endpoint): array
{
    $data = apiGet($endpoint);
    $array = json_decode($data, true);

    if (!is_array($array)) {
        dd("Failed request to {$endpoint}", $data);
    }

    return $array;
}

/**
 * DEBUG: Dump out the given variables and exit.
 */
function dd(...$args)
{
    foreach ($args as $arg) {
        var_dump($arg);
    }
    exit(1);
}