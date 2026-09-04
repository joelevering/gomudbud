import { Controller } from "@hotwired/stimulus"

// Prefills Exp from Level (level * 10, the convention used throughout the
// world data) whenever Exp is still blank -- never overwrites a value the
// user already typed in.
export default class extends Controller {
  static targets = ["level", "exp"]

  suggest() {
    if (this.expTarget.value.trim() !== "") return

    const level = parseInt(this.levelTarget.value, 10)
    if (Number.isNaN(level)) return

    this.expTarget.value = level * 10
  }
}
