package main

import (
	"crypto/tls"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
	"strconv"
	"strings"
)

type BookStackApi struct {
	BaseURL     string
	TokenID     string
	TokenSecret string
}

func NewBookStackApi(baseUrl string, tokenId string, tokenSecret string) *BookStackApi {
	api := &BookStackApi{
		BaseURL:     baseUrl,
		TokenID:     tokenId,
		TokenSecret: tokenSecret,
	}

	return api
}

func (bs BookStackApi) authHeader() string {
	return fmt.Sprintf("Token %s:%s", bs.TokenID, bs.TokenSecret)
}

func (bs BookStackApi) getRequest(method string, urlPath string, data map[string]string) *http.Request {
	method = strings.ToUpper(method)
	completeUrlStr := fmt.Sprintf("%s/api/%s", strings.TrimRight(bs.BaseURL, "/"), strings.TrimLeft(urlPath, "/"))

	queryValues := url.Values{}
	for k, v := range data {
		queryValues.Add(k, v)
	}
	encodedData := queryValues.Encode()

	r, err := http.NewRequest(method, completeUrlStr, strings.NewReader(encodedData))
	if err != nil {
		panic(err)
	}

	r.Header.Add("Authorization", bs.authHeader())

	if method != "GET" && method != "HEAD" {
		r.Header.Add("Content-Type", "application/x-www-form-urlencoded")
		r.Header.Add("Content-Length", strconv.Itoa(len(encodedData)))
	} else {
		r.URL.RawQuery = encodedData
	}

	return r
}

func (bs BookStackApi) doRequest(method string, urlPath string, data map[string]string) []byte {
	client := &http.Client{
		Transport: &http.Transport{
			TLSClientConfig: &tls.Config{InsecureSkipVerify: true},
		},
	}
	r := bs.getRequest(method, urlPath, data)
	res, err := client.Do(r)
	if err != nil {
		panic(err)
	}

	defer res.Body.Close()

	body, err := ioutil.ReadAll(res.Body)
	if err != nil {
		panic(err)
	}

	return body
}

func (bs BookStackApi) getFromListResponse(responseData []byte, models any) ListResponse {
	var response ListResponse

	if err := json.Unmarshal(responseData, &response); err != nil {
		panic(err)
	}

	if err := json.Unmarshal(response.Data, models); err != nil {
		panic(err)
	}

	return response
}

func (bs BookStackApi) GetBooks(count int, page int) ([]Book, int) {
	var books []Book

	data := bs.doRequest("GET", "/books", getPagingParams(count, page))
	response := bs.getFromListResponse(data, &books)

	return books, response.Total
}

func (bs BookStackApi) GetChapters(count int, page int) ([]Chapter, int) {
	var chapters []Chapter

	data := bs.doRequest("GET", "/chapters", getPagingParams(count, page))
	response := bs.getFromListResponse(data, &chapters)

	return chapters, response.Total
}

func (bs BookStackApi) GetPages(count int, page int) ([]Page, int) {
	var pages []Page

	data := bs.doRequest("GET", "/pages", getPagingParams(count, page))
	response := bs.getFromListResponse(data, &pages)

	return pages, response.Total
}

func (bs BookStackApi) GetPage(id int) Page {
	var page Page

	data := bs.doRequest("GET", fmt.Sprintf("/pages/%d", id), nil)
	if err := json.Unmarshal(data, &page); err != nil {
		panic(err)
	}

	return page
}

func getPagingParams(count int, page int) map[string]string {
	return map[string]string{
		"count":  strconv.Itoa(count),
		"offset": strconv.Itoa(count * (page - 1)),
	}
}
