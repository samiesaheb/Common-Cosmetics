// app/javascript/controllers/index.js
import { application } from "../application"
import DropdownController from "./dropdown_controller"
import MentionAutocompleteController from "./mention_autocomplete_controller"
import TypingController from "./typing_controller"
import EmojiPickerController from "./emoji_picker_controller"
import AutoscrollController from "./autoscroll_controller"

import TestController from "./test_controller"

application.register("dropdown", DropdownController)
application.register("mention-autocomplete", MentionAutocompleteController)
application.register("typing", TypingController)
application.register("emoji-picker", EmojiPickerController)
application.register("autoscroll", AutoscrollController)

application.register("test", TestController)


