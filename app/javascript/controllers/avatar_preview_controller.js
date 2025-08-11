import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  update(event) {
    const file = event.target.files?.[0]
    if (!file) return
    const reader = new FileReader()
    reader.onload = () => {
      const img = document.getElementById("avatar-preview")
      if (img) img.src = reader.result
    }
    reader.readAsDataURL(file)
  }
}
