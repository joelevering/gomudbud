import { Controller } from "@hotwired/stimulus"

// Live valid/invalid preview of an exit's target room, looked up from a
// {id: name} map embedded in the page as JSON (see rooms/_header).
export default class extends Controller {
  static targets = ["input", "preview"]

  connect() {
    this.names = JSON.parse(document.getElementById("rooms-index-data").textContent)
    this.inputTargets.forEach((input) => this.updateRow(input))
  }

  preview(event) {
    this.updateRow(event.target)
  }

  updateRow(input) {
    const row = input.closest(".row-card")
    const preview = row.querySelector('[data-exit-target-target="preview"]')
    if (!preview) return

    const id = input.value.trim()
    const name = id !== "" ? this.names[id] : undefined

    input.classList.toggle("invalid", id !== "" && !name)
    preview.className = "target-preview" + (name ? " ok" : id !== "" ? " bad" : "")
    preview.textContent = name ? "→ " + name : id !== "" ? "No room with this id yet" : ""
  }
}
