import { Controller } from "@hotwired/stimulus"

// Filters the room rail's grouped list by room name/id as you type.
export default class extends Controller {
  static targets = ["input", "item", "group"]

  filter() {
    const q = this.inputTarget.value.trim().toLowerCase()

    this.itemTargets.forEach((item) => {
      const match = !q || item.dataset.searchText.includes(q)
      item.style.display = match ? "" : "none"
    })

    this.groupTargets.forEach((group) => {
      const anyVisible = Array.from(group.querySelectorAll(".rail-item")).some(
        (item) => item.style.display !== "none"
      )
      group.style.display = anyVisible ? "" : "none"
    })
  }
}
