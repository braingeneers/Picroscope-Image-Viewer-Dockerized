import Vue from 'vue'
import App from './App.vue'
import Hammer from 'hammerjs'
import router from './router'

Vue.config.productionTip = false

Vue.directive("pan", {
  bind: function(el, binding) {
    if (typeof binding.value === "function") {
      const mc = new Hammer(el);
      mc.get("pan").set({ direction: Hammer.DIRECTION_ALL });
      mc.on("pan", binding.value);
    }
  }
})



new Vue({
  router,
  render: h => h(App)
}).$mount('#app')
