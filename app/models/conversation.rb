class Conversation < ApplicationRecord

  has_many :responses


  def broadcast_hello
    ConversationChannel.broadcast_to(self, { message: "Hello from #{title}" })
  end

  def broadcast_response(response_record)
    ConversationChannel.broadcast_to(self, response_record.as_json)
  end
end
