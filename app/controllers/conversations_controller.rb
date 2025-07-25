# app/controllers/conversations_controller.rb
class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = Conversation
      .where("sender_id = :id OR receiver_id = :id", id: current_user.id)
      .includes(:sender, :receiver)
  end

  def show
    @conversation = Conversation.find(params[:id])

    unless [@conversation.sender_id, @conversation.receiver_id].include?(current_user.id)
      redirect_to conversations_path, alert: "You are not authorized to view this conversation."
      return
    end

    @messages = @conversation.messages.includes(:user).order(created_at: :asc)
    @message = @conversation.messages.build
    @conversation.messages.where.not(user: current_user).update_all(read: true)

  end

  def create
    receiver = User.find(params[:receiver_id])
    sender = current_user

    conversation = Conversation.between(sender.id, receiver.id).first

    unless conversation
      conversation = Conversation.create!(sender:, receiver:)
    end

    redirect_to conversation_path(conversation)
  end

  def update_typing
    @conversation = Conversation.find(params[:id])
    authorize! :update, @conversation if defined?(CanCan)

    is_typing = params[:typing] == "true"
    @conversation.update(
      typing: is_typing,
      last_typing_user: is_typing ? current_user : nil
    )

    render turbo_stream: turbo_stream.replace(
      "typing_status",
      partial: "conversations/typing",
      locals: { conversation: @conversation }
    )
  end



end
