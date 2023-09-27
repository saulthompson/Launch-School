require "sinatra"
require "sinatra/reloader"
require 'tilt/erubis'

before do
  @toc = File.readlines('data/toc.txt')
end

get "/" do
  @title = 'Sherlock'
  @files = Dir.glob("public/*").map { |file| File.basename(file) }.sort
  @files.reverse! if params[:sort] == 'desc'

  erb :home
end

helpers do
  def paragraphize(content)
    content.split("\n\n").map!.with_index do |line, idx|
      "<p id=#{idx + 1}>#{line}</p>"
    end.join
  end
  
  def embolden(content, term)
    content.gsub! term, "<strong>#{term}</strong>"
  end
end


not_found do
  redirect("/")
end

def each_chapter
  @toc.each_with_index do |name, idx|
    number = idx + 1
    contents = File.read("data/chp#{number}.txt")
    
    yield name, number, contents
  end
end

def chapters_matching(query)
  results = []
  
  return results if !query || query.empty?
  
  each_chapter do |name, number, contents|
    matches = {}
    contents.split("\n\n").each_with_index do |paragraph, idx|
      matches[idx] = paragraph if paragraph.include?(query)
    end
    results << {name: name, number: number, paragraphs: matches} if matches.any?
  end
  
  results
end

get "/search" do
  @results = chapters_matching(params[:query])
  
  erb :search
end

get "/chapters/:number" do

  number = params[:number]
  
  @title = "Chapter #{number}"
  
  @chapter = File.read("data/chp#{number}.txt")
  
  erb :chapter
end

get "/show/:name" do
  params[:name]
end