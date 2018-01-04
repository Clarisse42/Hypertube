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
              <li class="tab col s6"><router-link to="/signin">{{ $t('menu.signin') }}</router-link></li>
              <li class="tab col s6"><router-link to="/signup" class="active">{{ $t('menu.signup') }}</router-link></li>
            </div>
          </div>
          <div class="card-content grey lighten-4">
            <div class="row">

              <form v-on:submit.prevent="register">

                <transition name="custom-classes-transition" enter-active-class="animated fadeIn" leave-active-class="animated fadeOut">
                  <ul class="errors_form" v-if="user.errors">
                    <li v-for="(item, key) in user.errors">{{ item[0] }}</li>
                  </ul>
                </transition>

                <div class="input-field inline col s12">
                  <input id="username" v-model="user.username" type="text">
                  <label for="username" class="active">{{ $t('signup.username') }}</label>
                </div>

                <div class="input-field inline col s12">
                  <input id="email" v-model="user.email" type="email">
                  <label for="email" class="active">{{ $t('signup.email') }}</label>
                </div>

                <div class="input-field col s12">
                  <input id="firstname" v-model="user.firstname" type="text">
                  <label for="firstname" class="active">{{ $t('signup.firstname') }}</label>
                </div>

                <div class="input-field col s12">
                  <input id="lastname" v-model="user.lastname" type="text">
                  <label for="lastname" class="active">{{ $t('signup.lastname') }}</label>
                </div>

                <div class="input-field col s12">
                  <input id="password" v-model="user.password" type="password">
                  <label for="password" class="active">{{ $t('signup.password') }}</label>
                </div>

                <div class="input-field col s12">
                  <input id="password_confirmation" v-model="user.password_confirmation" type="password">
                  <label for="password_confirmation" class="active">{{ $t('signup.password_confirmation') }}</label>
                </div>

                <div class="input-field col s12 file-field ">
                  <div class="btn">
                    <input type="file" id="file" accept="image/x-png,image/gif,image/jpeg">
                    <span>{{ $t('signup.picture') }}</span>
                  </div>
                  <div class="file-path-wrapper">
                    <input class="file-path validate" type="text">
                  </div>
                </div>

                <div class="input-field col s12 right-align">
                  <button type="submit" class="btn-large blue-grey darken-3 white-text"><i class="material-icons left white-text">send</i> <span class="white-text">{{ $t('menu.signup') }}</span></button>
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
  <!--</div>-->
</template>


<script type="text/babel">
  import Socket from './Socket.js'
  import Vuex from 'vuex'
  import axios from 'axios'

  export default {
    store: Socket,
    name: 'Resiter',
    data () {
      return {
        user: {
          username: '',
          email: '',
          firstname: '',
          lastname: '',
          password: '',
          password_confirmation: '',
          errors: false
        }
      }
    },

//    beforeCreate: function () {
//      this.$options.components.bDedicaces = require('./Dedicaces.vue')
//    },

    computed: {
      ...Vuex.mapGetters(['api_url', 'api_image'])
    },

    methods: {
      ...Vuex.mapActions(['change_locale', 'saveUser']),

      register: function (e) {
        e.preventDefault()
        this.buttonAnimation(e, false, this.$t('menu.signup'))
        this.user.errors = false

        var formData = new FormData()
        formData.append('picture_file', document.getElementById('file').files[0])
        formData.append('username', this.user.username)
        formData.append('email', this.user.email)
        formData.append('firstname', this.user.firstname)
        formData.append('lastname', this.user.lastname)
        formData.append('password', this.user.password)
        formData.append('password_confirmation', this.user.password_confirmation)

        axios.post(this.api_url + '/users/create', formData, {headers: {'Language': this.$i18n.locale}}).then(response => {
          if (response.status === 201 && response.data.status) {
            this.$toast.success({message: response.data.message})
            this.$router.push('/signin')
          }

          if (response.status === 202 && !response.data.status) {
            this.user.errors = response.data.errors
          }
          this.buttonAnimation(e, true, this.$t('menu.signup'))
        }).catch(() => {
          this.$toast.error({message: 'An error has occured'})
          this.buttonAnimation(e, true, this.$t('menu.signup'))
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

<style scoped="">
  a.provider {
    margin: 5px;
  }
</style>
