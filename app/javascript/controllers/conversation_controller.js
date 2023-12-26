import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static values = { id: Number }

  connect() {
    this.start();
  }

  start() {
    this.channel = consumer.subscriptions.create({ channel: "ConversationChannel", id: this.idValue }, {
      received(data) {
        console.log(data)
      }
    })
  }
}
