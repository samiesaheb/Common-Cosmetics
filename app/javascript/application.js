// app/javascript/application.js
import { Application } from "@hotwired/stimulus"
import "@hotwired/turbo-rails"

const application = Application.start()
window.application = application

application.debug = true

// ✅ Load all Stimulus controllers
import "./controllers"

// ✅ (Optional) Import Action Cable channels if you're using ActionCable
import "channels"

export { application }

document.addEventListener("turbo:frame-load", (event) => {
  const autoscroller = document.querySelector("[data-controller='autoscroll']")
  if (autoscroller && autoscroller.controller) {
    autoscroller.controller.scrollToBottom()
  }
})
