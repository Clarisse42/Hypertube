<template>
  <!--<div>-->
    <div class="container">

      <div class="row">
        <router-link to="/" class="logo">
          <img src="http://image.noelshack.com/fichiers/2017/46/3/1510754189-hypertube2.png" alt="HyperTube">
        </router-link>
        <div class="col s12 m6 offset-m3">
          <div class="card" style="margin-top: 20%">
            <div class="card-tabs">
              <div class="tabs tabs-fixed-width">
                <li class="tab col s6"><router-link to="/signin" class="active">{{ $t('menu.signin') }}</router-link></li>
                <li class="tab col s6"><router-link to="/signup">{{ $t('menu.signup') }}</router-link></li>
              </div>
            </div>
            <div class="card-content">
              <div class="row">

                <form v-on:submit.prevent="login">

                <div class="input-field inline col s12">
                  <input id="username" v-model="user.username" type="text">
                  <label for="username" class="active">{{ $t('username') }}</label>
                </div>
                <div class="input-field inline col s12">
                  <input id="password" v-model="user.password" name="password" type="password">
                  <label for="password" class="active">{{ $t('password') }}</label>
                </div>

                <label class="input-field col s12 right-align">
                  <router-link to="/forgot-password" class="blue-grey-text text-darken-3">{{ $t('password_forgot') }}</router-link>
                </label>

                <div class="input-field col s12 right-align">
                  <button type="submit" class="btn-large blue-grey darken-3 white-text"><i class="material-icons left white-text">send</i> <span class="white-text">{{ $t('menu.signin') }}</span></button>
                </div>

                </form>
              </div>
            </div>
            <div class="card-action center-align">
              <router-link to="/provider/github" class="waves-effect waves-light btn blue-grey darken-4 white-text provider">GitHub</router-link>
              <router-link to="/provider/marvin" class="waves-effect waves-light btn teal darken-2 provider">42 born2code</router-link>
              <router-link to="/provider/facebook" class="waves-effect waves-light btn light-blue darken-3 provider">Facebook</router-link>
              <router-link to="/provider/google_oauth2" class="waves-effect waves-light btn red darken-1 provider">Google</router-link>
              <router-link to="/provider/twitch" class="waves-effect waves-light btn deep-purple lighten-1 provider">Twitch</router-link>
              <router-link to="/provider/amazon" class="waves-effect waves-light btn yellow accent-4 provider">Amazon</router-link>
            </div>
          </div>
        </div>

        <div class="box_language">
          <span class="language text-white" :class="{'active' : $i18n.locale === 'fr'}" v-on:click="changeLocale('fr')">fr</span>
          <span class="language text-white" :class="{'active' : $i18n.locale === 'en'}" v-on:click="changeLocale('en')">en</span>
        </div>
      </div>
      </div>

    </div>
  <!--</div>-->
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
        user: {
          username: '',
          password: ''
        },
        bg: [
          'http://image.tmdb.org/t/p/w1280/5Wj23Vyiz2mrGBctsl3pYQDgI6d.jpg',
          'http://image.tmdb.org/t/p/w1280/5Wj23Vyiz2mrGBctsl3pYQDgI6d.jpg',
          'http://image.tmdb.org/t/p/w1280/5Wj23Vyiz2mrGBctsl3pYQDgI6d.jpg'
        ]
      }
    },

    computed: {
      ...Vuex.mapGetters(['api_url', 'api_image'])
    },

    methods: {
      ...Vuex.mapActions(['change_locale', 'saveUser']),

      login: function (e) {
        e.preventDefault()
        this.buttonAnimation(e, false, this.$t('menu.signin'))

        axios.post(this.api_url + '/sessions', {user: {
          'username': this.user.username,
          'password': this.user.password
        }
        }, {headers: {'Language': this.$i18n.locale}}).then(response => {
          if (response.status === 200) {
            localStorage.setItem('token', response.data.token)
            this.saveUser(response.data.user)
            this.changeLocale(response.data.user.language)
            this.$router.push('/')
          }
          this.buttonAnimation(e, true, this.$t('menu.signin'))
        }).catch(() => {
          this.$toast.error({message: 'username / password error.'})
          this.buttonAnimation(e, true, this.$t('menu.signin'))
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

<style scoped="">
  a.provider {
    margin: 5px;
  }
</style>
