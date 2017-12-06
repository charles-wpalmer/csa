module HomeHelper

  # Function to generate the images for home page
  # Recent forum posts.
  # If user has image, and post isn't anonymous, display
  # photo, else display default image.
  def gen_image(user, size = :medium, anon = false)
    if user.image && !anon

      user_image = user.image.photo.url(size)
      image_text = "Image of #{user.firstname} #{user.surname}"

      image_tag(user_image, class: 'image-tag',
                        alt: image_text,
                        title: image_text, border: '0')
    else
      image_tag("blank-cover_#{size}.png",
                class: 'image-tag', alt: 'No photo available',
                title: 'No photo available', border: '0')
    end
  end
end