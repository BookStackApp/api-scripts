#!/usr/bin/env php
<?php

// API Credentials
// You can either provide them as environment variables
// or hard-code them in the empty strings below.
$baseUrl = getenv('BS_URL') ?: '';
$clientId = getenv('BS_TOKEN_ID') ?: '';
$clientSecret = getenv('BS_TOKEN_SECRET') ?: '';

// Output File
// Can be provided as a arguments when calling the script
// or be hard-coded as strings below.
$outputFile = $argv[1] ?? './sitemap.xml';

// Script logic
////////////////

// Check we have required options
if (empty($outputFile)) {
    errorOut("An output file needs to be provided");
}

// Create the output folder if it does not exist
$outDir = dirname($outputFile);
if (!is_dir($outDir)) {
    mkdir($outDir, 0777, true);
}

// Clean up the base path
$baseUrl = rtrim($baseUrl, '/');

// Additional endpoints not fetched via API entities
$additionalEndpoints = [
    '/',
    '/books',
    '/search',
    '/login',
];

// Get all shelf URLs
$shelves = getAllOfAtListEndpoint("api/shelves", []);
$shelfEndpoints = array_map(function ($shelf) {
    return '/shelves/' . $shelf['slug'];
}, $shelves);

// Get all book URLs and map for chapters & pages
$books = getAllOfAtListEndpoint("api/books", []);
$bookSlugsById = [];
$bookEndpoints = array_map(function ($book) use (&$bookSlugsById) {
    $bookSlugsById[$book['id']] = $book['slug'];
    return '/books/' . $book['slug'];
}, $books);

// Get all chapter URLs and map for pages
$chapters = getAllOfAtListEndpoint("api/chapters", []);
$chapterEndpoints = array_map(function ($chapter) use ($bookSlugsById) {
    $bookSlug = $bookSlugsById[$chapter['book_id']];
    return '/books/' . $bookSlug . '/chapter/' . $chapter['slug'];
}, $chapters);

// Get all page URLs
$pages = getAllOfAtListEndpoint("api/pages", []);
$pageEndpoints = array_map(function ($page) use ($bookSlugsById) {
    $bookSlug = $bookSlugsById[$page['book_id']];
    return '/books/' . $bookSlug . '/page/' . $page['slug'];
}, $pages);

// Gather all our endpoints
$allEndpoints = $additionalEndpoints
    + $pageEndpoints
    + $chapterEndpoints
    + $bookEndpoints
    + $shelfEndpoints;

// Fetch our sitemap XML
$xmlSitemap = generateSitemapXml($allEndpoints);
// Write to the output file
file_put_contents($outputFile, $xmlSitemap);

/**
 * Generate out the XML content for a sitemap
 * for the given URLs.
 */
function generateSitemapXml(array $endpoints): string
{
    global $baseUrl;
    $nowDate = date_format(new DateTime(), 'Y-m-d');
    $doc = new DOMDocument("1.0", "UTF-8");
    $urlset = $doc->createElement('urlset');
    $urlset->setAttribute('xmlns', 'http://www.sitemaps.org/schemas/sitemap/0.9');

    $doc->appendChild($urlset);
    foreach ($endpoints as $endpoint) {
        $url = $doc->createElement('url');
        $loc = $url->appendChild($doc->createElement('loc'));
        $urlText = $doc->createTextNode($baseUrl . $endpoint);
        $loc->appendChild($urlText);
        $url->appendChild($doc->createElement('lastmod', $nowDate));
        $url->appendChild($doc->createElement('changefreq', 'monthly'));
        $url->appendChild($doc->createElement('priority', '0.8'));
        $urlset->appendChild($url);
    }

    return $doc->saveXML();
}

/**
 * Consume all items from the given API listing endpoint.
 */
function getAllOfAtListEndpoint(string $endpoint, array $params): array
{
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
    return json_decode($data, true);
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

/**
 * Alert of an error then exit the script.
 */
function errorOut(string $text)
{
    echo "ERROR: " . $text;
    exit(1);
}