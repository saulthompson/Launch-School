# cms.rb
require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require "redcarpet"
require "yaml"
require "bcrypt"

configure do
  enable :sessions
end

root = File.expand_path("..", __FILE__)

before do
  @files = Dir.glob(root + "/data/*").map do |path|
    File.basename(path)
  end
end

def render_markdown(text)
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  markdown.render(text)
end

def data_path
  if ENV["RACK_ENV"] == 'test'
    File.expand_path("../test/data", __FILE__)
  else
    File.expand_path("../data", __FILE__)
  end
end

def load_file_content(path)
  content = File.read(path)
  case File.extname(path)
  when ".txt"
    headers["Content-Type"] = "text/plain"
    content
  when ".md"
    erb render_markdown(content)
  end
end

def valid_credentials?(username, password)
  credentials = load_user_credentials
  
  if credentials.key?(username)
    bcrypt_password = credentials[username]
    bcrypt_password == password
  else
    false
  end
end

def verify_signed_in
  unless session[:username]
    session[:message] = "You must be signed in to do that."
    redirect "/"
  end
end

def load_user_credentials
  credentials_path = if ENV["RACK_ENV"] == "test"
    File.expand_path("../test/users.yml", __FILE__)
  else
    File.expand_path("../users.yml", __FILE__)
  end
  
  YAML.load_file(credentials_path)
end

get "/" do
  erb :index
end

get "/users/signin" do
  erb :signin
end

post "/users/signin" do
  if valid_credentials?(params[:username], params[:password])
    session[:username] = params[:username]
    session[:message] = "Welcome!"
    redirect "/"
  else
    session[:message] = "Invalid credentials"
    status 422
    erb :signin
  end
end

post "/users/signout" do
  session.delete(:username)
  session[:message] = "You have been signed out."
  redirect "/"
end


get "/:filename/edit" do
  verify_signed_in
  
  file_path = File.join(data_path, params[:filename])

  
  @file_name = params[:filename]
  @content = File.read(file_path)
  
  erb :edit
end



get "/new_document" do
  erb :new_doc
end

post "/create" do
  verify_signed_in

  file_name = params[:filename]
  
  if file_name.strip.size == 0 || !file_name.include?(".")
    session[:message] = "File name must be between 1 and 100 characters."
    status 422
    erb :new_doc
  else
    file_path = File.join(data_path, file_name)
    File.write(file_path, "")
    session[:message] = "#{file_name} has been created."
    redirect "/"
  end
end

post "/:filename/delete" do
  verify_signed_in

  filename = params[:filename]
  file_path = File.join(data_path, filename)
  
  File.delete(file_path)
  
  session[:message] = "#{filename} has been deleted."
  redirect "/"
end

get "/:filename" do
  verify_signed_in

  file_path = File.join(data_path, params[:filename])

  if File.exist?(file_path)
    load_file_content(file_path)
  else
    session[:message] = "#{params[:filename]} does not exist."
    redirect "/"
  end
end

post "/:filename" do
  verify_signed_in

  file_path = File.join(data_path, params[:filename])

  File.write(file_path, params[:content])
  
  session[:message] = "#{params[:filename]} has been updated."
  redirect("/")
end