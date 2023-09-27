ENV["RACK_ENV"] = "test"

require "minitest/autorun"
require "rack/test"
require "fileutils"

require_relative "../cms"

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
  
  def setup
    FileUtils.mkdir_p(data_path)
  end
  
  def create_document(name, content="")
    File.open(File.join(data_path, name), "w") do |file|
      file.write(content)
    end
  end
  
  def session
    last_request.env["rack.session"]
  end
  
  def admin_session
    {"rack_session" => {username: "admin" } }
  end
  
  def test_index
    create_document("changes.txt")
    create_document("about.md")
    
    get "/"
    assert_equal(200, last_response.status)
    assert_equal("text/html;charset=utf-8", last_response["content-type"])
    assert_includes(last_response.body, 'changes.txt')
    assert_includes(last_response.body, 'about.md')
  end
  
  def test_file_view
    create_document("history.txt")
    get "/history.txt"
    assert_equal(200, last_response.status)
    assert_equal("text/plain", last_response["content-type"])
  end
  
  def test_invalid_filename
    get "/notafile.ext"
    assert_equal(302, last_response.status)

    assert_equal("notafile.ext does not exist.", session[:message])

    assert_equal(200, last_response.status)

    get "/"
    refute_includes(last_response.body, "notafile.ext does not exist.")
  end
  
  def test_viewing_markdown_document
    create_document("about.md", "Ruby 0.95 released")
    
    get "/about.md"
    assert_equal(200, last_response.status)
    assert_equal("text/html;charset=utf-8", last_response["Content-Type"])
    assert_includes(last_response.body, "Ruby 0.95 released")
  end
  
  def test_file_editing
    create_document("history.txt")
    
    get "/history.txt/edit"
    assert_equal(200, last_response.status)
    assert_equal({}, last_request.params)
    assert_includes(last_response.body, "<textarea>")
  end
  
  def test_file_edit_submission
    create_document("history.txt")
    
    post "/history.txt", content: "new content", admin_session
    
    assert_equal(302, last_response.status)
    
    get last_response["Location"]
    
    assert_includes last_response.body, "history.txt has been updated"
  end
  
  def test_delete_file
    create_document("history.txt")
    
    post "/history.txt/delete"
    assert_equal(302, last_response.status)
    
    get last_response["Location"]
    
    assert_includes(last_response.body, "has been deleted.")
    
    get "/"
    
    refute_includes(last_response.body, "has been deleted.")
  end
  
  def test_signin
    post "/users/signin", username: "admin", password: "secret"
    assert_equal(302, last_response.status)
    
    get last_response["Location"]
    
    assert_equal(200, last_response.status)
    assert_includes(last_response.body, "Welcome")
    assert_includes last_response.body, "Signed in as admin"
  end
  
  def test_bad_signin
    post "/users/signin", username: 'bad', password: "apple"
    
    assert_equal(422, last_response.status)
    assert_includes(last_response.body, "Invalid credentials")
  end
  
  def test_signout
    post "/users/signin", username: "admin", password: "secret"
    get last_response["Location"]
    assert_includes last_response.body, "Welcome"

    post "/users/signout"
    get last_response["Location"]

    assert_includes last_response.body, "You have been signed out"
    assert_includes last_response.body, "Sign In"
  end
  
  def test_signin_verification
    get "/", 
  end
  
  def teardown
    FileUtils.rm_rf(data_path)
  end
end