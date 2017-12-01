# A simple REST client for the CSA application. Note that this
# example will only support the user accounts feature. Clearly
# the passwords should not be sent in plain text, but rather HTTPS used.
# Also the password info should go in a config file and accessed as ebvironment
# variables.
# @author Charles Palmer
require 'rest-client'
require 'json'
require 'base64'
require 'io/console'
class CSAPostRestClient

  #@@DOMAIN = 'https://csa-heroku-chp38.herokuapp.com/'
  @@DOMAIN = 'http://localhost:3000'

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
        when '4'
          puts 'Updating post:'
          puts '-------------------------------------------------------------'
          update_post
        when '5'
          puts 'Deleting post:'
          puts '-------------------------------------------------------------'
          delete_post
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

      puts '-------------------------------'

      print 'Password: '
      @pass = STDIN.noecho(&:gets).chomp

      @logged_in = true
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
    puts '|      4. Update post by ID   |'
    puts '|      5. Delete post by ID   |'
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

  def update_post
    begin
      print "Enter the post ID: "
      id = STDIN.gets.chomp
      response = RestClient.get "#{@@DOMAIN}/api/posts/#{id}.json", authorization_hash

      # Extract each element and ask the user if they'd like to change it
      js = JSON response.body

      result = {}
      puts '-------------------------------------------------------------'
      puts 'Hit return to keep value the same or else type new value:   |'
      puts '-------------------------------------------------------------'
      js.each do |k, v|
        unless k == 'id' || k == 'updated_at' || k == 'created_at' || k == 'user_id' || k == 'post_count' || k == 'anonymous'
          print "#{k} - Current: [#{v}]: "
          res = STDIN.gets.chomp
          result[k] = res.length > 0 ? res : v
          puts '-------------------------------------------------------------'
        end
      end

      response = RestClient.put "#{@@DOMAIN}/api/posts/#{id}.json",
                                {post: result}, authorization_hash

      if (response.code == 201)
        puts "Update successfully"
      end
    rescue => e
      puts STDERR, "Error accessing REST service. Error: #{e}\n"
    end

  end

  def delete_post
    begin
      print "Enter the post ID: "
      id = STDIN.gets.chomp
      response = RestClient.delete "#{@@DOMAIN}/api/posts/#{id}.json", authorization_hash

      if (response.code == 204)
        puts "Deleted successfully"
      end
    rescue => e
      puts STDERR, "Error accessing REST service. Error: #{e}\n"
    end
  end

  def authorization_hash
    {Authorization: "Basic #{Base64.strict_encode64("#{@user}:#{@pass}")}"}
  end

end

client = CSAPostRestClient.new
client.run_menu
