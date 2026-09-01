// Pure helpers for the room Map tab: no DOM, no Stimulus, just data in /
// positions & strings out. Kept separate from room_map_controller.js so the
// layout math is independently testable and reusable.

export function colorForArea(area) {
  const palette = ["#e0a458", "#4fa3c7", "#9d7fd6", "#7fb87f", "#e2685a", "#5fb8a8", "#c9a0dc", "#d6b34f", "#6f9ce0", "#e08fb0"]
  let h = 0
  for (let i = 0; i < area.length; i++) h = (h * 31 + area.charCodeAt(i)) >>> 0
  return palette[h % palette.length]
}

export function shortName(name) {
  const parts = (name || "").split(" - ")
  return parts.length > 1 ? parts.slice(1).join(" - ") : name
}

export function truncate(s, n) {
  return s.length > n ? s.slice(0, n - 1) + "…" : s
}

export function escapeHtml(s) {
  return String(s == null ? "" : s).replace(/[&<>"']/g, (c) => (
    { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]
  ))
}

// Lays rooms out clustered by area first (so a room is always positioned by
// what it's named, not by whether a directed exit graph happens to reach it
// yet), with a small local BFS inside each area for sub-shape, and
// area-blocks tiled left-to-right/wrapping so the canvas stays bounded.
// Expects each room as { id, name, area, exits: [{ room_id }] }.
export function layoutRooms(rooms) {
  const byId = {}
  rooms.forEach((r) => { byId[r.id] = r })

  const areaGroups = {}
  rooms.forEach((r) => {
    if (!areaGroups[r.area]) areaGroups[r.area] = []
    areaGroups[r.area].push(r)
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

    clusters.push({ name: area, x: cursorX, y: cursorY, width: blockWidth, height: blockHeight, color: colorForArea(area) })

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

  return { pos, clusters, svgW, svgH, nodeW, nodeH }
}
