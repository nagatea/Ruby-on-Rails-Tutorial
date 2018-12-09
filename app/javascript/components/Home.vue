<template>
  <div>
    <div class="row">
      <aside class="col-md-4">
        <section class="user_info">
          <user-info 
            :user="data.currentUser"
            :micropost-count="data.micropostCount"
          />
        </section>
        <section class="stats">
          <stats 
            :user="data.currentUser"
            :following-count="data.followingCount"
            :followers-count="data.followersCount"
            :favorites-count="data.favoritesCount"
          />
        </section>
        <section class="micropost_form">
          <!--<%= render 'shared/micropost_form' %>-->
        </section>
      </aside>
      <div class="col-md-8">
        <h3>Micropost Feed</h3>
        <Feed 
          :current-user="data.currentUser"
          :feed-items="data.feedItems"
          :is-favorite-items="data.isFavoriteItems"
        />
      </div>
    </div>
  </div>
</template>


<script>
import UserInfo from './shared/UserInfo.vue'
import Stats from './shared/Stats.vue'
import Feed from './shared/Feed.vue'
import axios from 'axios'
axios.defaults.headers['X-Requested-With'] = 'XMLHttpRequest'

export default {
  name: 'Home',
  components: {
    UserInfo,
    Stats,
    Feed
  },
  data () {
    return {
      data: {
        user: {},
        micropostCount: 0,
        followingCount: 0,
        followersCount: 0,
        favoritesCount: 0,
        feedItems: [],
        isFavoriteItems: [],
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


