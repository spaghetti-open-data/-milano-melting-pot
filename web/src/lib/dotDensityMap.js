import * as d3Base from 'd3';
import * as geo from 'd3-geo';

const d3 = Object.assign(d3Base, { geo });

export default {
  init: function ({
    width = 0, 
    height = 0,
    selector = '', 
  }) {
    this.width = width;
    this.height = height;
    this.selector = selector;
    return this;
  },
  prepare: function(areas) {
    this.projection = d3.geoMercator();
    this.path = d3.geoPath().projection(this.projection);

    const polyCanvas = d3.select(this.selector)
      .append('canvas')
      .attr('width', this.width)
      .attr('height', this.height)
      .style('display', 'none');

    const dotCanvas = d3.select(this.selector)
      .append('canvas')
      .attr('width', this.width)
      .attr('height', this.height)
      // .style('position', 'absolute')
      .style('top', '0')
      .style('left', '0');

    this.polyContext = polyCanvas.node().getContext('2d');
    this.dotContext = dotCanvas.node().getContext('2d');

    return Promise.resolve(areas);
  },
  loadData(areasJSON, populationJSON) {
    return Promise.all([
      d3.json(areasJSON),
      d3.json(populationJSON),
    ])
  },
  centerZoom: function(areas) {
    this.projection
      .scale(1)
      .translate([0, 0]);

    const b = this.path.bounds(areas);
    const s = 1 / Math.max((b[1][0] - b[0][0]) / this.width, (b[1][1] - b[0][1]) / this.height);
    const t = [(this.width - s * (b[1][0] + b[0][0])) / 2, (this.height - s * (b[1][1] + b[0][1])) / 2];

    this.projection
      .scale(s)
      .translate(t);
    
    return Promise.resolve(areas);
  },
  drawAreas(areas) {
    let i = areas.features.length;
    while (i--) {
      const r = parseInt(i / 256, 10);
      const g = i % 256;
      this.drawPolygon(this.polyContext, areas.features[i], `rgb(${r},${g},0)`, `rgb(${r},${g},0)`);
      this.drawPolygon(this.dotContext, areas.features[i], null, 'rgba(161, 161, 161, 1');
    }
    this.imageData = this.polyContext.getImageData(0, 0, this.width, this.height);
    return Promise.resolve();
  },
  drawDotLayer(areas, features, color, ratio) {
    let i = features.length;
    while (i--) {
      const pop = features[i].Pop * ratio; // one dot = 1 person
      if (!pop) continue;
      const index = features[i].IdNil - 1;
      const area = areas.features[index];
      const bounds = this.path.bounds(area);
      const x0 = bounds[0][0];
      const y0 = bounds[0][1];
      const w = bounds[1][0] - x0;
      const h = bounds[1][1] - y0;
      let hits = 0;
      let count = 0;
      const limit = pop * 10; // limit tests just in case of infinite loops
      let x;
      let y;
      const r = parseInt(i / 256, 10);
      const g = i % 256;

      // test random points within feature bounding box
      while (hits < pop - 1 && count < limit) {	// we're done when we either have enough dots or have tried too many times
        x = parseInt(x0 + Math.random() * w, 10);
        y = parseInt(y0 + Math.random() * h, 10);

        // use pixel color to determine if point is within polygon. draw the dot if so.
        if (this.testPixelColor(x, y, this.width, r, g)) {
          this.drawPixel(x, y, ...color);
          hits++;
        }
        count++;
      }
    }
  },
  testPixelColor(x, y, w, r, g) {
    const index = (x + y * w) * 4;
    return this.imageData.data[index + 0] === r && this.imageData.data[index + 1] === g;
  },
  drawPolygon(context, feature, fill, stroke) {
    const { coordinates } = feature.geometry;

    
    context.beginPath();
    coordinates.forEach((ring) => {
      ring.forEach((coord, i) => {
        const projected = this.projection(coord);
        if (i === 0) {
          context.moveTo(projected[0], projected[1]);
        } else {
          context.lineTo(projected[0], projected[1]);
        }
      });
    });
    context.closePath();
    if (stroke) {
      context.strokeStyle = stroke;
      context.lineWidth = 0.3;
      context.stroke();
    }
    if (fill) {
      context.fillStyle = fill;
      context.fill();
    }
  },
  drawPixel(x, y, r, g, b, a) {
    this.dotContext.fillStyle = `rgba(${r},${g},${b},${a})`;
    this.dotContext.fillRect(x, y, 1, 1);
  },
  resetChart: function(width, height, areas) {
    this.width = width;
    this.height = height;
    this.polyContext.canvas.height = this.height;
    this.dotContext.canvas.width  = this.width;
    this.polyContext.clearRect(0, 0, this.width, this.height);
    this.dotContext.clearRect(0, 0, this.width, this.height);
    return Promise.resolve(areas);
  }
}

