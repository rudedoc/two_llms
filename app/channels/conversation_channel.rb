class ConversationChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    puts "Something something #{params}"
    conversation = Conversation.find(params[:id])
    stream_for conversation
    conversation.broadcast_hello
  end
end
