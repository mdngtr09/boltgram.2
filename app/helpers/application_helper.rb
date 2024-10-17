module ApplicationHelper
def avatar_url user
  return user.image if user.image
  gravatar_id = Digest::MD5::hexdigest(user.email).downcase
  "http://gravatar.com/avatar/#{gravatar_id}.png"
end
end
