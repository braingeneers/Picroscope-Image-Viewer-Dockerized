<div id="app">
  <h1>Hello App!</h1>
  <p>
    <!-- use the router-link component for navigation. -->
    <!-- specify the link by passing the `to` prop. -->
    <!-- `<router-link>` will render an `<a>` tag with the correct `href` attribute -->
    <router-link to="/">Go to Home</router-link>
    <!-- <router-link to="/about">Go to About</router-link> -->
  </p>
  <!-- route outlet -->
  <!-- component matched by the route will render here -->
  <router-view></router-view>
</div>

<script>
import MainView from "./components/mainView.vue"
//import Images2 from "./components/Images2.vue"
export default {
  name: "app",
  components: {
    MainView,
    //Images2
  },
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
