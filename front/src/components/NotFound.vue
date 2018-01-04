<template>
  <div class="white-text">
    <div class="fulloader">
      <div class="error">
        <i class="material-icons large">error</i>
        <p>
          <h5>{{ $t('notfound') }}</h5>
        </p>
      </div>
    </div>
  </div>
</template>


<script type="text/babel">
  export default {
    name: 'NotFound'
  }
</script>
