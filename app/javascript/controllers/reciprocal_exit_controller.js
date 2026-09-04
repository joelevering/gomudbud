import { Controller } from "@hotwired/stimulus"

// Shows/hides an exit row's "key/description for the exit back" fields
// based on the "create the exit back" checkbox, and requires them while visible.
export default class extends Controller {
  static targets = ["checkbox", "fields", "input"]

  connect() {
    this.sync()
  }

  toggle() {
    this.sync()
  }

  sync() {
    const checked = this.checkboxTarget.checked
    this.fieldsTarget.style.display = checked ? "" : "none"
    this.inputTargets.forEach((input) => { input.required = checked })
  }
}
