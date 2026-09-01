import { Controller } from "@hotwired/stimulus"

// Generic add/remove for Rails nested fields_for collections.
// Usage: wrap the repeated rows in an element with data-nested-fields-target="target",
// provide a <template data-nested-fields-target="template"> containing a blank row
// rendered with child_index: "NEW_RECORD", and an "+ Add" button with
// data-action="nested-fields#add". Each row needs a "Remove" button with
// data-action="nested-fields#remove" and a .nested-fields class marking the row itself.
export default class extends Controller {
  static targets = ["target", "template"]

  add(event) {
    event.preventDefault()
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, Date.now())
    this.targetTarget.insertAdjacentHTML("beforeend", content)
  }

  remove(event) {
    event.preventDefault()
    const row = event.target.closest(".nested-fields")
    if (!row) return

    const destroyInput = row.querySelector("input[name*='_destroy']")
    if (destroyInput) {
      destroyInput.value = "1"
      row.style.display = "none"
    } else {
      row.remove()
    }
  }
}
