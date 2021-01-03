#!/usr/bin/env php
<?php

// API Credentials
// You can either provide them as environment variables
// or hard-code them in the empty strings below.
$apiUrl = getenv('BS_URL') ?: '';
$clientId = getenv('BS_TOKEN_ID') ?: '';
$clientSecret = getenv('BS_TOKEN_SECRET') ?: '';

// Output Folder
// Can be provided as a arguments when calling the script
// or be hard-coded as strings below.
$bookSlug = $argv[1] ?? '';
$outFolder = $argv[2] ?? './out';

// Script logic
////////////////

// Check we have required options
if (empty($bookSlug) || empty($outFolder)) {
    errorOut("Both a book slug and output folder must be provided");
}

// Create the output folder if it does not exist
if (!is_dir($outFolder)) {
    mkdir($outFolder, 0777, true);
}

// Get full output directory and book details
$outDir = realpath($outFolder);
$book = getBookBySlug($bookSlug);

// Error out if we don't have a book
if (is_null($book)) {
    errorOut("Could not find book with the URL slug: {$bookSlug}");
}

// Get all chapters and pages within the book
$chapters = getAllOfAtListEndpoint("api/chapters", ['filter[book_id]' => $book['id']]);
$pages = getAllOfAtListEndpoint("api/pages", ['filter[book_id]' => $book['id']]);

// Get the full content for each page
foreach ($pages as $index => $page) {
    $pages[$index] = apiGetJson("api/pages/{$page['id']}");
}

// Create the image output directory
if (!is_dir($outDir . "/images")) {
    mkdir($outDir . "/images", 0777, true);
}

// Find the pages that are not within a chapter
$directBookPages = array_filter($pages, function($page) {
    return empty($page['chapter_id']);
});

// Create book index file
$bookIndex = getBookHtmlOutput($book, $chapters, $directBookPages);
file_put_contents($outDir . "/index.html", $bookIndex);

// Create a HTML file for each chapter
// in addition to each page within those chapters
foreach ($chapters as $chapter) {
    $childPages = array_filter($pages, function($page) use ($chapter) {
        return $page['chapter_id'] == $chapter['id'];
    });
    $chapterPage = getChapterHtmlOutput($chapter, $childPages);
    file_put_contents($outDir . "/chapter-{$chapter['slug']}.html", $chapterPage);

    foreach ($childPages as $childPage) {
        $childPageContent = getPageHtmlOutput($childPage, $chapter);
        $childPageContent = extractImagesFromHtml($childPageContent);
        file_put_contents($outDir . "/page-{$childPage['slug']}.html", $childPageContent);
    }
}

// Create a file for each direct child book page
foreach ($directBookPages as $directPage) {
    $directPageContent = getPageHtmlOutput($directPage, null);
    $directPageContent = extractImagesFromHtml($directPageContent);
    file_put_contents($outDir . "/page-{$directPage['slug']}.html", $directPageContent);
}

/**
 * Scan the given HTML for image URL's and extract those images
 * to save them locally and update the HTML references to point
 * to the local files.
 */
function extractImagesFromHtml(string $html): string {
    global $outDir;
    static $savedImages = [];
    $matches = [];
    preg_match_all('/<img.*?src=["\'](.*?)[\'"].*?>/i', $html, $matches);
    foreach (array_unique($matches[1] ?? []) as $url) {
        $image = getImageFile($url);
        if ($image === false) {
            continue;
        }

        $name = basename($url);
        $fileName = $name;
        $count = 1;
        while (isset($savedImages[$fileName])) {
            $fileName = $count . '-' . $name;
            $count++;
        }

        $savedImages[$fileName] = true;
        file_put_contents($outDir . "/images/" . $fileName, $image);
        $html = str_replace($url, "./images/" . $fileName, $html);
    }
    return $html;
}

/**
 * Get an image file from the given URL.
 * Checks if it's hosted on the same instance as the API we're
 * using so that auth details can be provided for BookStack images
 * in case local_secure images are in use.
 */
function getImageFile(string $url): string {
    global $apiUrl;
    if (strpos(strtolower($url), strtolower($apiUrl)) === 0) {
        $url = substr($url, strlen($apiUrl));
        return apiGet($url);
    }
    return @file_get_contents($url);
}

/**
 * Get the HTML representation of a book.
 */
function getBookHtmlOutput(array $book, array $chapters, array $pages): string {
    $content = "<h1>{$book['name']}</h1>";
    $content .= "<p>{$book['description']}</p>";
    $content .= "<hr>";
    if (count($chapters) > 0) {
        $content .= "<h3>Chapters</h3><ul>";
        foreach ($chapters as $chapter) {
            $content .= "<li><a href='./chapter-{$chapter['slug']}.html'>{$chapter['name']}</a></li>";
        }
        $content .= "</ul>";
    }
    if (count($pages) > 0) {
        $content .= "<h3>Pages</h3><ul>";
        foreach ($pages as $page) {
            $content .= "<li><a href='./page-{$page['slug']}.html'>{$page['name']}</a></li>";
        }
        $content .= "</ul>";
    }
    return $content;
}

/**
 * Get the HTML representation of a chapter.
 */
function getChapterHtmlOutput(array $chapter, array $pages): string {
    $content = "<p><a href='./index.html'>Back to book</a></p>";
    $content .= "<h1>{$chapter['name']}</h1>";
    $content .= "<p>{$chapter['description']}</p>";
    $content .= "<hr>";
    if (count($pages) > 0) {
        $content .= "<h3>Pages</h3><ul>";
        foreach ($pages as $page) {
            $content .= "<li><a href='./page-{$page['slug']}.html'>{$page['name']}</a></li>";
        }
        $content .= "</ul>";
    }
    return $content;
}

/**
 * Get the HTML representation of a page.
 */
function getPageHtmlOutput(array $page, ?array $parentChapter): string {
    if (is_null($parentChapter)) {
        $content = "<p><a href='./index.html'>Back to book</a></p>";
    } else {
        $content = "<p><a href='./chapter-{$parentChapter['slug']}.html'>Back to chapter</a></p>";
    }
    $content .= "<h1>{$page['name']}</h1>";
    $content .= "<div>{$page['html']}</div>";
    return $content;
}

/**
 * Get a single book by the slug or return null if not exists.
 */
function getBookBySlug(string $slug): ?array {
    $endpoint = 'api/books?' . http_build_query(['filter[slug]' => $slug]);
    $resp = apiGetJson($endpoint);
    $book = $resp['data'][0] ?? null;

    if (!is_null($book)) {
        $book = apiGetJson("api/books/{$book['id']}") ?? null;
    }
    return $book;
}

/**
 * Get all books from the system API.
 */
function getAllOfAtListEndpoint(string $endpoint, array $params): array {
    $count = 100;
    $offset = 0;
    $total = 0;
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
function apiGet(string $endpoint): string {
    global $apiUrl, $clientId, $clientSecret;
    $url = rtrim($apiUrl, '/') . '/' . ltrim($endpoint, '/');
    $opts = ['http' => ['header' => "Authorization: Token {$clientId}:{$clientSecret}"]];
    $context = stream_context_create($opts);
    return @file_get_contents($url, false, $context);
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

/**
 * Alert of an error then exit the script.
 */
function errorOut(string $text) {
    echo "ERROR: " .  $text;
    exit(1);
}