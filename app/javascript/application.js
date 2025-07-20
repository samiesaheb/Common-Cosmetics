import { Application } from "@hotwired/stimulus"

const application = Application.start()
window.application = application

application.debug = true

export { application }
