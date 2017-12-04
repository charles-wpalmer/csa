# A simple REST client for the CSA application. Note that this
# example will only support the user accounts feature. Clearly
# the passwords should not be sent in plain text, but rather HTTPS used.
# Also the password info should go in a config file and accessed as ebvironment
# variables.
# @author Chris Loftus
# @author Charles Palmer
require 'rest-client'
require 'json'
require 'base64'
require 'io/console'
class CSAPostRestClient

  @@DOMAIN = 'https://csa-heroku-chp38.herokuapp.com/'
  #@@DOMAIN = 'http://localhost:3000'

  @user
  @pass
  @logged_in = false

  def run_menu
    loop do
      login
      display_menu
      option = STDIN.gets.chomp.upcase
      case option
        when '1'
          puts 'Displaying posts:'
          puts '-------------------------------------------------------------'
          display_posts
        when '2'
          puts 'Displaying post:'
          puts '-------------------------------------------------------------'
          display_post
        when '3'
          puts 'Creating post:'
          puts '-------------------------------------------------------------'
          create_post
        when 'Q'
          break
        else
          puts "Option #{option} is unknown."
      end
    end
  end

  private

  def login
    if !@logged_in
      puts '-------------------------------'
      puts '|             Login:          |'
      puts '-------------------------------'

      print  'Username: '
      @user = STDIN.gets.chomp

      print 'Password: '
      @pass = STDIN.noecho(&:gets).chomp

      authenticate
      puts ''
    end
  end

  def display_menu
    puts '-------------------------------'
    puts '|        Enter option:        |'
    puts '-------------------------------'
    puts '|       1. Display posts      |'
    puts '|    2. Display post by ID    |'
    puts '|       3. Create new post    |'
    puts '|           Q. Quit           |'
    puts '-------------------------------'
  end

  def display_posts
    begin
      response = RestClient.get "#{@@DOMAIN}/api/posts.json?all", authorization_hash

      js = JSON response.body
      js.each do |item_hash|
        puts '-------------------------------------------------------------'
        item_hash.each do |k, v|
          puts "#{k}: #{v}"
        end
      end
    rescue => e
      puts STDERR, "Error accessing REST service. Error: #{e}"
    end
  end

  def display_post
    begin
      print "Enter the post ID: "
      id = STDIN.gets.chomp
      response = RestClient.get "#{@@DOMAIN}/api/posts/#{id}.json", authorization_hash

      js = JSON response.body
      js.each do |k, v|
        puts "#{k}: #{v}"
      end
    rescue => e
      puts STDERR, "Error accessing REST service. Error: #{e}"
    end
  end

  def create_post
    begin
      print "Post Title: "
      title = STDIN.gets.chomp
      print "Post Body: "
      body = STDIN.gets.chomp
      print "Anonymous (yes/no): "
      anonymous = STDIN.gets.chomp

      (anonymous == 'yes') ? anonymous = true : anonymous = false

      response = RestClient.post "#{@@DOMAIN}/api/posts.json",
                                 {
                                     post: {
                                         title: title,
                                         text: body,
                                         anonymous: anonymous
                                     }
                                 }, authorization_hash

      if (response.code == 201)
        puts "Created successfully"
      end
      puts "URL for new resource: #{response.headers[:location]}"
    rescue => e
      puts STDERR, "Error accessing REST service. Error: #{e}"
    end
  end

  def authorization_hash
    {Authorization: "Basic #{Base64.strict_encode64("#{@user}:#{@pass}")}"}
  end

  # Authenticate the user login
  def authenticate
    response = RestClient.post "#{@@DOMAIN}/api/sessions.json",
                                {
                                       login: @user,
                                       password: @pass,
                                }

    if response.body == "true"
      @logged_in = true
    else
      puts ''
      puts 'Login failed'
      puts ''
      run_menu
    end
  end
end

client = CSAPostRestClient.new
client.run_menu
