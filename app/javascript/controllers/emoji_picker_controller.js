import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["picker", "input"]

  connect() {
    console.log("emoji-picker#connect") // 👈 Add this for visibility
    this.pickerVisible = false
  }

  togglePicker() {
    console.log("Toggle clicked") // 👈 Add this too
    this.pickerVisible = !this.pickerVisible
    this.pickerTarget.classList.toggle("hidden", !this.pickerVisible)
  }

  insertEmoji(event) {
    const emoji = event.target.textContent
    const input = this.inputTarget

    const start = input.selectionStart
    const end = input.selectionEnd
    const text = input.value

    input.value = text.slice(0, start) + emoji + text.slice(end)
    input.focus()
    input.selectionStart = input.selectionEnd = start + emoji.length

    this.togglePicker()
  }
}
