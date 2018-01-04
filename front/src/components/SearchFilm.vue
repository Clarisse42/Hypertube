<template>
  <div class="white-text">
    </br>
    <div class="row">
      <form class="col s12"  v-on:submit.prevent="new_search" style="background-color: rgba(0, 0, 0, 0.5);">
        <div class="input-field col l3">
          <input v-model="search.movie_name" :placeholder="$t('search.name_movie')" id="movie_name" type="text" class="validate">
        </div>
        <div class="input-field col l2">
          <select>
            <option selected value="">{{$t('search.min_note')}}</option>
            <option v-for="option in optionsss" v-bind:value="option.value">
              {{ option.text }}
            </option>
          </select>
        </div>
        <div class="input-field col l2">
          <select v-model="selected">
            <option value="">{{$t('search.kind')}}</option>
            <option v-for="option in options" v-bind:value="option.value">
              {{ option.text }}
            </option>
          </select>
        </div>
        <div class="input-field col l2">
          <select v-model="selected">
            <option selected value="">{{$t('search.year')}}</option>
            <option v-for="option in demo" v-bind:value="option.value">
              {{ option }}
            </option>
          </select>
        </div>
        <div class="input-field col l2">
          <select v-model="selected">
            <option value="">{{$t('search.order_by')}}</option>
            <option v-for="option in tri" v-bind:value="option.value">
              {{ option }}
            </option>
          </select>
        </div>
        <div class="col l1" style="padding-top: 10px;">
          <button type="submit" class="btn-large transparent white-text"><i class="material-icons left white-text small">search</i></button>
        </div>
      </form>
    </div>

    <div class="white-text" v-if="data">

      <nav class="blue-grey darken-4">
        <div class="nav-wrapper">
          <div class="col s12">
            <a href="" class="breadcrumb" style="font-size: 25px; margin-left: 20px;">{{ $t(title) }}</a>
          </div>
        </div>
      </nav>


      <div v-for="item in data" :key="item.id" :style="{ 'background-image': 'url(' + poster(item.poster) + '), url(http://www.matchhighlight.com/wp-content/themes/watchzaa/images/no-image-landscape.png)' }" class="VueCarousel-slide slideBox">

        <div class="slideInfo">
          <a v-on:click="findId(item.id)" class="btn-large white black-text"><i class="material-icons left">play_arrow</i> {{ $t('action.watch') }}</a>
        </div>
        <div class="slideTitle">
          <h5>{{ item.title }}</h5>
        </div>

        <div class="viewed" v-show="item['userviewed?']">
          <i class="material-icons blue-text">access_time</i>
          <span>
                  {{ item['userviewed?'] }} mins
                </span>
        </div>

        <div class="year">
          <i class="material-icons red-text">date_range</i> <span>{{ item.release_date.split('-')[0] }}</span>
        </div>
        <div class="rating">
          <i class="material-icons yellow-text">star_half</i> <span>{{ item.rating }}</span>
        </div>
      </div>

    </div>


  </div>


</template>


<script type="text/babel">

  import Socket from './Socket.js'
  import axios from 'axios'
  import Vuex from 'vuex'
  import $ from 'jquery'
  import latinize from 'latinize'

  export default {
    store: Socket,
    name: 'SearchFilm',
    data () {
      return {
        test: 0,
        selected: 2014,
        options2: ['Action', 28, 'Adventure', 'Animation', 16, 'Comedy', 35, 'Crime', 80,
          'Documentary', 99, 'Drama', 18, 'Family', 10751, 'Fantasy', 14, 'History', 36,
          'Horror', 27, 'Music', 10402, 'Mystery', 9648, 'Romance', 10749, 'Science Fiction', 878,
          'TV Movies', 1070, 'Thriller', 53, 'War', 10752, 'West', 37],
        options: [
          { text: 'Action', value: 28 },
          { text: 'Adventure', value: 12 },
          { text: 'Animation', value: 16 },
          { text: 'Comedy', value: 35 },
          { text: 'Crime', value: 80 },
          { text: 'Documentary', value: 99 },
          { text: 'Drama', value: 18 },
          { text: 'Family', value: 10751 },
          { text: 'Fantasy', value: 14 },
          { text: 'History', value: 36 },
          { text: 'Horror', value: 27 },
          { text: 'Music', value: 10402 },
          { text: 'Mystery', value: 9648 },
          { text: 'Romance', value: 10749 },
          { text: 'Science Fiction', value: 878 },
          { text: 'TV Movies', value: 1070 },
          { text: 'Thriller', value: 53 },
          { text: 'War', value: 10752 },
          { text: 'West', value: 37 }
        ],
        demo: [2017, 2016, 2015, 2014, 2013, 2012, 2011, 2010, 2009, 2008, 2007, 2006, 2005, 2004, 2003, 2002, 2001, 2000, 1999, 1998, 1997, 1996, 1995, 1994, 1993, 1992, 1991, 1990, 1989, 1988, 1987, 1986, 1985, 1984, 1983, 1982, 1981, 1980, 1979, 1978, 1977, 1976, 1975, 1974, 1973, 1972, 1971, 1970, 1969, 1968, 1967, 1966, 1965, 1964, 1963, 1962, 1961, 1960, 1959, 1958, 1957, 1956, 1955, 1954, 1953, 1952, 1951, 1950, 1949, 1948, 1947, 1946, 1945, 1944, 1943, 1942, 1941, 1940, 1939, 1938, 1937, 1936, 1935, 1934, 1933, 1932, 1931, 1930, 1929, 1928, 1927, 1926, 1925, 1924, 1923, 1922, 1921, 1920, 1919, 1918, 1917, 1916, 1915, 1914, 1913, 1912, 1911, 1910, 1909, 1908, 1907, 1906, 1905, 1904, 1903, 1902, 1901, 1900],
        optionsss: [
          { text: 9 }, { text: 8 }, { text: 7 }, { text: 6 }, { text: 5 }, { text: 4 }, { text: 3 }, { text: 2 }, { text: 1 }, { text: 0 }
        ],
        tri: ['year ↑', 'year ↓', 'rating', 'name ↑', 'name ↓'],
        search: {
          movie_name: '',
          rating: 0,
          type: '',
          type_id: 0,
          date: 0,
          sort: ''
        },
        data: null,
        error: null,
        title: null,
        torrent: null,
        nocontent: null
      }
    },

    computed: {
      ...Vuex.mapGetters(['api_url', 'api_image', 'movies_selected'])
    },
    mounted () {
      this.title = this.$route.params.name
      $('select').material_select()
    },

    methods: {
      ...Vuex.mapActions(['update_Movies']),
      findId: function (idDb) {
        axios.get(this.api_url + '/movie_id/' + idDb, {
          headers: {
            'Authorization': sessionStorage.getItem('token'),
            'Language': this.$i18n.locale
          }
        }).then(response => {
          if (response.status === 200 && response.data[0] && response.data[0].id) {
            this.$router.push({name: 'Search', params: { id: response.data[0].id }})
          } else {
            this.$toast.error({message: 'Error / Erreur'})
          }
        }).catch(() => {
          this.$toast.error({message: 'Error / Erreur'})
          console.log('Bad request')
        })
      },

      poster: function (poster) {
        if (poster) {
          return 'http://image.tmdb.org/t/p/w342/' + poster
        } else {
          return 'http://www.matchhighlight.com/wp-content/themes/watchzaa/images/no-image-landscape.png'
        }
      },

      sortResult: function (param) {
        if (param === 'year ↑') {
          this.data.sort(function (a, b) {
            if (parseInt(a['release_date'].split('-')[0]) < parseInt(b['release_date'].split('-')[0])) {
              return -1
            }
            return 1
          })
        } else if (param === 'year ↓') {
          this.data.sort(function (a, b) {
            if (parseInt(a['release_date'].split('-')[0]) > parseInt(b['release_date'].split('-')[0])) {
              return -1
            }
            return 1
          })
        } else if (param === 'rating') {
          this.data.sort(function (a, b) {
            if (parseFloat(a['rating']) > parseFloat(b['rating'])) {
              return -1
            }
            return 1
          })
        } else if (param === 'name ↑') {
          this.data.sort(function (a, b) {
            if (a['title'] < b['title']) {
              return -1
            }
            return 1
          })
        } else if (param === 'name ↓') {
          this.data.sort(function (a, b) {
            if (a['title'] > b['title']) {
              return -1
            }
            return 1
          })
        }
      },
      new_search: function (e) {
        e.preventDefault()

        if (!this.search.movie_name) {
          this.$toast.error({message: 'please search something'})
        } else {
          if ($('.select-wrapper:eq(0) .dropdown-content .active')[0]) {
            this.search.rating = $('.select-wrapper:eq(0) .dropdown-content .active')[0].innerText.trim()
          }
          if ($('.select-wrapper:eq(1) .dropdown-content .active')[0]) {
            this.search.type = $('.select-wrapper:eq(1) .dropdown-content .active')[0].innerText.trim()
            this.search.type_id = this.options2[this.options2.indexOf(this.search.type) + 1]
          }
          if ($('.select-wrapper:eq(2) .dropdown-content .active')[0]) {
            this.search.date = $('.select-wrapper:eq(2) .dropdown-content .active')[0].innerText.trim()
            if (this.search.date === 'année' || this.search.date === 'year') {
              this.search.date = 0
            }
          }
          this.error = false
          axios.get(this.api_url + '/movie_name/' + latinize(this.search.movie_name) + '/' + this.search.date + '/' + this.search.type_id + '/' + this.search.rating, {
            headers: {
              'Authorization': sessionStorage.getItem('token'),
              'Language': this.$i18n.locale
            }
          }).then(response => {
            if (response.status === 200) {
              this.data = response.data
              if ($('.select-wrapper:eq(3) .dropdown-content .active')[0]) {
                this.search.sort = $('.select-wrapper:eq(3) .dropdown-content .active')[0].innerText.trim()
                this.sortResult(this.search.sort)
              } else {
                this.sortResult('name ↑')
              }
            } else if (response.status === 400) {
              this.$toast.error({message: response.data.message})
            } else if (response.status === 204) {
              this.data = null
              this.$toast.error({message: 'no result'})
            }
          }).catch(() => {
            this.error = true
            console.log('Bad request')
          })
        }
      }
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
