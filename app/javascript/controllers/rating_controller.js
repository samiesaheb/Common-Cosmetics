import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["container", "input"];

  connect() {
    this.updateStars();
  }

  select(event) {
    const value = parseInt(event.currentTarget.dataset.value);
    this.inputTarget.value = value;
    this.updateStars();
  }

  updateStars() {
    const value = parseInt(this.inputTarget.value);
    this.containerTarget.querySelectorAll("button").forEach((button, index) => {
      button.classList.toggle("text-yellow-400", index < value);
      button.classList.toggle("text-gray-300", index >= value);
      button.classList.toggle("dark:text-gray-600", index >= value);
    });
  }
}