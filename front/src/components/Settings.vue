<template>
  <div class="container" v-if="userdata">

    <!--<%  if @user.errors.any? %>-->
    <!--<ul class="full_error">-->
      <!--<h5>You have errors</h5>-->
      <!--<% @user.errors.full_messages.each do |message| %>-->
      <!--<li><%= message %></li>-->
      <!--<% end %>-->
    <!--</ul>-->
    <!--<% end %>-->

    <transition name="custom-classes-transition" enter-active-class="animated fadeIn" leave-active-class="animated fadeOut">
      <ul class="errors_form" v-if="errors">
        <li v-for="(item, key) in errors">{{ item[0] }}</li>
      </ul>
    </transition>

    <div class="row">
      <div class="col s12 m6">

        <div class="card">
          <div class="card-content">
            <span class="card-title">{{ $t('setting.account_settings') }}</span>
            <div class="row">

              <form v-on:submit.prevent="update">
              <div class="input-field col s12">
                <input id="username" v-model="userdata.username" type="text" disabled>
                <label class="active">{{ $t('setting.users_username') }}</label>
              </div>

              <div class="input-field col s12">
                <input id="email" v-model="userdata.email" type="text">
                <label class="active">{{ $t('setting.users_email') }}</label>
              </div>

              <div class="input-field col s12">
                <input id="firstname" v-model="userdata.firstname" type="text">
                <label class="active">{{ $t('setting.users_firstname') }}</label>
              </div>

              <div class="input-field col s12">
                <input id="lastname" v-model="userdata.lastname" type="text">
                <label class="active">{{$t('setting.users_lastname') }}</label>
              </div>

              <div class="input-field col s12 right-align">
                <button type="submit" class="btn-large blue-grey darken-3 white-text"><i class="material-icons left white-text">send</i> <span class="white-text">{{ $t('setting.submit') }}</span></button>
              </div>

              </form>
            </div>
          </div>
        </div>
      </div>

      <div class="col s12 m6" v-if="userdata && !userdata.provider">
        <div class="card">
          <div class="card-content">
            <span class="card-title">{{ $t('setting.users_password') }}</span>
            <div class="row">

              <form v-on:submit.prevent="updatePassword">
              <div class="input-field col s12">
                <input id="current_password" v-model="tmp.current_password" type="password">
                <label class="active">{{ $t('setting.users_currentpassword') }}</label>
              </div>

              <div class="input-field col s12">
                <input id="newpassword" v-model="tmp.password" type="password">
                <label class="active">{{ $t('setting.users_newpassword') }}</label>
              </div>

              <div class="input-field col s12">
                <input id="password_confirmation" v-model="tmp.password_confirmation" type="password">
                <label class="active">{{ $t('setting.users_newpasswordtobesure') }}</label>
              </div>

              <div class="input-field col s12 right-align">
                <button type="submit" class="btn-large blue-grey darken-3 white-text"><i class="material-icons left white-text">send</i> <span class="white-text">{{ $t('setting.submit') }}</span></button>
              </div>

              </form>
            </div>
          </div>
        </div>
      </div>

      <div class="col s12 m6">
        <div class="card">
          <div class="card-content">
            <div class="row">
              <span class="card-title">{{ $t('setting.users_profilepicture') }}</span>
              <div class="center-align">
                <img :src="userdata.picture" ref="image" class="image_preview"/>
              </div>
              <form v-on:submit.prevent="updatePicture">
              <div class="file-field input-field">
                <div class="btn">
                  <input type="file" id="file" accept="image/x-png,image/gif,image/jpeg" v-on:change="loadFile">
                  <span>{{ $t('setting.users_profilepicture_new') }}</span>
                </div>
                <div class="file-path-wrapper">
                  <input class="file-path validate" type="text">
                </div>
              </div>

              <div class="input-field col s12 right-align">
                <button type="submit" class="btn-large blue-grey darken-3 white-text"><i class="material-icons left white-text">send</i> <span class="white-text">{{ $t('setting.submit') }}</span></button>
              </div>

              </form>

            </div>
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

  export default {
    store: Socket,
    name: 'Settings',
    data () {
      return {
        errors: false,
        tmp: {
          password: '',
          password_confirmation: '',
          current_password: ''
        }
      }
    },

    computed: {
      ...Vuex.mapGetters(['api_url', 'api_image', 'userdata'])
    },

    methods: {
      ...Vuex.mapActions(['saveUser']),
      loadFile: function (e) {
        if (e.target.files && e.target.files[0]) {
          this.$refs.image.src = URL.createObjectURL(e.target.files[0])
        }
      },

      updatePicture: function (e) {
        e.preventDefault()
        this.sendPicture(e)
      },

      sendPicture: function (e) {
        this.errors = false
        this.buttonAnimation(e, false, this.$t('menu.submit'))
        var formData = new FormData()
        formData.append('picture_file', document.getElementById('file').files[0])
        axios.put(this.api_url + '/users/picture', formData, {
          headers: {
            'Authorization': localStorage.getItem('token'),
            'Language': this.$i18n.locale
          }
        }).then(response => {
          if (response.status === 200) {
            this.$toast.success({message: response.data.message})
          } else if (response.status === 202) {
            this.errors = response.data.errors
          }
          this.buttonAnimation(e, true, this.$t('menu.submit'))
        }).catch((response) => {
          this.$toast.error({message: 'An error has occured'})
          this.buttonAnimation(e, true, this.$t('menu.submit'))
        })
      },

      update: function (e) {
        this.errors = false
        this.buttonAnimation(e, false, this.$t('menu.submit'))
        axios.put(this.api_url + '/users/data', {user: {
          email: this.userdata.email,
          lastname: this.userdata.lastname,
          firstname: this.userdata.firstname
        }
        }, {headers: {'Authorization': localStorage.getItem('token'), 'Language': this.$i18n.locale}}).then(response => {
          if (response.status === 200) {
            this.$toast.success({message: response.data.message})
          } else if (response.status === 202) {
            this.errors = response.data.errors
          }
          this.saveUser(response.data.user)
          this.buttonAnimation(e, true, this.$t('menu.submit'))
        }).catch((response) => {
          this.$toast.error({message: 'An error has occured'})
          this.buttonAnimation(e, true, this.$t('menu.submit'))
        })
      },

      updatePassword: function (e) {
        this.errors = false
        this.buttonAnimation(e, false, this.$t('menu.submit'))
        axios.put(this.api_url + '/users/password', {user: {
          password: this.tmp.password,
          password_confirmation: this.tmp.password_confirmation,
          current_password: this.tmp.current_password
        }
        }, {headers: {'Authorization': localStorage.getItem('token'), 'Language': this.$i18n.locale}}).then(response => {
          if (response.status === 200) {
            this.$toast.success({message: response.data.message})
          } else if (response.status === 202) {
            this.errors = response.data.errors
          }
          this.buttonAnimation(e, true, this.$t('menu.submit'))
        }).catch((response) => {
          this.$toast.error({message: 'An error has occured'})
          this.buttonAnimation(e, true, this.$t('menu.submit'))
        })
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
    }
  }

</script>


<style>
  .image_preview {
    max-width: 80%;
    max-height: 300px;
  }
</style>
