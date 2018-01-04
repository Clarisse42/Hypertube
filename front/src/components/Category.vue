<template>

  <div class="white-text">
    <div class="fulloader" v-show="error || data === null" v-bind:class="{ danger: error }">
      <div class="preloader-wrapper big active" v-show="data === null && !error">
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

        <button class="btn-large white black-text" v-on:click="getAllMovies(key)"><i class="material-icons left">refresh</i> refresh</button>
      </div>
    </div>


    <div class="white-text" v-if="data">

      <nav class="blue-grey darken-4">
        <div class="nav-wrapper">
          <div class="col s12">
            <a href="" class="breadcrumb" style="font-size: 25px; margin-left: 20px;">{{ $t(title) }}</a>
          </div>
        </div>
      </nav>


        <div v-for="item in data" :key="item.id" :style="{ 'background-image': 'url(' + item.cover + '), url(http://www.matchhighlight.com/wp-content/themes/watchzaa/images/no-image-landscape.png)' }" class="VueCarousel-slide slideBox">

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
        </div>

        <infinite-loading @infinite="infiniteHandler"></infinite-loading>

      </div>



  </div>
</template>


<script type="text/babel">
  import Socket from './Socket.js'
  import axios from 'axios'
  import Vuex from 'vuex'
  import InfiniteLoading from 'vue-infinite-loading'

  export default {
    store: Socket,
    name: 'Category',
    data () {
      return {
        data: null,
        error: null,
        title: null
      }
    },

    components: {
      InfiniteLoading
    },

    computed: {
      ...Vuex.mapGetters(['api_url', 'api_image'])
    },

    methods: {
      posterPath: function (path) {
        return this.api_image + path
      },

      infiniteHandler: function ($state) {
        this.getAllMovies((this.data.length / 30) + 1, $state)
      },

      getAllMovies: function (count, state = false) {
        this.error = false
        axios.get(this.api_url + '/movies/' + this.title + '/' + count, {headers: {'Authorization': localStorage.getItem('token'), 'Language': this.$i18n.locale}}).then(response => {
          if (response.status === 200) {
            if (this.data) {
              this.data = this.data.concat(response.data)
            } else {
              this.data = response.data
            }
          }
          if (state) {
            state.loaded()
          }
        }).catch(() => {
          this.error = true
          console.log('Bad request')
          if (state) {
            state.loaded()
          }
        })
      }
    },

    mounted () {
      this.title = this.$route.params.name
      this.getAllMovies(0)
    }
  }
</script>


<style scoped="">
  .slideBox {
    width: calc(100% / 6);
    float: left;
  }

  /* Medium screen */
  @media screen and (max-width: 1350px) {
    .slideBox {
      width: calc(100% / 4);
      float: left;
    }
  }

  /* large screen */
  @media screen and (max-width: 1700px)  and (min-width: 1350px) {
    .slideBox {
      width: calc(100% / 5);
      float: left;
    }
  }
  @media screen and (min-width: 1800px) {
    .slideBox {
      width: calc(100% / 6);
      float: left;
    }
  }

  @media screen and (max-width: 900px) {
    .slideBox {
      width: calc(100% / 3);
      float: left;
    }
  }

  @media screen and (max-width: 800px) {
    .slideBox {
      width: calc(100% / 2);
      float: left;
    }
  }

  @media screen and (max-width: 600px) {
    .slideBox {
      width: calc(100% / 1);
      float: left;
    }
  }
</style>
