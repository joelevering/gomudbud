import { Controller } from "@hotwired/stimulus"

// Ports room-editor.html's BFS-layered SVG map view: reads {id, name, exits}
// for every room from an embedded JSON blob and draws a click-to-jump graph.
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

  areaOf(name) {
    return (name || "").split(" - ")[0].trim() || "Unsorted"
  }

  colorForArea(area) {
    const palette = ["#e0a458", "#4fa3c7", "#9d7fd6", "#7fb87f", "#e2685a", "#5fb8a8", "#c9a0dc", "#d6b34f", "#6f9ce0", "#e08fb0"]
    let h = 0
    for (let i = 0; i < area.length; i++) h = (h * 31 + area.charCodeAt(i)) >>> 0
    return palette[h % palette.length]
  }

  shortName(name) {
    const parts = (name || "").split(" - ")
    return parts.length > 1 ? parts.slice(1).join(" - ") : name
  }

  truncate(s, n) {
    return s.length > n ? s.slice(0, n - 1) + "…" : s
  }

  escapeHtml(s) {
    return String(s == null ? "" : s).replace(/[&<>"']/g, (c) => (
      { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]
    ))
  }

  buildLegend(rooms) {
    const areas = {}
    rooms.forEach((r) => { areas[this.areaOf(r.name)] = true })
    let html = '<div class="map-legend">'
    Object.keys(areas).sort().forEach((a) => {
      html += `<span class="swatch"><span class="dot" style="background:${this.colorForArea(a)}"></span>${this.escapeHtml(a)}</span>`
    })
    return html + "</div>"
  }

  // Lays rooms out clustered by area first (so a room is always positioned
  // by what it's named, not by whether a directed exit graph happens to
  // reach it yet), with a small local BFS inside each area for sub-shape,
  // and area-blocks tiled left-to-right/wrapping so the canvas stays bounded.
  layoutRooms(rooms) {
    const byId = {}
    rooms.forEach((r) => { byId[r.id] = r })

    const areaGroups = {}
    rooms.forEach((r) => {
      const a = this.areaOf(r.name)
      if (!areaGroups[a]) areaGroups[a] = []
      areaGroups[a].push(r)
    })

    const minId = (list) => Math.min(...list.map((r) => r.id))
    const areaNames = Object.keys(areaGroups).sort((a, b) => minId(areaGroups[a]) - minId(areaGroups[b]))

    const colW = 190, rowH = 58, nodeW = 158, nodeH = 34
    const padX = 40, padY = 30, labelH = 26, clusterGapX = 50, clusterGapY = 40
    const maxCanvasWidth = 1500

    const pos = {}
    const clusters = []
    let cursorX = padX
    let cursorY = padY
    let rowMaxHeight = 0

    areaNames.forEach((area) => {
      const roomsInArea = areaGroups[area].slice().sort((a, b) => a.id - b.id)
      const areaIds = new Set(roomsInArea.map((r) => r.id))

      const layer = {}
      const visited = {}
      const queue = []
      const localRoot = roomsInArea[0]
      layer[localRoot.id] = 0
      visited[localRoot.id] = true
      queue.push(localRoot.id)
      while (queue.length) {
        const cur = queue.shift()
        ;(byId[cur].exits || []).forEach((e) => {
          const t = e.room_id
          if (areaIds.has(t) && !visited[t]) {
            visited[t] = true
            layer[t] = layer[cur] + 1
            queue.push(t)
          }
        })
      }
      let maxLocalLayer = 0
      roomsInArea.forEach((r) => { if (r.id in layer) maxLocalLayer = Math.max(maxLocalLayer, layer[r.id]) })
      roomsInArea.forEach((r) => { if (!(r.id in layer)) layer[r.id] = maxLocalLayer + 1 })

      const byLocalLayer = {}
      roomsInArea.forEach((r) => {
        const l = layer[r.id]
        if (!byLocalLayer[l]) byLocalLayer[l] = []
        byLocalLayer[l].push(r)
      })
      const localLayers = Object.keys(byLocalLayer).map(Number).sort((a, b) => a - b)

      let blockRows = 0
      localLayers.forEach((l) => {
        byLocalLayer[l].sort((a, b) => a.id - b.id)
        blockRows = Math.max(blockRows, byLocalLayer[l].length)
      })
      const blockWidth = localLayers.length * colW
      const blockHeight = labelH + blockRows * rowH

      if (cursorX > padX && cursorX + blockWidth > maxCanvasWidth) {
        cursorX = padX
        cursorY += rowMaxHeight + clusterGapY
        rowMaxHeight = 0
      }

      localLayers.forEach((l) => {
        byLocalLayer[l].forEach((r, i) => {
          pos[r.id] = { x: cursorX + l * colW, y: cursorY + labelH + i * rowH }
        })
      })

      clusters.push({ name: area, x: cursorX, y: cursorY, width: blockWidth, height: blockHeight, color: this.colorForArea(area) })

      rowMaxHeight = Math.max(rowMaxHeight, blockHeight)
      cursorX += blockWidth + clusterGapX
    })

    let svgW = padX, svgH = padY
    Object.values(pos).forEach((p) => {
      svgW = Math.max(svgW, p.x + nodeW)
      svgH = Math.max(svgH, p.y + nodeH)
    })
    svgW += padX
    svgH += padY

    return { pos, clusters, svgW, svgH, colW, rowH, nodeW, nodeH }
  }

  buildSvg(rooms) {
    const byId = {}
    rooms.forEach((r) => { byId[r.id] = r })

    const { pos, clusters, svgW, svgH, nodeW, nodeH } = this.layoutRooms(rooms)

    let clustersSvg = ""
    clusters.forEach((c) => {
      clustersSvg +=
        `<rect class="cluster-rect" x="${c.x - 12}" y="${c.y - 12}" width="${c.width + 4}" height="${c.height + 4}" rx="10" fill="${c.color}0d" stroke="${c.color}55" />` +
        `<text class="cluster-label" x="${c.x - 8}" y="${c.y + 4}" fill="${c.color}">${this.escapeHtml(c.name)}</text>`
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
      const color = this.colorForArea(this.areaOf(r.name))
      nodesSvg +=
        `<g class="node" data-id="${r.id}">` +
          `<rect class="node-rect" x="${p.x}" y="${p.y}" width="${nodeW}" height="${nodeH}" rx="7" fill="${color}22" stroke="${color}" />` +
          `<text class="node-id" x="${p.x + 8}" y="${p.y + 13}" fill="${color}">#${r.id}</text>` +
          `<text class="node-label" x="${p.x + 8}" y="${p.y + 26}">${this.escapeHtml(this.truncate(this.shortName(r.name), 20))}</text>` +
        "</g>"
    })

    return `<svg width="${svgW}" height="${svgH}" viewBox="0 0 ${svgW} ${svgH}">${clustersSvg}${edgesSvg}${nodesSvg}</svg>`
  }
}
