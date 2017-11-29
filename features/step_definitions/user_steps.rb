Given('that user {string} with password {string} has logged in') do |string, string2|
  visit('/session/new?')
  fill_in('login', :with => string)
  fill_in('password', :with => string2)
  click_button('login_button')
end

When('the user creates a new anonymous thread with the title {string} with the body {string}') do |title, body|
  visit('/users/new?page=1')

  fill_in('post_title', :with => string)
  fill_in('post[title]', :with => title)
  fill_in('post[anonymous]', :with => true)

  click_button('Create Post')
end

Then('the current page should contain a new row containing the data:') do |table|
    # table is a Cucumber::MultilineArgument::DataTable
    pending # Write code here that turns the phrase above into concrete actions
end