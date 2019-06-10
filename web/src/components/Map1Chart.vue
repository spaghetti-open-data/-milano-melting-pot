<template>
    <div id="map1">
    </div>
</template>

<script>
import map from '../lib/dotDensityMap';

export default {
  name: 'Map1Chart',
  props: [
    'width', 'height', 'ratio', 'opacity', 'regions', 'activeRegions', 'years', 'activeYear', 'selector',
  ],
  data() {
    return {
      population: [],
      areas: [],
      map: null,
    };
  },
  mounted() {
    document.addEventListener('DOMContentLoaded', () => {
      this.map = map.init({
        width: this.width,
        height: this.height,
        ratio: this.ratio,
        selector: this.selector,
      });
      this.map.prepare();
      this.drawMap();
    });
  },
  watch: {
    watchableFields() {
      this.resetMap();
    },
  },
  computed: {
    watchableFields() {
      // `.join()` because we don't care about the return value.
      return [this.activeYear, this.activeRegions, this.ratio, this.opacity].join()
    },
  },
  methods: {
    drawMap() {
      this.loadData()
        .then(this.map.centerZoom.bind(this.map))
        .then(this.map.drawAreas.bind(this.map))
        .then(this.renderDots);
    },
    loadData() {
      return this.map
        .loadData('/quartieri.geojson', '/map1Data_d3.json')
        .then(([areas, population]) => {
          this.areas = areas;
          // TODO carica dati già ordinati
          this.areas.features = this.areas.features
            .sort((a, b) => a.properties.ID_NIL - b.properties.ID_NIL);
          this.population = population;
          return this.areas;
        });
    },
    renderDots() {
      this.activeRegions.forEach((code) => {
        const data = this.population[this.activeYear][code];
        const region = this.regions.find(el => el.code === code);
        this.map.drawDotLayer(this.areas, data, [...region.color, this.opacity], this.ratio);
      });
    },
    resetMap() {
      this.map.resetChart(this.width, this.height, this.areas)
        .then(this.map.drawAreas.bind(this.map))
        .then(this.renderDots);
    },
  },
};
</script>

<style lang="scss">
 #map1 {
   position: relative;
 }
</style>
