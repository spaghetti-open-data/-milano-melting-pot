<template>
  <div class="container">
    <div class="columns">
      <div class="column is-half">
        <div id="map1-container" v-bind:style="{ height: `${side}px` }">
          <Map1Chart
            :width="side"
            :height="side"
            :opacity="opacity"
            :ratio="ratio"
            :regions="regions"
            :active-regions="activeRegions"
            :years="years"
            :active-year="activeYear"
            :selector="selector"
            :loading="loading"
          />
        </div>
      </div>
      <div class="column is-half" id="map1-controls-column">
        <div id="map1-controls-container">
          <h1 class="is-family-secondary is-size-2 has-text-light">Milano Melting Pot - Mappa 1</h1>
          <hr>
          <Map1Controls
            :regions="regions"
            :active-regions="activeRegions"
            :years="years"
            :active-year="activeYear"
            :ratio="ratio"
            :opacity="opacity"
            v-on:updateSettings="updateSettings"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Map1Chart from './Map1Chart.vue';
import Map1Controls from './Map1Controls.vue';

export default {
  name: 'Map1',
  components: {
    Map1Chart,
    Map1Controls,
  },
  data() {
    return {
      selector: '#map1',
      side: 600,
      regions: [
        // { code: 'ita', text: 'Italia', color: [211, 211, 211] },
        { code: 'eastas', text: 'Est Asia', color: [141, 213, 179] },
        { code: 'eu15', text: 'EU 15', color: [0, 176, 255] },
        { code: 'eun13', text: 'EU N13', color: [139, 195, 73] },
        { code: 'noraf', text: 'Nord Africa', color: [245, 0, 86] },
        { code: 'noram', text: 'Nord America', color: [168, 119, 124] },
        { code: 'ocean', text: 'Oceania', color: [132, 137, 224] },
        { code: 'other', text: 'Altro', color: [122, 86, 72] },
        { code: 'otheu', text: 'Europa Non-EU', color: [255, 146, 4] },
        { code: 'seas', text: 'Sud-Est Asia', color: [241, 122, 116] },
        { code: 'soam', text: 'Sud America', color: [255, 63, 0] },
        { code: 'southas', text: 'Sud Asia', color: [200, 126, 248] },
        { code: 'ssaf', text: 'Africa sub-sahariana', color: [21, 231, 118] },
        { code: 'westas', text: 'Ovest Asia', color: [255, 235, 0] },
      ],
      activeRegions: ['eu15', 'eastas'],
      years: [1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008,
        2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018],
      activeYear: 2018,
      opacity: 0.3,
      ratio: 1,
      loading: true,
    };
  },
  mounted() {
    this.updateSide();
    let resizeTimer;
    window.onresize = () => {
      clearTimeout(resizeTimer);
      resizeTimer = setTimeout(this.updateSide, 250);
    };
  },
  methods: {
    updateSide() {
      this.side = document.querySelector('#map1-container').offsetWidth;
    },
    updateSettings(settings) {
      this.activeRegions = settings.activeRegions;
      this.activeYear = parseInt(settings.activeYear, 10);
      this.opacity = parseFloat(settings.opacity);
      this.ratio = parseFloat(settings.ratio);
    },
  },
};
</script>

<style lang="scss">
 html {
   background-color: #2a2a2a !important;
 }

 #map1-container,
 #map1-controls-container {
   margin-top: 2rem;
   margin-bottom: 2rem;
 }

 #map1-controls-column {
   display:flex;
 }

 #map1-controls-container {
   align-self: center;
   width: 100%;
 }

 #loader {
   position: absolute;
   background: #2a2a2a;
 }

</style>
