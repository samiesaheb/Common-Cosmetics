import { Application } from "@hotwired/stimulus"
import ReplyFormController from "./controllers/reply_form_controller"

const application = Application.start()

// ✅ Make Stimulus available globally (you’re missing this part)
window.Stimulus = application

application.debug = false
application.register("reply-form", ReplyFormController)
