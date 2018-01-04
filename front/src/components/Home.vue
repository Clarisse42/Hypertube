<template>
    <div class="white-text">

      <div v-for="(localdata, key) in data">
        <div v-if="localdata.view">
          <nav class="blue-grey darken-4">
            <div class="nav-wrapper">
              <div class="col s12">
                <a href="" class="breadcrumb" style="font-size: 25px; margin-left: 20px;">{{ $t(key) }}</a>
              </div>
            </div>
          </nav>

          <div class="carousel_loading" v-show="localdata.error || localdata.data === null" v-bind:class="{ danger: localdata.error }">
            <div class="preloader-wrapper big active" v-show="localdata.data === null && !localdata.error">
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

            <div class="error" v-show="localdata.error">
              <i class="material-icons large">error</i>
              <p>
              <h5>An error occurred while retrieving movies</h5>
              </p>

              <button class="btn-large white black-text" v-on:click="getAllMovies(key)"><i class="material-icons left">refresh</i> refresh</button>
            </div>
          </div>

          <carousel :paginationEnabled="false" :navigationEnabled="true" :autoplay="false" :perPageCustom="[[300, 1], [480, 2], [768, 3], [900, 4], [1500, 5], [1800, 6]]" v-if="!(localdata.error || !localdata.data)">

            <slide v-for="item in localdata.data" :key="item.id" :style="{ 'background-image': 'url(' + item.cover + '), url(http://www.matchhighlight.com/wp-content/themes/watchzaa/images/no-image-landscape.png)' }">

              <div class="slideInfo">
                <router-link :to="{ name: 'Search', params: { id: item.imdb_id }}" class="btn-large white black-text"><i class="material-icons left">play_arrow</i> {{ $t('action.watch') }}</router-link>
              </div>
              <div class="slideTitle">
                <h5>{{ item.title }}</h5>
              </div>

              <div class="viewed" v-show="item['userviewed?']">
                <i class="material-icons blue-text">access_time</i>
                <span>

                </span>
              </div>

              <div class="year">
                <i class="material-icons red-text">date_range</i> <span>{{ item.year }}</span>
              </div>
              <div class="rating">
                <i class="material-icons yellow-text">star_half</i> <span>{{ item.rating }}</span>
              </div>
            </slide>

            <slide class="grey lighten-3 black-text seemore" v-if="key != 'resume' && key != 'favs'">
              <div v-on:click="openCategory(key)">
                <i class="large material-icons">zoom_in</i>
                <h5>see more</h5>
              </div>
            </slide>

          </carousel>
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
    name: 'Home',
    data () {
      return {
        data: {
          'news': {
            data: null,
            error: null,
            title: 'New movies',
            view: true
          },
          'top_rated': {
            data: null,
            error: null,
            title: 'Top Rated',
            view: true
          },
          'resume': {
            data: null,
            error: null,
            title: 'Resume with your profile',
            view: false
          },
          'favs': {
            data: null,
            error: null,
            title: 'Resume with your profile',
            view: false
          }
        }
      }
    },

    components: {
      Carousel,
      Slide
    },

    computed: {
      ...Vuex.mapGetters(['api_url', 'api_image', 'userdata'])
    },

    methods: {
      posterPath: function (path) {
        return this.api_image + path
      },

      openCategory: function (cat) {
        this.$router.push({name: 'Category', params: {name: cat}})
      },

      getAllMovies: function (type) {
        this.data[type].error = false
        axios.get(this.api_url + '/movies/' + type, {headers: {'Authorization': localStorage.getItem('token'), 'Language': this.$i18n.locale}}).then(response => {
          if (response.status === 200) {
            this.data[type].view = true
            this.data[type].data = response.data
          }
        }).catch((e) => {
          this.data[type].error = true
          console.log('Bad request')
        })
      }
    },

    mounted () {
      this.getAllMovies('news')
      this.getAllMovies('top_rated')

      if (this.userdata && !this.data['resume'].view) {
        this.getAllMovies('resume')
      }

      if (this.userdata && !this.data['favs'].view) {
        this.getAllMovies('favs')
      }
    }
  }
</script>

