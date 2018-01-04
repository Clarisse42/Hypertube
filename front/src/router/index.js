import Vue from 'vue'
import Router from 'vue-router'
import Home from '@/components/Home'
import Login from '@/components/Login'
import Provider from '@/components/Provider'
import Register from '@/components/Register'
import Menu from '@/components/Menu'
import Search from '@/components/Search'
import MoviesBack from '@/components/MoviesBack'
import Player from '@/components/Player'
import SearchFilm from '@/components/SearchFilm'
import Profile from '@/components/Profile'
import Settings from '@/components/Settings'
import ForgotPassword from '@/components/ForgotPassword'
import ForgotPasswordReset from '@/components/ForgotPasswordReset'
import Category from '@/components/Category'
import NotFound from '@/components/NotFound'

Vue.use(Router)

export default new Router({
  mode: 'history',
  routes: [
    {
      path: '/',
      component: Menu,
      meta: {'keepAlive': true},
      children: [
        {
          path: '/',
          name: 'Home',
          component: Home,
          meta: {'keepAlive': false}
        },
        {
          path: '/category/:name',
          name: 'Category',
          component: Category,
          meta: {'keepAlive': true}
        },
        {
          path: '/profile/:username',
          name: 'Profile',
          component: Profile,
          meta: {'keepAlive': true, 'signin': true}
        },
        {
          path: '/settings',
          name: 'Settings',
          component: Settings,
          meta: {'keepAlive': true, 'signin': true}
        },
        {
          path: '/search',
          name: 'SearchFilm',
          component: SearchFilm,
          meta: {'keepAlive': true, 'signin': true}
        },
        {
          path: '/movies/:id',
          name: 'MoviesBack',
          component: MoviesBack,
          meta: {'keepAlive': false, 'signin': true},
          children: [
            {
              path: '/movies/:id/search',
              name: 'Search',
              meta: {'keepAlive': false, 'signin': true},
              component: Search
            },
            {
              path: '/movies/:id/play/:torrent_id',
              name: 'Player',
              meta: {'keepAlive': false, 'signin': true},
              component: Player
            }
          ]
        },
        {
          path: '/404',
          name: 'NotFound',
          component: NotFound,
          meta: {'keepAlive': false}
        }
      ]
    },
    {
      path: '/signin',
      name: 'Login',
      component: Login,
      meta: {'keepAlive': true}
    },
    {
      path: '/forgot-password',
      name: 'ForgotPassword',
      component: ForgotPassword,
      meta: {'keepAlive': true}
    },
    {
      path: '/forgot-password/:token',
      name: 'ForgotPasswordReset',
      component: ForgotPasswordReset,
      meta: {'keepAlive': true}
    },
    {
      path: '/signup',
      name: 'Register',
      component: Register,
      meta: {'keepAlive': true}
    },
    {
      path: '/provider/:provider',
      name: 'Provider',
      component: Provider,
      meta: {'keepAlive': false}
    },
    {
      path: '*',
      redirect: '/404'
    }
  ]
})
