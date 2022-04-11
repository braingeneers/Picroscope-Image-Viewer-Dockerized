<template>
  <div id="app">
    <img alt="Braingeneers Imaging" src="./assets/logo.png">
    <label>uuid</label>
    <input v-model="uuid" placeholder="Ryan-4-2020-02-04">
    <label>group identifier</label>
    <input v-model="groupID" placeholder="C">
    <button v-on:click="$refs.images.loader('newest')">Load Latest</button>
    <button v-on:click="$refs.images.loader('oldest')">Load Beginning</button>
    <button v-on:click="$refs.images.loader('sync')">Sync</button>
    <select v-model="uuid">
      <!-- v-bind:value="option.value" :key="option.text"> -->
      <option v-for="option in options" :key="option">
        {{ option }}
      </option>
    </select>
    <!-- <button v-on:click="uuid='boof'">barf</button> -->
    <Images ref="images" v-bind:groupID="groupID" v-bind:uuid="uuid" v-bind:endpoint="endpoint"/>
    <!-- <Images2 ref="images2" v-bind:groupID="groupID" v-bind:uuid="uuid" v-bind:endpoint="endpoint"/> -->
  </div>
</template>


<script>
import Images from "./components/Images.vue"
//import Images2 from "./components/Images2.vue"
export default {
  name: "app",
  components: {
    Images,
    //Images2
  },
  data: function () {
    return {
      uuid: "2022-03-23-i-UCB-bio",
      groupID: "G",
      endpoint: "https://s3-west.nrp-nautilus.io/braingeneers/imaging",
      options: [1,2,3],
      // options: [
      //   { text: 'One', value: 'A' },
      //   { text: 'Two', value: 'B' },
      //   { text: 'Three', value: 'C' }
      // ]
    }
  },
  mounted() {
    fetch(`${this.endpoint}/uuid-manifest.txt`)
    .then(response => response.text())
    .then(textString => {
      const lines = textString.split('\n');
      for (var line of lines){
        this.options.push(line.substring(0, line.length-1))
        console.log(line.substring(0, line.length-1))
      }
      //console.log(textString);
    });
    console.log('Component has been created!');
    // console.log(poo)
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
<!-- /* <style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

nav {
  padding: 30px;
}

nav a {
  font-weight: bold;
  color: #2c3e50;
}

nav a.router-link-exact-active {
  color: #42b983;
}
</style> */ -->
