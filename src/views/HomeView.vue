<template>
  <div class="home">
    <!-- <router-view></router-view> -->
    <img alt="Braingeneers Imaging" src="@/assets/logo.png">
    <label>uuid</label>
    <input v-model="uuid" placeholder="Ryan-4-2020-02-04">
    <label>group identifier</label>
    <input v-model="groupID" placeholder="C">
    <div class="mySelectDiv">
      <v-select v-model="uuid" :options="uuid_options"></v-select>
      <v-select v-model="groupID" :options="groupID_options"></v-select>
    </div>
    <button v-on:click="redirectToURL();$refs.images.loader('newest')">Load Latest</button>
    <button v-on:click="redirectToURL();$refs.images.loader('oldest')">Load Beginning</button>
    <button v-on:click="redirectToURL();$refs.images.loader('sync')">Sync</button>
    <!-- <button @click="redirectToURL()">Go Back</button> -->
    <!-- <button v-on:click="loadTrigger=loadTrigger+1">Trigger</button> -->

    <!-- <button v-on:click="uuid='boof'">barf</button> -->
    <ImagesWord  ref="images" v-bind:groupID="groupID" v-bind:uuid="uuid" v-bind:endpoint="endpoint" v-bind:loadTrigger="loadTrigger" />
  </div>
</template>


<script>
import ImagesWord from "@/components/ImagesWord.vue"
//import Images2 from "./components/Images2.vue"
export default {
  name: "HomeView",
  props: ['uuid_from_URL','gid_from_URL'],
  components: {
    ImagesWord,
  },
  data: function () {
    return {
      uuid: "2022-03-23-i-UCB-bio",
      groupID: "G",
      endpoint: "https://s3-west.nrp-nautilus.io/braingeneers/imaging",
      uuid_options: [],
      groupID_options:['A','B','C','D','E','F','G','H'],
      loadTrigger: 0,
      // options: [
      //   { text: 'One', value: 'A' },
      //   { text: 'Two', value: 'B' },
      //   { text: 'Three', value: 'C' }
      // ]
    }
  },
  methods:{
    redirectToURL(){
      this.$router.push({ path: '/images/'+this.uuid+'/'+this.groupID });
    }
  },
  mounted() {
    //load list of uuids
    if (this.uuid_from_URL){
      this.uuid = this.uuid_from_URL
    }
    if (this.gid_from_URL){
      this.groupID = this.gid_from_URL
      this.loadTrigger++
      console.log(this.loadTrigger);
    }
    fetch(`${this.endpoint}/uuid-manifest.txt`)
    .then(response => response.text())
    .then(textString => {
      const lines = textString.split('\n');
      for (var line of lines){
        this.uuid_options.push(line.substring(0, line.length-1))
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
/* .mySelectDiv {
max-width: 500px !important;
} */

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
