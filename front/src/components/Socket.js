import Vue from 'vue'
import Vuex from 'vuex'
import axios from 'axios'

Vue.use(Vuex)
export default new Vuex.Store({
  state: {
    api_url: 'http://' + window.location.hostname + ':8999/api/rest',
    api_image: 'http://image.tmdb.org/t/p/w1280/',
    userdata: null,
    locale: 'en',
    movies_selected: null
  },

  getters: {
    locale: state => state.locale,
    api_url: state => state.api_url,
    api_image: state => state.api_image,
    userdata: state => state.userdata,
    movies_selected: state => state.movies_selected
  },

  mutations: {
    CHANGE_LOCALE: (state, type) => {
      axios.put(state.api_url + '/users/language', {user: {
        'language': type
      }
      }, {headers: {'Authorization': localStorage.getItem('token')}})
    },

    UPDATE_MOVIES: (state, data) => {
      state.movies_selected = data
    },

    SAVE_USER: (state, data) => {
      state.userdata = data
    }
  },

  actions: {
    change_locale: (context, type) => {
      context.commit('CHANGE_LOCALE', type)
      return true
    },

    saveUser: (context, data) => {
      context.commit('SAVE_USER', data)
    },

    update_Movies: (context, data) => {
      context.commit('UPDATE_MOVIES', data)
    },

    posterpath: (context, type) => {
      return 'https://image.tmdb.org/t/p/w640/' + type
    }
  }
})
