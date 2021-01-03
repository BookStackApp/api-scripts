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

if (empty($bookSlug) || empty($outFolder)) {
    errorOut("Both a book slug and output folder must be provided");
}

if (!is_dir($outFolder)) {
    mkdir($outFolder, 0777, true);
}

$outDir = realpath($outFolder);
$book = getBookBySlug($bookSlug);

if (is_null($book)) {
    errorOut("Could not find book with the URL slug: {$bookSlug}");
}

$chapters = getAllOfAtListEndpoint("api/chapters", ['filter[book_id]' => $book['id']]);
$pages = getAllOfAtListEndpoint("api/pages", ['filter[book_id]' => $book['id']]);

foreach ($pages as $index => $page) {
    $pages[$index] = apiGetJson("api/pages/{$page['id']}");
}

if (!is_dir($outDir . "/images")) {
    mkdir($outDir . "/images", 0777, true);
}

$directBookPages = array_filter($pages, function($page) {
    return empty($page['chapter_id']);
});

// Create book index file
$bookIndex = getBookContent($book, $chapters, $directBookPages);
file_put_contents($outDir . "/index.html", $bookIndex);

foreach ($chapters as $chapter) {
    $childPages = array_filter($pages, function($page) use ($chapter) {
        return $page['chapter_id'] == $chapter['id'];
    });
    $chapterPage = getChapterContent($chapter, $childPages);
    file_put_contents($outDir . "/chapter-{$chapter['slug']}.html", $chapterPage);

    foreach ($childPages as $childPage) {
        $childPageContent = getPageContent($childPage, $chapter);
        $childPageContent = extractImagesFromHtml($childPageContent);
        file_put_contents($outDir . "/page-{$childPage['slug']}.html", $childPageContent);
    }
}

foreach ($directBookPages as $directPage) {
    $directPageContent = getPageContent($directPage, null);
    $directPageContent = extractImagesFromHtml($directPageContent);
    file_put_contents($outDir . "/page-{$directPage['slug']}.html", $directPageContent);
}

function extractImagesFromHtml(string $html): string {
    global $outDir;
    $matches = [];
    preg_match_all('/<img.*?src=["\'](.*?)[\'"].*?>/i', $html, $matches);
    foreach (array_unique($matches[1] ?? []) as $url) {
        $image = file_get_contents($url);
        $name = basename($url);
        $fileName = $name;
        $count = 1;
        while (file_exists($outDir . "/images/" . $fileName)) {
            $fileName = $count . '-' . $name;
        }
        file_put_contents($outDir . "/images/" . $fileName, $image);
        $html = str_replace($url, "./images/" . $fileName, $html);
    }
    return $html;
}

function getImageFile($url): string {
    global $apiUrl;
    if (strpos(strtolower($url), strtolower($apiUrl)) === 0) {
        $url = substr($url, strlen($apiUrl));
        return apiGet($url);
    }
    return file_get_contents($url);
}

function getBookContent(array $book, array $chapters, array $pages): string {
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

function getChapterContent(array $chapter, array $pages): string {
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

function getPageContent(array $page, ?array $parentChapter): string {
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

function errorOut(string $text) {
    echo "ERROR: " .  $text;
    exit(1);
}