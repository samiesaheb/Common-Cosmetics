# app/services/mention_parser.rb
class MentionParser
  def initialize(mentionable)
    @mentionable = mentionable
    @body = mentionable.try(:caption) || mentionable.try(:body)
    @actor = mentionable.try(:user)
  end

  def call
    return unless @body.present? && @actor.present?

    usernames = @body.scan(/@(\w+)/).flatten.uniq
    users = User.where(username: usernames)

    users.each do |user|
      next if user == @actor # 🛡️ Skip self-mentions

      Mention.find_or_create_by!(mentionable: @mentionable, user: user)

      Notification.create!(
        recipient: user,
        actor: @actor,
        action: "mentioned",
        notifiable: @mentionable
      )
    end
  end
end
