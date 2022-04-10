package main

import (
	"encoding/json"
	"time"
)

type ListResponse struct {
	Data  json.RawMessage `json:"data"`
	Total int             `json:"total"`
}

type Book struct {
	Id          int       `json:"id"`
	Name        string    `json:"name"`
	Slug        string    `json:"slug"`
	Description string    `json:"description"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
	CreatedBy   int       `json:"created_by"`
	UpdatedBy   int       `json:"updated_by"`
	OwnedBy     int       `json:"owned_by"`
	ImageId     int       `json:"image_id"`
}

type Chapter struct {
	Id          int       `json:"id"`
	BookId      int       `json:"book_id"`
	Name        string    `json:"name"`
	Slug        string    `json:"slug"`
	Description string    `json:"description"`
	Priority    int       `json:"priority"`
	CreatedAt   string    `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
	CreatedBy   int       `json:"created_by"`
	UpdatedBy   int       `json:"updated_by"`
	OwnedBy     int       `json:"owned_by"`
}

type Page struct {
	Id            int       `json:"id"`
	BookId        int       `json:"book_id"`
	ChapterId     int       `json:"chapter_id"`
	Name          string    `json:"name"`
	Slug          string    `json:"slug"`
	Html          string    `json:"html"`
	Priority      int       `json:"priority"`
	CreatedAt     time.Time `json:"created_at"`
	UpdatedAt     time.Time `json:"updated_at"`
	Draft         bool      `json:"draft"`
	Markdown      string    `json:"markdown"`
	RevisionCount int       `json:"revision_count"`
	Template      bool      `json:"template"`
}
