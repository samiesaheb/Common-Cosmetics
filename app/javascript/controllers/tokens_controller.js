// app/javascript/controllers/tokens_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["hidden", "input", "menu", "container"]
  static values = { url: String }

  connect() {
    this.tokens = this.parse(this.hiddenTarget.value) // existing values
    this.render()
    this.syncHidden() 
  }

  // Parse "Brand: Name, Name2" -> ["Brand: Name","Name2"]
  parse(str) {
    return str ? str.split(",").map(s => s.trim()).filter(Boolean) : []
  }

  // Build hidden field from tokens
  syncHidden() {
    this.hiddenTarget.value = this.tokens.join(", ")
  }

  // Render chips
  render() {
    // Remove old chips
    this.containerTarget.querySelectorAll("[data-token-chip]").forEach(n => n.remove())

    this.tokens.forEach((t, idx) => {
      const chip = document.createElement("span")
      chip.dataset.tokenChip = "true"
      chip.className = "inline-flex items-center gap-1 px-2 py-1 rounded-full bg-rose-50 text-rose-700 text-xs border border-rose-200"
      chip.innerHTML = `<span>${t}</span>
        <button type="button" aria-label="Remove" class="rounded-full hover:bg-rose-100 px-1 text-rose-700">×</button>`
      chip.querySelector("button").addEventListener("click", () => {
        this.tokens.splice(idx, 1)
        this.syncHidden()
        this.render()
      })
      this.containerTarget.insertBefore(chip, this.inputTarget)
    })
    this.syncHidden() 
  }

  // Typing: fetch suggestions
  async type(e) {
    const q = this.inputTarget.value.trim()
    if (!q) return this.hideMenu()

    try {
      const res = await fetch(`${this.urlValue}?q=${encodeURIComponent(q)}`)
      const items = await res.json()
      this.showMenu(items)
    } catch (_) {
      this.hideMenu()
    }
  }

  showMenu(items) {
    this.menuTarget.innerHTML = items.map(i =>
      `<li class="px-3 py-2 text-sm hover:bg-gray-50 cursor-pointer" data-item="${i.label}">${i.label}</li>`
    ).join("")
    this.menuTarget.classList.remove("hidden")

    this.menuTarget.querySelectorAll("li").forEach(li => {
      li.addEventListener("click", () => {
        this.addToken(li.dataset.item)
      })
    })
  }

  hideMenu() {
    this.menuTarget.classList.add("hidden")
    this.menuTarget.innerHTML = ""
  }

  addToken(label) {
    if (!label) return
    if (!this.tokens.includes(label)) this.tokens.push(label)
    this.syncHidden()
    this.render()
    this.inputTarget.value = ""
    this.hideMenu()
  }

  // Keyboard handling (Enter to add, Escape to close)
  keys(e) {
    if (e.key === "Enter" && this.inputTarget.value.trim()) {
      e.preventDefault()
      this.addToken(this.inputTarget.value.trim())
    } else if (e.key === "Escape") {
      this.hideMenu()
      this.inputTarget.blur()
    } else if (e.key === "Backspace" && !this.inputTarget.value && this.tokens.length) {
      // quick backspace delete
      this.tokens.pop()
      this.syncHidden()
      this.render()
    }
  }
}
