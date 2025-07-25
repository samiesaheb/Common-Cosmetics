import { Controller } from "@hotwired/stimulus"

let timeout;

export default class extends Controller {
  static values = { conversationId: Number }

  typing(event) {
    clearTimeout(timeout)
    this.sendTypingStatus(true)

    timeout = setTimeout(() => {
      this.sendTypingStatus(false)
    }, 1500)
  }

  sendTypingStatus(isTyping) {
    fetch(`/conversations/${this.conversationIdValue}/update_typing`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
      },
      body: JSON.stringify({ typing: isTyping })
    })
  }
}
