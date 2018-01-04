<template>
  <div class="white-text">
    <div class="fulloader" v-show="error || !movies_selected || movies_selected.status === false" :class="{danger: error}">
      <div class="preloader-wrapper big active" v-show="!error">
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
      <div class="error" v-show="error">
        <i class="material-icons large">error</i>
        <p>
        <h5>An error occurred while retrieving movies</h5>
        </p>
        <button class="btn-large white black-text" v-on:click="searchMovie()"><i class="material-icons left">refresh</i> refresh</button>
      </div>
    </div>
    <div v-if="movies_selected">
      <div class="background" :style="{ 'background-image': 'url(' + posterPath(movies_selected) + ')' }"></div>
      <nav class="transparent">
        <div class="nav-wrapper">
          <div class="col s12">
          <a v-on:click="goBack()" id="button-back" class="btn-floating btn-large waves-effect waves-light blue-grey darken-2"><i class="material-icons">arrow_back</i></a>
            <span style="font-size: 25px; margin-left: 20px;">{{ movies_selected.title }}</span>
          </div>
        </div>
      </nav>


      <transition name="custom-classes-transition" enter-active-class="animated slideInLeft" v-if="userdata">
        <router-view></router-view>
      </transition>

      <div v-if="!userdata">
        connexion obligatoire
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
    name: 'MoviesBack',
    data () {
      return {
        error: null
      }
    },
    computed: {
      ...Vuex.mapGetters(['api_url', 'api_image', 'movies_selected', 'userdata'])
    },
    methods: {
      ...Vuex.mapActions(['update_Movies']),
      posterPath: function (path) {
        if (path.backdrop_path) {
          return this.api_image + path.backdrop_path
        } else if (path.poster_path) {
          return this.api_image + path.poster_path
        } else {
          return false
        }
      },

      goBack: function () {
        this.$router.go(-1)
      },

      searchMovie: function () {
        this.error = false
        axios.get(this.api_url + '/movie/imdb/' + this.$route.params.id, {headers: {'Authorization': localStorage.getItem('token'), 'Language': this.$i18n.locale}}).then(response => {
          if (response.status === 200) {
            this.update_Movies(response.data)
          }
        }).catch((result) => {
          this.error = true
        })
      }
    },

    mounted () {
      this.update_Movies(null)
      if (this.userdata) {
        this.searchMovie()
      } else {
        this.$router.push('/')
      }
    },

    created () {
    }
  }
</script>

<style scoped="">
  .background {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: black;
    background-position: center;
    background-size: cover;
    background-repeat: no-repeat;
    filter: blur(10px);
    z-index: -1;
  }
  #button-back{
    margin-left:10px;
    margin-bottom:6px; 
  }
  #icon{
    position: relative;
    top: -40%;

  }
</style>
