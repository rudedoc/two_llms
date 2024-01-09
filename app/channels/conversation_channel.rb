class ConversationChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    puts "Something something #{params}"
    @conversation = Conversation.find(params[:id])
    @conversation.update(running: true)
    stream_for @conversation
    ConversationJob.perform_async(@conversation.id)
  end

  def unsubscribed
    @conversation.update(running: false)
  end
end
