import { Controller } from "@hotwired/stimulus"

// Lets an exit's target be typed as a room name (autocompleted from the
// #room-options <datalist>, see rooms/_header) or a bare id. Resolves the
// typed text against the {id: name} map embedded in the page (also in
// rooms/_header) and writes the resolved id into the real hidden field.
export default class extends Controller {
  static targets = ["input", "hidden", "preview"]

  connect() {
    this.names = JSON.parse(document.getElementById("rooms-index-data").textContent)
    this.resolve()
  }

  preview() {
    this.resolve()
  }

  resolve() {
    const typed = this.inputTarget.value.trim()
    const id = typed === "" ? null : this.resolveId(typed)

    if (typed === "") {
      this.hiddenTarget.value = ""
      this.setPreview("", "")
    } else if (id != null) {
      this.hiddenTarget.value = id
      this.setPreview("ok", "→ " + this.names[id])
    } else {
      this.hiddenTarget.value = ""
      this.setPreview("bad", "No matching room")
    }

    this.inputTarget.classList.toggle("invalid", typed !== "" && id == null)
  }

  // Tries, in order: exact "id — name" (what the datalist offers), a bare
  // numeric id, an exact case-insensitive name match, then an unambiguous
  // case-insensitive name-prefix match.
  resolveId(typed) {
    const dashIndex = typed.indexOf(" — ")
    if (dashIndex !== -1) {
      const idPart = typed.slice(0, dashIndex).trim()
      if (this.names[idPart] === typed.slice(dashIndex + 3).trim()) return idPart
    }

    if (/^\d+$/.test(typed) && this.names[typed] !== undefined) return typed

    const lower = typed.toLowerCase()
    const entries = Object.entries(this.names)

    const exact = entries.find(([, name]) => name.toLowerCase() === lower)
    if (exact) return exact[0]

    const prefixMatches = entries.filter(([, name]) => name.toLowerCase().startsWith(lower))
    if (prefixMatches.length === 1) return prefixMatches[0][0]

    return null
  }

  setPreview(state, text) {
    this.previewTarget.className = "target-preview" + (state ? " " + state : "")
    this.previewTarget.textContent = text
  }
}
