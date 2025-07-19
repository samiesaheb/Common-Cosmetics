import { Application } from "@hotwired/stimulus"

const application = Application.start()
window.application = application // ✅ enables console debugging

application.debug = true

export { application }
