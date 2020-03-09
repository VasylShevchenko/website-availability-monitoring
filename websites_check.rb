# frozen_string_literal: true

require 'csv'
require 'byebug'
require 'uri'
require 'open-uri'
require 'net/http'
require 'colorize'


class WebsitesCheck

  attr_accessor :url

  def initialize(file_mame)
    @file_mame = file_mame

    @count_urls = 0
    @success = 0
    @redirection = 0
    @client_errors = 0
    @server_errors = 0
    @wrong_url = 0
  end

  def check_status
    CSV.foreach(@file_mame, headers: true) do |row|
      next if row[0].nil?

      url = add_url_protocol(row[0])
      check_url(url)
      @count_urls += 1
    end
  end

  def show_statistics
    puts '<========== STATISTICS ==========>'
    puts "Success (200-299): #{@success}".colorize(:blue)
    puts "Redirection (300-399): #{@redirection}".colorize(:blue)
    puts "Client errors (400-499): #{@client_errors}".colorize(:blue)
    puts "Server errors (500-599): #{@server_errors}".colorize(:gray)
    puts "Websites checked: #{@count_urls}".colorize(:green)
    puts "Wrong url: #{@wrong_url}".colorize(:red)
  end

  private

  def add_url_protocol(url)
    url[/\Ahttp:\/\//] || url[/\Ahttps:\/\//] ? url : "http://#{url}"
  end

  def check_url(url_string)
    url = URI.parse(url_string)
    req = Net::HTTP.new(url.host, url.port)
    req.use_ssl = (url.scheme == 'https')
    path = url.path.empty? ? '/' : url.path
    res = req.request_head(path)

    if res.is_a? Net::HTTPRedirection
      check_url(res['location'])
    else
      show_message(url: url_string, code: res.code)
    end
  rescue
    show_message(url: url_string, msg: 'Server IP address could not be found.')
  end

  def show_message(url:, code: 0, msg: '')
    msg = "Status code: #{code} #{url} #{msg}"

    case code.to_i
    when 200..299
      @success += 1
      puts msg.colorize(:blue)
    when 300..399
      @redirection += 1
      puts msg.colorize(:green)
    when 400..499
      @client_errors += 1
      puts msg.colorize(:red)
    when 500..599
      @server_errors += 1
      puts msg.colorize(:red)
    else
      @wrong_url += 1
      puts msg.colorize(:red)
    end
  end

end

websites = WebsitesCheck.new('websites_to_check.csv')
websites.check_status
websites.show_statistics

