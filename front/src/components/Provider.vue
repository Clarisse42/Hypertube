<template>
  <div class="white-text">

    <div class="fulloader transparent" v-bind:class="{ 'danger': error, 'success': success }">


      <div class="provider">
        <img :src="'/static/' + $route.params.provider + '-logo.svg'" :alt="$route.params.provider">
        <h5 v-show="!error && !success">{{ $t('provider.pleaseallow') }} {{ $route.params.provider }}</h5>
        <h5 v-show="error">{{ $t('provider.error') }}</h5>
        <h5 v-show="success">{{ $t('provider.success') }}</h5>

        <div class="preloader-wrapper big active" v-show="!error && !success">
          <div class="spinner-layer spinner-blue-only">
            <div class="circle-clipper left">
              <div class="circle"></div>
            </div><div class="gap-patch">
            <div class="circle"></div>
          </div><div class="circle-clipper right">
            <div class="circle"></div>
          </div>
          </div>
        </div>



        <router-link to="/signin" class="btn-large white black-text" v-show="!success"><i class="material-icons left">keyboard_backspace</i> back to login page</router-link>
      </div>

    </div>


  </div>
</template>


<script type="text/babel">
  import Socket from './Socket.js'
  import axios from 'axios'
  import Vuex from 'vuex'

  export default {
    store: Socket,
    name: 'Provider',
    data () {
      return {
        error: false,
        success: false
      }
    },

    computed: {
      ...Vuex.mapGetters(['api_url', 'api_image', 'movies_selected'])
    },

    methods: {
      ...Vuex.mapActions(['change_locale', 'saveUser']),
      auth: function () {
        axios.get(this.api_url + '/sessions', {headers: {'Authorization': localStorage.getItem('token')}}).then(response => {
          if (response.data.status) {
            this.success = true
            this.saveUser(response.data.user)
            this.$router.push('/')
          }
        }).catch(() => {
          this.error = true
        })
      }
    },

    beforeCreate () {
      if (!(this.$route.params.provider === 'facebook' || this.$route.params.provider === 'github' || this.$route.params.provider === 'marvin' || this.$route.params.provider === 'amazon' || this.$route.params.provider === 'twitch' || this.$route.params.provider === 'google_oauth2')) {
        this.$router.push('/signin')
      }
    },

    created () {
      var y = window.outerHeight / 2 + window.screenY - (900 / 2)
      var x = window.outerWidth / 2 + window.screenX - (700 / 2)
      var url = ''
      if (this.$route.params.provider !== 'marvin') {
        url = 'http://localhost:8999/auth/' + this.$route.params.provider
      } else {
        url = 'http://localhost:8999/auth/marvin/request'
      }
      var win = window.open(url, 'Sign In/Up to Hypertube', 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, width=900, height=700, top=' + y + ', left=' + x)
      if (win) {
        var timer = setInterval(() => {
          if (win.closed) {
            if (localStorage.getItem('hypertube_login')) {
              localStorage.setItem('token', localStorage.getItem('hypertube_login'))
              localStorage.removeItem('hypertube_login')
              this.auth()
            } else {
              this.error = true
            }
            clearInterval(timer)
          }
        }, 1000)
      }
    }
  }
</script>


<style>
  .provider {
    margin: auto;
    text-align: center;
  }

  .provider img {
    height: 100px;
    fill: #fff !important;
  }

  .provider h5 {
    text-align: center;
    margin-bottom: 100px;
  }

  .provider a {
    display: block;
    margin-top: 100px;
  }
</style>
