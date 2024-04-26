require 'csv'
require 'httparty'
require 'dotenv/load'
require 'logger'
require 'bundler/setup'

Bundler.require(:default)

logger = Logger.new('bookstack.log')

class BookStackAPI
  include HTTParty
  base_uri ENV['BS_URL']
  headers 'Authorization' => "Token #{ENV['BS_TOKEN_ID']}:#{ENV['BS_TOKEN_SECRET']}"
  format :json

  def self.get(path, options = {})
    url = "#{base_uri}#{path}"
    ::Logger.new(STDOUT).info("Making GET request to: #{url}")
    ::Logger.new(STDOUT).info("Query parameters: #{options[:query]}")
    response = super(path, options)
    ::Logger.new(STDOUT).info("Response status: #{response.code}")
    response
  end
end

def get_all_items(path)
  results = []
  page_size = 500
  offset = 0
  total = 1

  while offset < total
    sleep(0.5) if offset > 0

    response = BookStackAPI.get(path, query: { count: page_size, offset: offset })
    total = response['total']
    offset += page_size

    results.concat(response['data'])
  end

  ::Logger.new(STDOUT).info("Retrieved #{results.count} items from #{path}")
  results
end

def generate_csv(pages, books, shelves)
  book_map = books.map { |book| [book['id'], book] }.to_h
  shelf_map = shelves.map { |shelf| [shelf['id'], shelf] }.to_h

  CSV.open('bookstack_data.csv', 'w') do |csv|
    csv << ['Type', 'ID', 'Name', 'URL', 'Book ID', 'Book Name', 'Book URL', 'Shelf Name', 'Date Modified', 'Date Created']

    pages.each do |page|
      book = book_map[page['book_id']]
      shelf_name = shelf_map[book['shelf_id']]['name'] if book && shelf_map[book['shelf_id']]
      csv << [
        'Page',
        page['id'],
        page['name'],
        "=HYPERLINK(\"#{ENV['BS_URL']}/books/#{page['book_id']}/page/#{page['id']}\")",
        page['book_id'],
        book ? book['name'] : '',
        "=HYPERLINK(\"#{ENV['BS_URL']}/books/#{page['book_id']}\")",
        shelf_name || '',
        page['updated_at'],
        page['created_at']
      ]
    end

    books.each do |book|
      shelf_name = shelf_map[book['shelf_id']]['name'] if shelf_map[book['shelf_id']]
      csv << [
        'Book',
        book['id'],
        book['name'],
        "=HYPERLINK(\"#{ENV['BS_URL']}/books/#{book['id']}\")",
        '',
        '',
        '',
        shelf_name || '',
        book['updated_at'],
        page['created_at']
      ]
    end
  end
end

begin
  logger.info('Started generating BookStack data CSV')
  logger.info("BookStack URL: #{ENV['BS_URL']}")

  pages = get_all_items('/api/pages')
  books = get_all_items('/api/books')
  shelves = get_all_items('/api/shelves')

  generate_csv(pages, books, shelves)

  logger.info('CSV file generated: bookstack_data.csv')
rescue StandardError => e
  logger.error("Error: #{e.message}")
  logger.error(e.backtrace.join("\n"))
end
