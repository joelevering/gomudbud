import { Controller } from "@hotwired/stimulus"
import { layoutRooms, colorForArea, shortName, truncate, escapeHtml } from "room_map_layout"

// Renders the Map tab: reads {id, name, area, exits} for every room from an
// embedded JSON blob (see rooms/map.html.haml), lays them out via
// layoutRooms (see room_map_layout.js), and draws a click-to-jump SVG graph.
export default class extends Controller {
  static values = { editUrlTemplate: String }

  connect() {
    const rooms = JSON.parse(document.getElementById("map-data").textContent)
    this.element.innerHTML = this.buildLegend(rooms) + this.buildSvg(rooms)

    this.element.querySelectorAll(".node").forEach((g) => {
      g.addEventListener("click", () => {
        window.Turbo.visit(this.editUrlTemplateValue.replace("__ID__", g.dataset.id))
      })
    })
  }

  buildLegend(rooms) {
    const areas = {}
    rooms.forEach((r) => { areas[r.area] = true })
    let html = '<div class="map-legend">'
    Object.keys(areas).sort().forEach((a) => {
      html += `<span class="swatch"><span class="dot" style="background:${colorForArea(a)}"></span>${escapeHtml(a)}</span>`
    })
    return html + "</div>"
  }

  buildSvg(rooms) {
    const byId = {}
    rooms.forEach((r) => { byId[r.id] = r })

    const { pos, clusters, svgW, svgH, nodeW, nodeH } = layoutRooms(rooms)

    let clustersSvg = ""
    clusters.forEach((c) => {
      clustersSvg +=
        `<rect class="cluster-rect" x="${c.x - 12}" y="${c.y - 12}" width="${c.width + 4}" height="${c.height + 4}" rx="10" fill="${c.color}0d" stroke="${c.color}55" />` +
        `<text class="cluster-label" x="${c.x - 8}" y="${c.y + 4}" fill="${c.color}">${escapeHtml(c.name)}</text>`
    })

    let edgesSvg = ""
    const seen = {}
    rooms.forEach((r) => {
      ;(r.exits || []).forEach((e) => {
        if (!pos[r.id] || !pos[e.room_id]) return
        const a = r.id, b = e.room_id
        const key = a < b ? `${a}-${b}` : `${b}-${a}`
        const reciprocal = byId[b] && (byId[b].exits || []).some((be) => be.room_id === a)
        if (reciprocal && seen[key]) return
        seen[key] = true
        const p1 = pos[a], p2 = pos[b]
        const x1 = p1.x + nodeW / 2, y1 = p1.y + nodeH / 2
        const x2 = p2.x + nodeW / 2, y2 = p2.y + nodeH / 2
        edgesSvg += `<line class="edge-line${reciprocal ? "" : " oneway"}" x1="${x1}" y1="${y1}" x2="${x2}" y2="${y2}" />`
      })
    })

    let nodesSvg = ""
    rooms.forEach((r) => {
      const p = pos[r.id]
      if (!p) return
      const color = colorForArea(r.area)
      nodesSvg +=
        `<g class="node" data-id="${r.id}">` +
          `<rect class="node-rect" x="${p.x}" y="${p.y}" width="${nodeW}" height="${nodeH}" rx="7" fill="${color}22" stroke="${color}" />` +
          `<text class="node-id" x="${p.x + 8}" y="${p.y + 13}" fill="${color}">#${r.id}</text>` +
          `<text class="node-label" x="${p.x + 8}" y="${p.y + 26}">${escapeHtml(truncate(shortName(r.name), 20))}</text>` +
        "</g>"
    })

    return `<svg width="${svgW}" height="${svgH}" viewBox="0 0 ${svgW} ${svgH}">${clustersSvg}${edgesSvg}${nodesSvg}</svg>`
  }
}
