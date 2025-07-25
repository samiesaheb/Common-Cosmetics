class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation
  before_action :set_message, only: [:destroy]

  def create
    @message = @conversation.messages.build(message_params.merge(user: current_user))

    respond_to do |format|
      if @message.save
        format.turbo_stream
        format.html { redirect_to conversation_path(@conversation) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("message_form", partial: "messages/form", locals: { message: @message, conversation: @conversation }) }
        format.html { render "conversations/show" }
      end
    end
  end

  def destroy
    if @message.nil?
      redirect_back fallback_location: root_path, alert: "Message not found."
      return
    end

    unless @message.user == current_user
      redirect_back fallback_location: root_path, alert: "You are not authorized to delete this message."
      return
    end

    @message.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: root_path, notice: "Message deleted." }
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])

    unless [@conversation.sender_id, @conversation.receiver_id].include?(current_user.id)
      redirect_to conversations_path, alert: "You are not authorized to access this conversation."
    end
  end

  def set_message
    @message = @conversation.messages.find_by(id: params[:id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
