Given('that user {string} with password {string} has logged in') do |string, string2|
  user = User.create(surname: "Surnamne",
                     firstname: "Firstname#",
                     email: "test@aber.ac.uk",
                     phone: '01970 622422',
                     grad_year: 1985)
  UserDetail.create!(login: string,
                     password: string2,
                     user: user)

  visit('/session/new?')
  fill_in('login', :with => string)
  fill_in('password', :with => string2)
  click_button('login_button')
end

When('the user creates a new anonymous thread with the title {string} with the body {string}') do |title, body|
  visit('/posts/new')

  fill_in('post_title', :with => title)
  fill_in('post_text', :with => body)
  check('post_anonymous')

  click_button('Create Post')
end

Then('the current page should contain a new row containing the data:') do |table|
    visit('/posts')

    results = [['Title', 'Author', 'Unread posts', 'Total number posts']] +
        page.all('tr.data').map {|tr|
          [tr.find('.title').text,
           tr.find('.user').text,
           tr.find('.unread_posts').text,
           tr.find('.post_count').text]
        }

    table.diff!(results)
end