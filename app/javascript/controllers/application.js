import { Application } from "@hotwired/stimulus"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

// Start the Stimulus app
const application = Application.start()
window.application = application
application.debug = true

// Eager load any auto-registered controllers from /controllers
eagerLoadControllersFrom("controllers", application)

// ✅ Explicitly register custom controllers
import ImagePreviewController from "./controllers/image_preview_controller"
import RatingController from "./controllers/rating_controller"

application.register("image-preview", ImagePreviewController)
application.register("rating", RatingController)
