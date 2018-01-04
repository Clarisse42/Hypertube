<template>
  <div class="white-text">
    <div class="container" style="margin-top: 100px">
      <div class="row">
          <div class="card-action sub" v-if="movies_selected && movies_selected.subtitles && torrent">
            <span>{{ $t('player.title') }}:</span>
            <span v-for="item in movies_selected.subtitles"> <flag iso="gb" v-show="item.lang === 'en'"/> <flag iso="fr" v-show="item.lang === 'fr'"/> {{ item.language }}</span>
          </div>
          <table class="striped" v-if="torrent">
            <thead>
            <tr>
              <th>{{ $t('movie.source') }}</th>
              <th>{{ $t('movie.language') }}</th>
              <th>{{ $t('movie.quality') }}</th>
              <th class="hide-on-small-only">{{ $t('movie.date_uploaded') }}</th>
              <th>{{ $t('movie.watch') }}</th>
            </tr>
            </thead>
            <tbody>
            <tr v-if="torrent" v-for="item in torrent">
              <td>
                <img src="https://yts.ag/assets/images/website/logo-YTS.svg" alt="YTS.ag" v-show="item.source === 'yts'" style="height: 25px">
                <img src="/static/popcorntime.png" alt="PopCornTime" v-show="item.source === 'popcorntime'">
              </td>
              <td>{{ item.language }}</td>
              <td>{{ item.quality }}</td>
              <td class="hide-on-small-only">{{ item.timestamp | formatDate }}</td>
              <td>
                <button class="btn-large white black-text" v-on:click="watchMovie(item)"><i class="material-icons left hide-on-small-only">play_arrow</i>{{$t('movie.watch2')}}</button>
              </td>
            </tr>
            </tbody>
          </table>
          <div v-if="!torrent" class="notorrent">
            {{ $t('movie.error') }}
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
    name: 'Home',
    data () {
      return {
        error: null,
        torrent: null,
        nocontent: null
      }
    },

    components: {
      Carousel,
      Slide
    },

    computed: {
      ...Vuex.mapGetters(['api_url', 'api_image', 'movies_selected'])
    },

    methods: {
      YoutubePath: function (path) {
        return 'https://www.youtube.com/embed/' + path
      },
      watchMovie: function (data) {
        this.$router.push({name: 'Player', params: { id: this.$store.state.movies_selected.imdb_id, torrent_id: data.torrent_id }})
      },

      searchMovie: function () {
        this.error = false
        this.nocontent = false
        axios.get(this.api_url + '/movie/torrent/' + this.$store.state.movies_selected.imdb_id).then(response => {
          if (response.status === 200) {
            this.torrent = response.data
          } else if (response.status === 204) {
            this.nocontent = true
          }
        }).catch(() => {
          this.error = true
        })
      }
    },

    created () {
      if (!this.$store.state.movies_selected) {
        this.$router.push('/')
      } else {
        this.searchMovie()
      }
    }
  }
</script>


<style>
  table {
    width: 100%;
  }

  table th, table td {
    text-align: center;
  }

  table td>img {
    height: 50px;
  }

  thead {
    border: none;
  }

  table.striped>tbody>tr:nth-child(odd) {
    background-color: rgba(0, 0, 0, 0.3);
  }

  table.striped>tbody>tr:nth-child(even) {
    background-color: rgba(0, 0, 0, 0.5);
  }

  thead th {
    background-color: rgba(0, 0, 0, 0.5) !important;
    border-radius: 0;
  }

  .sub {
    background-color: rgba(0, 0, 0, 0.5);
    padding: 10px 0px;
    text-align: center;
    width: 100%;
  }

  .notorrent {
    text-align: center;
    font-size: 20px;
    color: deeppink;
  }

</style>
