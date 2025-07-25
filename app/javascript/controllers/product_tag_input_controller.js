import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "suggestions"]

  connect() {
    this.fetchSuggestions()
  }

  fetchSuggestions() {
    fetch("/product_tags.json")
      .then(res => res.json())
      .then(data => this.tags = data.map(tag => tag.name))
  }

  search() {
    const query = this.inputTarget.value.toLowerCase()
    const matches = this.tags.filter(tag => tag.toLowerCase().includes(query))

    this.suggestionsTarget.innerHTML = ""
    matches.slice(0, 5).forEach(match => {
      const option = document.createElement("div")
      option.textContent = match
      option.className = "cursor-pointer hover:bg-red-100 px-2 py-1"
      option.onclick = () => this.select(match)
      this.suggestionsTarget.appendChild(option)
    })
  }

  select(tag) {
    const current = this.inputTarget.value.split(",").map(s => s.trim())
    if (!current.includes(tag)) {
      current.push(tag)
      this.inputTarget.value = current.filter(Boolean).join(", ")
    }
    this.suggestionsTarget.innerHTML = ""
  }
}
