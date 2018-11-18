<template>
  <div>
    <div class="row">
      <aside class="col-md-4">
        <section class="user_info">
          <user-info :user="data.currentUser" :micropost-count="data.micropostCount" />
        </section>
        <section class="stats">
          <!--<%= render 'shared/stats' %>-->
        </section>
        <section class="micropost_form">
          <!--<%= render 'shared/micropost_form' %>-->
        </section>
      </aside>
      <div class="col-md-8">
        <h3>Micropost Feed</h3>
        <!--<%= render 'shared/feed' %>-->
      </div>
    </div>
  </div>
</template>


<script>
import UserInfo from './shared/UserInfo.vue'
import axios from 'axios'
axios.defaults.headers['X-Requested-With'] = 'XMLHttpRequest'

export default {
  name: 'Home',
  components: {
    UserInfo
  },
  data () {
    return {
      data: {
        user: {name: 'loading'},
        micropostCount: 0
      }
    }
  },
  created () {
    axios.get('').then(res => {
      this.data = res.data
    })
  }
}
</script>

<style scoped>

</style>


