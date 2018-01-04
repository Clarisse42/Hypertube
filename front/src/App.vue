<template>
  <div id="app">
    <transition name="custom-classes-transition" enter-active-class="animated fadeIn">
      <router-view></router-view>
    </transition>
  </div>
</template>

<script>
export default {
  name: 'app'
}
</script>

<style>
#app {
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
}

nav {
  height: 65px;
}

nav.transparent {
  background: rgba(0, 0, 0, 0.5) !important;
}

 .VueCarousel-slide {
   position: relative;
   text-align: center;
   height: 500px;
   background-position: center;
   background-size: cover;
   background-repeat: no-repeat;
   transition: all 1s;
   cursor: pointer;
 }

.VueCarousel {
  width: calc(100% - 100px);
  margin-left: auto;
  margin-right: auto;
}

.VueCarousel-navigation
{
  height: 100%;
  text-align: center;
  background: red;
}
.VueCarousel-navigation-button {
  background: black;
  color: white !important;
  height: 100%;
  width: 50px;
  vertical-align: middle;
  transition: all 2s;
}

.VueCarousel-navigation-button:hover {
  background: white;
  color: black !important;
}

.VueCarousel-navigation--disabled:hover {
  background: black;
  color: white !important;
}

.VueCarousel-navigation-button:before {
  content: '';
  display: inline-block;
  height: 100%;
  color: white;
  vertical-align: middle;
  margin-right: -0.25em; /* Adjusts for spacing */
}

/*.VueCarousel-navigation-prev {*/
  /*color: white;*/
/*}*/

.VueCarousel-slide:hover .slideTitle {
  opacity: 0;
}


.viewed {
  position: absolute;
  top: 80px;
  left: 0;
  /*width: 50px;*/
  height: 35px;
  background: rgba(0, 0, 0, 0.4);
  padding: 0px 10px;
  margin: 0;
  text-align: left;
  display: flex;
}

.year {
  position: absolute;
  top: 0px;
  left: 0px;
  /*width: 50px;*/
  height: 35px;
  background: rgba(0, 0, 0, 0.4);
  padding: 0px 10px;
  margin: 0;
  text-align: left;
  display: flex;
}

.rating {
  position: absolute;
  top: 40px;
  left: 0px;
  /*width: 50px;*/
  height: 35px;
  background: rgba(0, 0, 0, 0.4);
  padding: 0px 10px;
  margin: 0;
  text-align: left;
  display: flex;
}

.viewed i {
  line-height: 35px;
}

.viewed span {
  margin: auto;
  padding-left: 10px;
}

.rating span {
  margin: auto;
  padding-left: 10px;
}

.rating i {
  margin: auto;
}

.year span {
  margin: auto;
  padding-left: 10px;
}

.year i {
  margin: auto;
}


.slideTitle {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  min-height: 80px;
  background: rgba(0, 0, 0, 0.8);
  padding: 10px;
  transition: all 1s;
  display: flex;
}

.VueCarousel-slide:hover .slideInfo {
  opacity: 1;
}

.slideInfo {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  min-height: 80px;
  z-index: 10;
  background: rgba(0, 0, 0, 0.8);
  transition: all 1.5s;
  opacity: 0;
  display: flex;
}

.slideInfo a {
  margin: auto;
}

.VueCarousel-slide h5 {
  margin: auto;
  text-align: center;
}

.seemore {
  display: flex !important;
}

.seemore:hover {
  background: black !important;
  color: white !important;
}

.seemore div{
  margin: auto;
}

.fulloader {
  position: absolute !important;
  top: 0 !important;
  right: 0 !important;
  left: 0 !important;
  bottom: 0 !important;
  z-index: 3 !important;
  background: black;
  display: flex;
  overflow: hidden;
}

.carousel_loading {
  width: 100%;
  height: 500px;
  background: #000;
  display: flex;
  transition: all 1.5s;
}

.carousel_loading .preloader-wrapper, .fulloader .preloader-wrapper {
  margin: auto;
}

.carousel_loading .error, .fulloader .error {
  margin: auto;
  text-align: center;
}

.spinner-blue-only {
  border-color: #fff !important;
}

.carousel_loading.danger, .fulloader.danger {
  background: #d32f2f !important;
}

.carousel_loading.success, .fulloader.success {
  background: #8FCF3C !important;
}

.btn-large {
  transition: background 1s !important;
  color: #263238 !important;
}

.btn-large:hover {
  background: #263238 !important;
  color: white !important;
}

.logo {
  position: relative;
  width: 100%;
  height: auto;
  float: left;
  text-align: center;
  margin-top: 40px;
}

.logo img {
  max-width: 100%;
  width: 400px;
}

.box_language {
  width: 100%;
  position: relative;
  float: left;
  text-align: center;
  font-size: 25px;
  color: #f3e5f5;
}

.box_language span:hover {
  color: cornflowerblue !important;
}

.box_language span {
  cursor: pointer;
}

.box_language .active {
  font-size: 40px;
  color: white;
}

.box_language span:hover.active {
  color: white !important;
}

.errors_form {
  list-style: circle;
  list-style-type: cjk-ideographic;
  background: #b71c1c;
  position: relative;
  float: left;
  width: 100%;
  color: white;
}

.errors_form li {
  padding: 5px 10px;
  list-style: circle;
}

</style>
