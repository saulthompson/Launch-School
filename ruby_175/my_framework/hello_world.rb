#hello_world.rb
require 'erb'
require_relative 'advice'

class HelloWorld
  def call(env)
    case env['REQUEST_PATH']
    when '/'
      template = File.read("views/index.erb")
      content = ERB.new(template)
      ['200', {'Content-Type' => 'text/plain'}, [content.result]]
    when '/advice'
      piece_of_advice = Advice.new.generate
      ['200', {'Content-Type' => 'text/plain'}, [piece_of_advice]]
    else
      [
        '404',
        {"Content-Type" => 'text/plain', "Content-Length" => '13'},
        ["404 Not Found"]
      ]
    end
  end
end