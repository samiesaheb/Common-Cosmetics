import { application } from "./application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

eagerLoadControllersFrom("controllers", application)
import MentionAutocompleteController from "./mention_autocomplete_controller"
application.register("mention-autocomplete", MentionAutocompleteController)
