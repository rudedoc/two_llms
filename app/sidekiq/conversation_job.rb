class ConversationJob
  include Sidekiq::Job

  def perform(conversation_id)
    @model = 'llama2:latest'
    @sampe_tones = false
    Sidekiq::Queue.new.clear
    Sidekiq::RetrySet.new.clear
    conversation = Conversation.find(conversation_id)

    # initialize the conversation
    context = []
    subject = conversation.subject
    @count = 0
    loop do
      break unless conversation.running

      response = command(@model, subject, context)
      response_data = JSON.parse(response)
      subject = response_data['response']
      response_record = conversation.responses.create(model: @model, text: subject)
      conversation.broadcast_response(response_record)
    end
  end

  def command(model, text, context)
    json = { model:, prompt: prompt(text), stream: false, context: }

    `curl #{service_url}  -d '#{json.to_json}'`
  end

  def prompt(text)
    @count += 1
    if @count.even?
      "Ask me a question about the follow statement: #{text}"
    else
      "Give me a response (maximum 180 characters) to the following question: #{text}"
    end.gsub(/["'\n\r]/, '')
  end

  def service_url
    'http://localhost:11434/api/generate'
  end
end
