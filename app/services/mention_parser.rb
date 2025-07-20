# app/services/mention_parser.rb
class MentionParser
  def initialize(mentionable)
    @mentionable = mentionable
    @body = mentionable.body
  end

  def call
    usernames = @body.scan(/@(\w+)/).flatten.uniq
    users = User.where(username: usernames)

    users.each do |user|
      Mention.find_or_create_by!(mentionable: @mentionable, user: user)
      Notification.create!(
        recipient: user,
        actor: @mentionable.user,
        action: "mentioned you",
        notifiable: @mentionable
      )
    end
  end
end
