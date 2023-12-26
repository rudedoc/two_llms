class Conversation < ApplicationRecord

  def broadcast_hello
    ConversationChannel.broadcast_to(self, { message: "Hello from #{title}" })
  end
end
