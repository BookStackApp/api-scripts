package main

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"time"
)

func main() {

	baseUrlPtr := flag.String("baseurl", "", "The base URL of your BookStack instance")
	tokenId := flag.String("tokenid", "", "Your BookStack API Token ID")
	tokenSecret := flag.String("tokensecret", "", "Your BookStack API Token Secret")
	exportDir := flag.String("exportdir", "./page-export", "The directory to store exported data")

	flag.Parse()

	if *baseUrlPtr == "" || *tokenId == "" || *tokenSecret == "" {
		panic("baseurl, tokenid and tokensecret arguments are required")
	}

	api := NewBookStackApi(*baseUrlPtr, *tokenId, *tokenSecret)

	// Grab all content from BookStack
	fmt.Println("Fetching books...")
	bookIdMap := getBookMap(api)
	fmt.Printf("Fetched %d books\n", len(bookIdMap))
	fmt.Println("Fetching chapters...")
	chapterIdMap := getChapterMap(api)
	fmt.Printf("Fetched %d chapters\n", len(chapterIdMap))
	fmt.Println("Fetching pages...")
	pageIdMap := getPageMap(api)
	fmt.Printf("Fetched %d pages\n", len(pageIdMap))

	// Track progress when going through our pages
	pageCount := len(pageIdMap)
	currentCount := 1

	// Cycle through each of our fetches pages
	for _, p := range pageIdMap {
		fmt.Printf("Exporting page %d/%d [%s]\n", currentCount, pageCount, p.Name)
		// Get the full page content
		fullPage := api.GetPage(p.Id)

		// Work out a book+chapter relative path
		book := bookIdMap[fullPage.BookId]
		path := book.Slug
		if chapter, ok := chapterIdMap[fullPage.ChapterId]; ok {
			path += "/" + chapter.Slug
		}

		// Get the html, or markdown, content from our page along with the file name
		// based upon the page slug
		content := fullPage.Html
		fName := fullPage.Slug + ".html"
		if fullPage.Markdown != "" {
			content = fullPage.Markdown
			fName = fullPage.Slug + ".md"
		}

		// Create our directory path
		absExportPath, err := filepath.Abs(*exportDir)
		if err != nil {
			panic(err)
		}

		absPath := filepath.Join(absExportPath, path)
		err = os.MkdirAll(absPath, 0744)
		if err != nil {
			panic(err)
		}

		// Write the content to the filesystem
		fPath := filepath.Join(absPath, fName)
		go writeOutPageContent(fPath, content)

		// Wait to avoid hitting rate limits
		time.Sleep(time.Second / 6)
		currentCount++
	}

}

func writeOutPageContent(path string, content string) {
	err := os.WriteFile(path, []byte(content), 0644)
	if err != nil {
		panic(err)
	}
}
