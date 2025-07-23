import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["output", "removeButton"];

  preview(event) {
    const input = event.target;
    if (input.files && input.files[0]) {
      this.outputTarget.src = URL.createObjectURL(input.files[0]);
      this.outputTarget.classList.remove("hidden");
      this.removeButtonTarget.classList.remove("hidden");
    }
  }

  remove() {
    this.outputTarget.src = "";
    this.outputTarget.classList.add("hidden");
    this.removeButtonTarget.classList.add("hidden");
    this.element.querySelector("input[type='file']").value = null;
  }
}