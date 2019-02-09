# frozen_string_literal: true

require 'bundler/inline'
gemfile do
  gem 'nokogiri'
  gem 'rubyzip'
end

require 'net/http'
require 'zip'

SHOWS = %w(
  StarTrek
  NextGen
  DS9
  Voyager
  Enterprise
).freeze

class ScriptPuller
  def initialize(show, episode_path = 'episodes.htm')
    @show = show
    @episode_path = episode_path
  end

  def pull_scripts
    episode_links.compact.each_with_index do |link, index|
      # rate limit
      sleep 0.5
      episode_number = link.gsub(/.htm$/, '')
      print "#{index.to_s.rjust(5, " ")}/#{episode_links.length}\r"
      script_url = URI("http://www.chakoteya.net/#{@show}/#{link}")
      page = Nokogiri::HTML(
        Net::HTTP.get(URI(script_url))
      )
      File.open("scripts/#{@show}-#{episode_number}.txt", "w") do |file|
        file.write(
          page.search("body > div > center > table > tbody > tr > td").inner_text
        )
      end
    end
    puts "Complete!"
  end

  def episode_links
    @episode_links ||= episodes_page.search(selectors).map do |link|
      link.attributes["href"]&.value
    end
  end

  def selectors
    if @show == 'Enterprise'
      'td > span > font > a, td > span > a'
    elsif @show == 'Voyager'
      'td > p > font > a'
    else
      'td > font > a'
    end
  end

  def episodes_page
    @episodes_page ||= Nokogiri::HTML(
      Net::HTTP.get(
        URI("http://www.chakoteya.net/#{@show}/#{@episode_path}")
      )
    )
  end
end

