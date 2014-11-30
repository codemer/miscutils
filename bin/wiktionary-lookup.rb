#!/usr/bin/env ruby

require 'net/http'
require 'json'

BASE_URL='http://en.wiktionary.org/w/api.php?action=query&format=json&continue=&prop=extracts&titles='

def lookup(words)
  titles = words.join(',')
  uri = URI(BASE_URL + titles)
  result = Net::HTTP.get(uri)
  h = JSON.parse(result)
  if h["-1"]
    puts "Failed to lookup '#{titles}'"
    exit 1
  end
  puts "Wiktionary results:\n\n"
  h['query']['pages'].each do |k,v|
    ex = v['extract'].sub(/<p>\s*Wikipedia\s*<\/p>/, '').sub(/<p>\s*Wikispecies\s*<\/p>/, '')
    File.write('/tmp/word.html', ex)
    system('w3m -dump /tmp/word.html')
    File.unlink('/tmp/word.html')
  end
end

if ARGV.empty?
  puts "You must specify a word. Make sure w3m is installed"
  exit 0
end
lookup(ARGV)
