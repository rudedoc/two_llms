class ConversationJob
  include Sidekiq::Job

  def perform(conversation_id)
    @model = 'llama2:latest'
    @sampe_tones = false
    @count = 0
    conversation = Conversation.find(conversation_id)
    loop do
      break unless conversation.running?

      text = conversation.responses&.last&.text || conversation.subject
      llm_response = llm_command(text)
      llm_response_data = JSON.parse(llm_response)
      response_record = conversation.responses.create(model: @model, text: llm_response_data['response'])
      conversation.broadcast_response(response_record)
    end
  end

  def llm_command(text)
    json = { model: @model, prompt: prompt_text(text), stream: false }

    `curl #{service_url}  -d '#{json.to_json}'`
  end

  def prompt_text(text)
    @count += 1
    if @count.even?
      "Ask a short question not directly related to the following statement: #{text}"
    else
      "Give a short response not directly related to the following question: #{text}"
    end.gsub(/["'\n\r]/, '')
  end

  def service_url
    'http://localhost:11434/api/generate'
  end
end
