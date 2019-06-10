<template>
  <form class="chart-controls" @submit.prevent="handleSubmit">
    <div class=" has-text-light columns">
      <div class="column countries">
        <div v-for="region in regions" v-bind:key="region.code" class="field">
          <span class="square" :style="{backgroundColor: formatColor(region)}" v-if="!editing"></span>
          <input
            class="is-checkradio is-white"
            type="checkbox"
            :name="`checkbox-${region.code}`"
            :id="`checkbox-${region.code}`"
            :value="region.code"
            v-model="form.activeRegions"
          >
          <label :for="`checkbox-${region.code}`" class="has-text-weight-semibold" :class="{'active': isActive(region)}" :style="{ color: formatColor(region) }">{{region.text}}</label>
        </div>
      </div>
      <div class="column">
        <div class="field">
          <h2 class="is-size-5 has-text-light">Anno</h2>
          <div class="control">
            <input class="slider is-fullwidth is-small" step="1" min="1999" max="2018" type="range" v-model="form.activeYear">
          </div>
          <span class="value has-text-white is-size-4 is-family-secondary ">
            {{form.activeYear}}
          </span>
        </div>
        <hr>
        <div class="field">
          <label class="label has-text-light">Punti per persona</label>
          <div class="control">
            <input class="slider is-fullwidth is-small" step="0.25" min="0.25" max="2" type="range" v-model="form.ratio">
          </div>
          <span class="value has-text-white is-size-4 is-family-secondary ">
            {{form.ratio}}
          </span>
        </div>
        <hr>
        <div class="field">
          <h2 class="is-size-5 has-text-light">Opacità</h2>
          <div class="control">
            <input class="slider is-fullwidth is-small" step="0.1" min="0.1" max="1" type="range" v-model="form.opacity">
          </div>
          <span class="value has-text-white is-size-4 is-family-secondary ">
            {{form.opacity}}
          </span>
        </div>
      </div>
    </div>
  </form>
</template>

<script>
export default {
  name: 'Map1Controls',
  props: [
    'regions', 'activeRegions', 'years', 'activeYear', 'ratio', 'opacity',
  ],
  data() {
    return {
      editing: false,
      form: {
        activeRegions: this.activeRegions,
        activeYear: this.activeYear,
        ratio: this.ratio,
        opacity: this.opacity,
      },
    };
  },
  watch: {
    form: {
      handler() {
        this.$emit('updateSettings', this.form);
      },
      deep: true,
    },
  },
  computed: {
  },
  methods: {
    formatColor({ color, code }) {
      return `rgba(${color[0]}, ${color[1]}, ${color[2]}, ${this.isActive({ code }) ? 1 : 0.3})`;
    },
    isActive({ code }) {
      return this.form.activeRegions.includes(code);
    },
  },
};
</script>

<style lang="scss">
.chart-controls {

  .field {
    position: relative;

    &:not(last-child) {
      margin-bottom: .2rem;
    }
  }

  .square {
    width: 1.5rem;
    height: 1.5rem;
    border: .1rem solid #dbdbdb;
    margin-right: 1rem;
    display: inline-flex;
    vertical-align: bottom;
    border-radius: 100%;
    position: absolute;
    top: 0px;
  }

  .is-checkradio[type=checkbox] + label::before {
    visibility: hidden;
  }


  .countries label {
    padding: .2rem .5rem .2rem 2rem;
    margin-top: .5rem;
    margin-bottom: .5rem;
    vertical-align: middle;
    color: rgba(whitesmoke, 0.3);
    &.active {
      color: whitesmoke;
    }
  }

  .buttons-container {
    margin-top: 1rem;
  }
}

</style>
