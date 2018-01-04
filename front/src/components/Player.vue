<template>
  <div class="white-text">
    <br />
    <div class="row">
      <div class="col l8 s12">


        <div class="card" style="padding: 10px; background-color: rgba(0, 0, 0, 0.3); min-height: 400px">

          <div v-if="player.data && player.data['streamUrl']">
            <video style="width: 100%" controls autoplay id="video" controlsList="nodownload">
              <source :src="player.data['streamUrl']" type="video/mp4">
              <track v-for="item in player.data['subtitles']" :label="item.language " kind="captions" :srclang="item.lang" :src="item.url" v-if="$i18n.locale === item.lang" default>
              <track v-for="item in player.data['subtitles']" :label="item.language " kind="captions" :srclang="item.lang" :src="item.url" v-if="$i18n.locale !== item.lang">
            </video>

          </div>

          <div class="fulloader transparent" :class="{danger: player.error}" v-show="!player.data || player.error">
            <div class="preloader-wrapper big active" v-show="!player.error">
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

            <p v-show="!player.error" style="margin: auto">
              {{ $t('player.message_loading') }}
            </p>

            <div class="error" v-show="player.error">
              <i class="material-icons large">error</i>
              <p>
                <h5>{{ $t('player.unable') }}</h5>
              </p>

            </div>

          </div>


        </div>


      </div>
      <div class="col l4">
        <div class="card" style="padding: 10px; background-color: rgba(0, 0, 0, 0.5); min-height: 580px">
          <div class="col s6">
            <div class="card-content" style="padding: 5px;">
              <h4 v-if="movies_selected.title">{{ movies_selected.title}}</h4>
              <p>{{ movies_selected.runtime }}min, {{ movies_selected.release_date.split('-')[0] }}</p>
              <br>
              <p v-if="movies_selected.credits && movies_selected.credits.crew.findIndex(prod) > -1">{{ $t('movie.prod') }}: {{ movies_selected.credits.crew[movies_selected.credits.crew.findIndex(prod)].name }}</p>
              <p v-if="movies_selected.credits && movies_selected.credits.crew.findIndex(real) > -1">{{ $t('movie.dir') }}: {{ movies_selected.credits.crew[movies_selected.credits.crew.findIndex(real)].name }}</p>
              <p v-if="movies_selected.credits">Casting: <span v-if="movies_selected.credits.cast[0]">{{ movies_selected.credits.cast[0].name }}, </span> <span v-if="movies_selected.credits.cast[1]">{{ movies_selected.credits.cast[1].name }}, </span> <span v-if="movies_selected.credits.cast[2]">{{ movies_selected.credits.cast[2].name }} </span></p>
              <br>
              <div class="card-action">
                <a target="_blank" v-if="movies_selected.id" :href="'https://www.themoviedb.org/movie/' + movies_selected.id">{{ $t('movie.info') }}</a>

              </div>
            </div>
            <div class="card-action">
              <p style="font-size: 25px;display: inline-block; min-width: 60px; margin: 0; padding: 0;"><i class="material-icons">star</i>
                <span v-if="movies_selected.vote_average >= 0">{{ movies_selected.vote_average }}</span>
              </p>
            </div>

            <div class="card-action" v-if="player.data && player.data.subtitles">
              <span>{{ $t('player.title') }}:</span>
              <p style="text-align: center;">
                <span v-if="!player.data.subtitles || !player.data.subtitles[0]"> {{ $t('player.nosubtitle') }} </span>
                <span v-for="item in player.data.subtitles"> <flag iso="gb" v-show="item.lang === 'en'"/> <flag iso="fr" v-show="item.lang === 'fr'"/> {{ item.language }}</span>
              </p>
            </div>
          </div>
          <div class="col s6">
            <div class="card-image">
              <img :src=posterPath(movies_selected)>
            </div>
            <br>
            <div class="card-action" style="background-color: rgba(0, 0, 0, 0);">
              <form v-on:submit.prevent="new_fav" style="text-align: center">
                <button v-if="movies_selected.fav === 0" type="submit" class="btn-floating btn-large blue-grey darken-3 white-text"><i class="material-icons left white-text">favorite_border</i> <span class="white-text">{{ $t('menu.signin') }}</span></button>
                <button v-if="movies_selected.fav === 1" type="submit" class="btn-floating btn-large blue-grey darken-3 white-text"><i class="material-icons left white-text">favorite</i> <span class="white-text">{{ $t('menu.signin') }}</span></button>
              </form>
            </div>
          </div>
          <div>
            <p v-if="movies_selected.overview">{{ movies_selected.overview }}</p>
            <p v-if="!movies_selected.overview">no overview found...</p>
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col l8 offset-l2 m12 s12">
        <div class="card" style="padding: 10px; padding-left: 30px; padding-right: 30px; background-color: rgba(0, 0, 0, 0.5);">
          <h5 style="text-align: center">{{ $t('movie.comments') }}</h5>
          <br>
          <div v-if="movies_selected.comment.length == 0">
            <h5>{{ $t('movie.first') }}</h5>
          </div>
          <form v-on:submit.prevent="new_comment">
            <input v-model="review.message" :placeholder="$t('movie.comment')" value="" id="comment" type="text" class="validate">
          </form>
          <div v-if="movies_selected.comment.length > 0">
            <ul>
              <li v-for="item in movies_selected.comment" v-if="movies_selected.users_com[item.uid].length > 0">
                <router-link v-if="movies_selected.users_com[item.uid].length > 0" :to="{ name: 'Profile', params: { username: movies_selected.users_com[item.uid][0].username }}">
                  <img :src="movies_selected.users_com[item.uid][0].picture" style="vertical-align: middle; border-radius: 50%; object-fit: cover; width: 50px; height:50px;">
                  <span style="font-size: 20px;" v-if="movies_selected.users_com[item.uid][0].provider"><strong> {{ movies_selected.users_com[item.uid][0].username.split('-')[0]}} </strong></span>
                  <span style="font-size: 20px;" v-if="!movies_selected.users_com[item.uid][0].provider"><strong> {{ movies_selected.users_com[item.uid][0].username}} </strong></span>
                </router-link>
                <p style="padding-left: 30px;">{{item.message}}</p>
              </li>
            </ul>
          </div>
        </div>
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
        player: {
          error: null,
          data: null
        },
        error: null,
        torrent_id: 0,
        torrent: null,
        nocontent: null,
        review: {
          message: '',
          movie_id: ''
        },
        fav: {
          movie_id: ''
        }
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

      viewedFilm: function (time) {
        axios.post(this.api_url + '/movies/viewed', {view: {
          'movie_id': this.$store.state.movies_selected.imdb_id,
          'torrent_id': this.torrent_id,
          'time': time
        }
        }, {headers: {'Authorization': localStorage.getItem('token')}})
      },

      sleep: function (milliseconds) {
        var start = new Date().getTime()
        for (var i = 0; i < 1e7; i++) {
          if ((new Date().getTime() - start) > milliseconds) {
            break
          }
        }
      },

      startDownload: function (url) {
        this.player.error = false
        this.nocontent = false
        axios.get(url.downloadUrl).then(response => {
          this.sleep(2000)
          this.player.data = url
          this.viewedFilm(0)
        }).catch(() => {
          this.player.error = true
        })
      },

      startPlaying: function () {
        this.player.error = false
        this.nocontent = false
        axios.get(this.api_url + '/movie/torrent/' + this.$store.state.movies_selected.imdb_id + '/playing/' + this.torrent_id, {headers: {'Authorization': localStorage.getItem('token'), 'Language': this.$i18n.locale}}).then(response => {
          if (response.data.downloadUrl) {
            this.startDownload(response.data)
          } else {
            this.player.error = true
          }
        }).catch(() => {
          this.player.error = true
        })
      },

      new_comment: function (e) {
        e.preventDefault()
        axios.post(this.api_url + '/review/create', {review: {
          'message': this.review.message,
          'movie_id': this.$store.state.movies_selected.imdb_id
        }
        }, {headers: {'Authorization': localStorage.getItem('token'), 'Language': this.$i18n.locale}}).then(response => {
          if (response.status === 201 && response.data.status) {
            this.review.message = ''
            this.movies_selected.comment = response.data.data
            this.movies_selected.users_com[this.userdata.id] = response.data.user
            this.$toast.success({message: response.data.message})
          }
          if (response.status === 202 && !response.data.status) {
            this.$toast.error({message: response.data.message})
          }
        }).catch(() => {
          this.$toast.error({message: 'An error has occured'})
        })
      },

      new_fav: function (e) {
        e.preventDefault()
        if (this.movies_selected.fav === 0) {
          axios.post(this.api_url + '/fav/create', {fav: {
            'movie_id': this.$store.state.movies_selected.imdb_id
          }
          }, {headers: {'Authorization': localStorage.getItem('token'), 'Language': this.$i18n.locale}}).then(response => {
            if (response.status === 201 && response.data.status) {
              if (response.status === 201 && response.data.status) {
                this.movies_selected.fav = 1
                this.$toast.success({message: response.data.message})
              }
              if (response.status === 204 && !response.data.status) {
                this.$toast.error({message: response.data.message})
              }
            }
          }).catch(() => {
            this.$toast.error({message: 'An error has occured'})
          })
        } else {
          axios.post(this.api_url + '/fav/delete', {fav: {
            'movie_id': this.$store.state.movies_selected.imdb_id
          }
          }, {headers: {'Authorization': localStorage.getItem('token'), 'Language': this.$i18n.locale}}).then(response => {
            if (response.status === 201 && response.data.status) {
              this.movies_selected.fav = 0
              this.$toast.success({message: response.data.message})
            }
            if (response.status === 204 && !response.data.status) {
              this.$toast.error({message: response.data.message})
            }
          }).catch(() => {
            this.$toast.error({message: 'An error has occured'})
          })
        }
      },

      prod: function (element) {
        return element.job === 'Producer'
      },

      real: function (element) {
        return element.job === 'Director'
      }

    },

    beforeDestroy () {
      var video = false
      if ((video = document.getElementById('video')) && this.player.data) {
        this.viewedFilm(video.currentTime)
        video.remove()
      }
    },

    created () {
      this.player.data = null
      this.player.error = null
      this.torrent_id = this.$route.params['torrent_id']
      this.startPlaying()
    }
  }

</script>

<style>

  video {
    background: transparent url(/static/ajax-loader.gif) center center no-repeat;
    background-size: 50px;
  }
</style>
