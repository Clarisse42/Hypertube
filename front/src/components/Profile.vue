<template>
  <div class="white-text row black" v-if="data">


    <div class="row">
      <div class="col s12 m12 l8" style="padding: 0">
        <nav class="blue-grey darken-4">
          <div class="nav-wrapper">
            <div class="col s12">
              <a href="" class="breadcrumb" style="font-size: 25px; margin-left: 20px;">{{ $t('movie.fav2') }}</a>
            </div>
          </div>
        </nav>

        <carousel :paginationEnabled="false" :navigationEnabled="true" :autoplay="false" :perPageCustom="[[300, 1], [480, 2], [768, 3], [900, 4], [1500, 5], [1800, 6]]" class="carouselProfile">
          <slide  v-for="item in fav" :style="{ 'background-image': 'url(' + posterPath(item) + ')' }" :key="item.id">
            <div class="slideInfo">
              <router-link :to="{ name: 'Search', params: { id: item.imdb_id }}" class="btn-large white black-text"><i class="material-icons left">play_arrow</i> {{ $t('action.watch') }}</router-link>
            </div>
            <div class="slideTitle"><h5>{{ item.title }}</h5></div>
          </slide>
        </carousel>


        <nav class="blue-grey darken-4">
          <div class="nav-wrapper">
            <div class="col s12">
              <a href="" class="breadcrumb" style="font-size: 25px; margin-left: 20px;">{{ $t('movie.viewed') }}</a>
            </div>
          </div>
        </nav>

        <carousel :paginationEnabled="false" :navigationEnabled="true" :autoplay="false" :perPageCustom="[[300, 1], [480, 2], [768, 3], [900, 4], [1500, 5], [1800, 6]]" class="carouselProfile">
          <slide  v-for="item in viewedfilm" :style="{ 'background-image': 'url(' + posterPath(item) + ')' }" :key="item.id">
            <div class="slideInfo"><router-link :to="{ name: 'Search', params: { id: item.imdb_id }}" class="btn-large white black-text"><i class="material-icons left">play_arrow</i> {{ $t('action.watch') }}</router-link></div>
            <div class="slideTitle"><h5>{{ item.title }}</h5></div>
          </slide>
      </carousel>


      </div>
      <div class="col s12 m12 l4">
        <div class="card-panel blue-grey darken-3 lighten-5 z-depth-1">
          <div class="row valign-wrapper">
            <div class="col s12" style="text-align: center;">
              <img :src="data.picture" class="responsive-img">

            </div>
          </div>
          <div  style="text-align:center;" class="col s12">
               {{ $route.params.username }}
          </div>
        </div>

        <div id="info-user" class="col s12 card-panel blue-grey darken-3 z-depth-1 lighten-5">{{ data.firstname }}</div>
        <div id="info-user" class="col s12 card-panel blue-grey darken-3 z-depth-1 lighten-5">{{ data.lastname }}</div>
        <div v-if="last_connection" id="info-user" class="col s12 card-panel blue-grey darken-3 z-depth-1 lighten-5"> {{ $t('last_connexion') }} {{ last_connection[0] | formatDate }}</div>

      </div>
    </div>

  </div>
</template>

<script type="text/babel">
  import Socket from './Socket.js'
  import axios from 'axios'
  import Vuex from 'vuex'
  import { Carousel, Slide } from 'vue-carousel'

  export default {
    store: Socket,
    name: 'Player',
    data () {
      return {
        data: '',
        review: '',
        viewedfilm: [],
        last_connection: '',
        fav: []
      }
    },

    components: {
      Carousel,
      Slide
    },

    computed: {
      ...Vuex.mapGetters(['api_url', 'api_image', 'movies_selected', 'userdata'])
    },

    methods: {

      posterPath: function (path) {
        if (path.poster_path) {
          return this.api_image + path.poster_path
        } else if (path.backdrop_path) {
          return this.api_image + path.backdrop_path
        } else {
          return false
        }
      },

      searchUser: function () {
        axios.get(this.api_url + '/profile/' + this.$route.params.username, {headers: {'Authorization': localStorage.getItem('token'), 'Language': this.$i18n.locale}}).then(response => {
          this.data = response.data.data

          if (response.data.data.last_connection) {
            this.last_connection = response.data.data.last_connection.split('.00')
          }
          if (response.data.viewedfilm) {
            for (var x = 0; x < response.data.viewedfilm.length; x++) {
              this.searchMovie2(response.data.viewedfilm[x].movie_id)
            }
          }

          if (response.data.fav) {
            for (var i = 0; i < response.data.fav.length; i++) {
              this.searchMovie(response.data.fav[i].movie_id)
            }
          }
        }).catch(() => {
          this.$router.push('/')
        })
      },

      searchMovie: function (id) {
        this.error = false
        axios.get(this.api_url + '/movie/imdb/' + id, {headers: {'Authorization': localStorage.getItem('token'), 'Language': this.$i18n.locale}}).then(response => {
          if (response.status === 200) {
            this.fav.push(response.data)
            response.data.vote_average = -1
            this.update_Movies(response.data)
          }
        }).catch(() => {
          this.error = true
        })
      },

      searchMovie2: function (id) {
        this.error = false
        axios.get(this.api_url + '/movie/imdb/' + id, {headers: {'Authorization': localStorage.getItem('token'), 'Language': this.$i18n.locale}}).then(response => {
          if (response.status === 200) {
            this.viewedfilm.push(response.data)
            response.data.vote_average = -1
            this.update_Movies(response.data)
          }
        }).catch(() => {
          this.error = true
        })
      }
    },

    created () {
      this.searchUser()
    }
  }

</script>

<style type="text/css">
  #title-fav{
    text-align:left;
    font-size:30px;
  }
  #info-user{
    font-size:30px;
  }
  #aff{
    position: relative;
    bottom: 900px;
  }
  #poster{
    width: 100%;
    height: 100%;
  }

  .carouselProfile {
    min-height: 500px;
  }

</style>

<style type="text/css" scoped="">
  .responsive-img {
    max-height: 250px;
  }
</style>
