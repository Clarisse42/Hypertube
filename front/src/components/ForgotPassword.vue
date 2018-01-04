<template>
  <div class="container">

    <div class="row">
      <div class="col s12 m6 offset-m3">
        <div class="card" style="margin-top: 20%">
          <div class="card-content">
            <span class="card-title">{{ $t('forgotpassword') }}</span>
            <div class="row">

              <form v-on:submit.prevent="resetPassword">

              <div class="input-field col s12">
                <input id="username" v-model="email" type="email" required>
                <label for="username" class="active">{{ $t('signup.email') }}</label>
              </div>


              <label class="input-field col s12 right-align">
                <router-link to="/" class="blue-grey-text text-darken-3">{{ $t('back_to_login') }}</router-link>
              </label>
              <div class="input-field col s12 right-align">
                <button type="submit" class="btn-large blue-grey darken-3 white-text"><i class="material-icons left white-text">send</i> <span class="white-text">{{ $t('setting.submit') }}</span></button>
              </div>
              </form>
            </div>
          </div>
        </div>
      </div>
      <div class="box_language">
        <span class="language text-white" :class="{'active' : $i18n.locale === 'fr'}" v-on:click="changeLocale('fr')">fr</span>
        <span class="language text-white" :class="{'active' : $i18n.locale === 'en'}" v-on:click="changeLocale('en')">en</span>
      </div>
    </div>

  </div>
</template>


<script type="text/babel">
  import Socket from './Socket.js'
  import Vuex from 'vuex'
  import axios from 'axios'

  export default {
    store: Socket,
    name: 'Login',
    data () {
      return {
        email: ''
      }
    },

    computed: {
      ...Vuex.mapGetters(['api_url', 'api_image'])
    },

    methods: {
      ...Vuex.mapActions(['change_locale', 'saveUser']),

      resetPassword: function (e) {
        e.preventDefault()
        this.buttonAnimation(e, false, this.$t('setting.submit'))

        axios.post(this.api_url + '/sessions/reset', {user: {
          'email': this.email
        }
        }, {headers: {'Language': this.$i18n.locale}}).then(response => {
          if (response.status === 202 && !response.data.status) {
            this.$toast.error({message: response.data.message})
          } else if (response.status === 200 && response.data.status) {
            this.$toast.success({message: response.data.message})
          }
          this.buttonAnimation(e, true, this.$t('action.reset'))
        }).catch(() => {
          this.$toast.error({message: 'An error has occured'})
          this.buttonAnimation(e, true, this.$t('action.reset'))
        })
      },

      changeLocale: function (lang) {
        if (lang === 'fr' || lang === 'en') {
          this.$i18n.locale = lang
        } else {
          this.$i18n.locale = 'en'
        }
      },

      buttonAnimation: function (e, status, message) {
        if (e.srcElement) {
          e = e.srcElement.getElementsByTagName('button')[0]
          if (!status) {
            e.innerHTML = '<i class="fa fa-circle-o-notch fa-spin fa-3x fa-fw"></i>'
            e.className = 'btn-large blue-grey darken-3 disabled'
          } else {
            e.innerHTML = '<span class="white-text">' + message + '</span>'
            e.className = 'btn-large blue-grey darken-3'
          }
        }
      }
    },

    mounted () {

    }
  }
</script>

<style>
  .logo {
    position: relative;
    width: 100%;
    height: auto;
    float: left;
    text-align: center;
  }

  .logo img {
    max-width: 100%;
    width: 400px;
  }

</style>
