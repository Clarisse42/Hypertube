import Vue from 'vue'
import App from './App'
import router from './router'
import VueResource from 'vue-resource'
import CxltToastr from 'cxlt-vue2-toastr'
import 'cxlt-vue2-toastr/dist/css/cxlt-vue2-toastr.css'
import Vue2Filters from 'vue2-filters'
import VueCarousel from 'vue-carousel'
// import socketio from 'socket.io-client'
// import VueSocketIO from 'vue-socket.io'
// import Socket from './components/Socket'
import VueSweetAlert from 'vue-sweetalert'
import VTooltip from 'v-tooltip'
import VueI18n from 'vue-i18n'
import messages from './locales'
import moment from 'moment'
import FlagIcon from 'vue-flag-icon'
import infiniteScroll from 'vue-infinite-scroll'
import 'materialize-css/dist/js/materialize.min.js'
import 'materialize-css/dist/css/materialize.min.css'

Vue.config.productionTip = false
Vue.use(VueI18n)

const i18n = new VueI18n({
  locale: 'en',
  messages
})

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  template: '<App/>',
  localStorage: {},
  components: { App },
  i18n
})

Vue.use(VueResource)
Vue.use(VTooltip)
Vue.use(CxltToastr, { position: 'top right', closeButton: false })
Vue.use(Vue2Filters)
Vue.use(VueSweetAlert)
Vue.use(VueCarousel)
Vue.use(FlagIcon)
Vue.filter('formatDate', function (value) {
  if (value) {
    return moment(value, 'YYYY-MM-DD').format('MM/DD/YYYY')
  }
})

Vue.use(infiniteScroll)
