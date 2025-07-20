# app/helpers/application_helper.rb
module ApplicationHelper
  def parse_mentions_to_links(text)
    text.gsub(/@(\w+)/) do |mention|
      username = mention.delete('@')
      user = User.find_by(username: username)
      user ? link_to("@#{username}", user_path(user), class: "mention", data: { turbo: false }) : mention
    end.html_safe
  end
end
