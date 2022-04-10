package main

import (
	"time"
)

func getBookMap(api *BookStackApi) map[int]Book {
	var books []Book
	var byId = make(map[int]Book)

	page := 1
	hasMoreBooks := true
	for hasMoreBooks {
		time.Sleep(time.Second / 2)
		newBooks, _ := api.GetBooks(200, page)
		hasMoreBooks = len(newBooks) == 200
		page++
		books = append(books, newBooks...)
	}

	for _, book := range books {
		byId[book.Id] = book
	}

	return byId
}

func getChapterMap(api *BookStackApi) map[int]Chapter {
	var chapters []Chapter
	var byId = make(map[int]Chapter)

	page := 1
	hasMoreChapters := true
	for hasMoreChapters {
		time.Sleep(time.Second / 2)
		newChapters, _ := api.GetChapters(200, page)
		hasMoreChapters = len(newChapters) == 200
		page++
		chapters = append(chapters, newChapters...)
	}

	for _, chapter := range chapters {
		byId[chapter.Id] = chapter
	}

	return byId
}

func getPageMap(api *BookStackApi) map[int]Page {
	var pages []Page
	var byId = make(map[int]Page)

	page := 1
	hasMorePages := true
	for hasMorePages {
		time.Sleep(time.Second / 2)
		newPages, _ := api.GetPages(200, page)
		hasMorePages = len(newPages) == 200
		page++
		pages = append(pages, newPages...)
	}

	for _, page := range pages {
		byId[page.Id] = page
	}

	return byId
}
