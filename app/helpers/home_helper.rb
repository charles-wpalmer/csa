module HomeHelper

  def gen_image(user, size = :medium)
    if user.image

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