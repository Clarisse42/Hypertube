<template>
  <div>

    <div class="navbar-fixed">
      <nav class="blue-grey darken-2">
        <div class="container">
          <div class="nav-wrapper">
            <router-link to="/" class="brand-logo">Hypertube</router-link>
            <a data-activates="mobile-demo" class="button-collapse"><i class="material-icons">menu</i></a>
            <ul class="right hide-on-med-and-down">
              <li class="right" v-if="!userdata">
                <router-link to="/signup">{{ $t('menu.signup') }}</router-link>
              </li>
              <li class="right border" v-if="!userdata">
                <router-link to="/signin">{{ $t('menu.signin') }}</router-link>
              </li>
              <li class="center-align" style="text-align: center;">

                  <span class="language" :class="{'active' : $i18n.locale === 'fr'}" v-on:click="changeLocale('fr')">FR</span>
                  <span class="language" :class="{'active' : $i18n.locale === 'en'}" v-on:click="changeLocale('en')">EN</span>

              </li>
              <li v-if="userdata">
                <router-link to="/search">
                  <i class="material-icons left">search</i>
                  {{ $t('menu.search') }}
                </router-link>
              </li>

              <li v-if="userdata"><router-link :to="{ name: 'Profile', params: { username: userdata.username }}">{{ $t('menu.profile') }}</router-link></li>
              <li v-if="userdata"><router-link to="/settings">{{ $t('menu.settings') }}</router-link></li>
              <li v-if="userdata"><a v-on:click="logout" href="#">{{ $t('menu.logout') }}</a></li>
            </ul>

            <ul class="side-nav" id="mobile-demo">
              <li v-if="!userdata">
                <router-link to="/signup">{{ $t('menu.signup') }}</router-link>
              </li>
              <li v-if="!userdata">
                <router-link to="/signin">{{ $t('menu.signin') }}</router-link>
              </li>
              <li>
                <a href="#" class="no-hover">
                  <span class="language" :class="{'active' : $i18n.locale === 'fr'}" v-on:click="changeLocale('fr')">FR</span>
                  <span class="language" :class="{'active' : $i18n.locale === 'en'}" v-on:click="changeLocale('en')">EN</span>
                </a>
              </li>
              <li v-if="userdata">
                <router-link to="/search">
                  <i class="material-icons left">search</i>
                  {{ $t('menu.search') }}
                </router-link>
              </li>
              <li v-if="userdata" class="divider"></li>
              <li v-if="userdata"><router-link :to="{ name: 'Profile', params: { username: userdata.username }}">{{ $t('menu.profile') }}</router-link></li>
              <li v-if="userdata"><router-link to="/settings">{{ $t('menu.settings') }}</router-link></li>
              <li v-if="userdata" class="divider"></li>
              <li v-if="userdata"><a v-on:click="logout" href="#">{{ $t('menu.logout') }}</a></li>
            </ul>
          </div>
        </div>
      </nav>
    </div>

    <div class="body">
      <div class="fulloader error white-text" v-if="$route.meta.signin && !userdata">

        <div class="error">
          <i class="material-icons large">lock_outline</i>
          <p>
          <h5>{{ $t('action.only_signed_in') }}</h5>
          </p>
        </div>
      </div>


      <transition name="custom-classes-transition" enter-active-class="animated fadeIn">
        <keep-alive>
          <router-view v-if="viewRouter($route.meta) && $route.meta.keepAlive"></router-view>
        </keep-alive>
      </transition>

      <transition name="custom-classes-transition" enter-active-class="animated fadeIn">
        <router-view v-if="viewRouter($route.meta) && !$route.meta.keepAlive"></router-view>
      </transition>
    </div>


    <footer class="page-footer">
          <div style="text-align: center">
            <p class="white-text">{{ $t('menu.footer') }} Avideau, Ccharuel, Arumpler et Aaleksov</p>
          </div>
      <div class="footer-copyright">
        <div class="container" style="text-align: center">
          © 2017 Copyright
        </div>
      </div>
    </footer>


  </div>
</template>


<script type="text/babel">
  import Socket from './Socket.js'
  import Vuex from 'vuex'
  import axios from 'axios'
  import $ from 'jquery'

  export default {
    store: Socket,
    name: 'NavBar',
    data () {
      return {
        menu: false
      }
    },

    computed: {
      ...Vuex.mapGetters(['api_url', 'userdata'])
    },

    methods: {
      ...Vuex.mapActions(['change_locale', 'saveUser']),

      viewRouter: function (meta) {
        if (!meta.signin) {
          return true
        } else if (meta.signin && this.userdata) {
          return true
        } else {
          return false
        }
      },

      auth: function () {
        axios.get(this.api_url + '/sessions', {headers: {'Authorization': localStorage.getItem('token')}}).then(response => {
          if (response.data.status) {
            this.saveUser(response.data.user)
            this.changeLocale(response.data.user.language)
          }
        }).catch(() => {
          console.log('bad request')
        })
      },

      changeLocale: function (lang) {
        if (lang === 'fr' || lang === 'en') {
          this.$i18n.locale = lang
        } else {
          this.$i18n.locale = 'en'
        }
        if (this.userdata) {
          this.change_locale(this.$i18n.locale)
        }
      },

      logout: function () {
        axios.get(this.api_url + '/sessions/remove', {headers: {'Authorization': localStorage.getItem('token'), 'Language': this.$i18n.locale}}).then(response => {
        })
        localStorage.removeItem('token')
        this.$router.push('/')
        this.saveUser(null)
      }
    },

    mounted () {
      this.auth()
      $('.button-collapse').sideNav({
        menuWidth: 300
      })
    }
  }
</script>


<style>
  .dropdown-content li>a, .dropdown-content li>span {
    color: black;
  }
  #sidenav-overlay {
    z-index: 9 !important;
  }

  .language {
    padding: 0px 5px;
    transition: all 1s;
    font-size: 14px;
    cursor: pointer;
  }
  .language:hover {
    color: #0277bd;
  }
  .language.active {
    font-size: 18px;
  }
  .language.active:hover {
    color: white;
  }

  .body {
    overflow: hidden;
    min-height: 600px;
  }

  .page-footer {
    background: rgba(0, 0, 0, 0.5);
    margin-top: 20px;
  }

</style>

