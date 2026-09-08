import { Controller } from "@hotwired/stimulus"

// Lets an exit's target be typed as a room name (autocompleted from the
// #room-options <datalist>, see rooms/_header) or a bare id. Resolves the
// typed text against the {id: name} map embedded in the page (also in
// rooms/_header) and writes the resolved id into the real hidden field.
export default class extends Controller {
  static targets = ["input", "hidden", "preview"]

  connect() {
    this.names = JSON.parse(document.getElementById("rooms-index-data").textContent)
    // Preview whatever's already in the hidden field without touching it --
    // a dangling linked_room_id (its room got deleted) should survive as a
    // "not found" preview, not get silently cleared out from under the room.
    this.previewStoredId()
  }

  preview() {
    this.resolve()
  }

  previewStoredId() {
    const id = this.hiddenTarget.value.trim()

    if (id === "") {
      this.setPreview("", "")
    } else if (this.names[id] !== undefined) {
      this.setPreview("ok", "→ " + this.names[id])
    } else {
      this.setPreview("bad", "Room not found (id " + id + ")")
    }

    this.inputTarget.classList.toggle("invalid", id !== "" && this.names[id] === undefined)
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
  // numeric id, an unambiguous case-insensitive exact name match, then an
  // unambiguous case-insensitive name-prefix match. Room names aren't
  // unique (e.g. every unrenamed new room shares NEW_ROOM_DEFAULTS' name),
  // so both name-based branches only resolve when exactly one room matches
  // -- otherwise this would silently guess which room the user meant.
  resolveId(typed) {
    const dashIndex = typed.indexOf(" — ")
    if (dashIndex !== -1) {
      const idPart = typed.slice(0, dashIndex).trim()
      if (this.names[idPart] === typed.slice(dashIndex + 3).trim()) return idPart
    }

    if (/^\d+$/.test(typed) && this.names[typed] !== undefined) return typed

    const lower = typed.toLowerCase()
    const entries = Object.entries(this.names)

    const exactMatches = entries.filter(([, name]) => name.toLowerCase() === lower)
    if (exactMatches.length === 1) return exactMatches[0][0]

    const prefixMatches = entries.filter(([, name]) => name.toLowerCase().startsWith(lower))
    if (prefixMatches.length === 1) return prefixMatches[0][0]

    return null
  }

  setPreview(state, text) {
    this.previewTarget.className = "target-preview" + (state ? " " + state : "")
    this.previewTarget.textContent = text
  }
}
