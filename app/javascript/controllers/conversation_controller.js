import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { id: Number }

  start() {
    console.log(`Start conversation! for id ${this.idValue}`)
  }
}
