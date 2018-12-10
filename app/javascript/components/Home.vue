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
          <micropost-form
            :user="data.currentUser"
            @add-micropost="addMicropost($event)"
          />
        </section>
      </aside>
      <div class="col-md-8">
        <h3>Micropost Feed</h3>
        <Feed 
          :current-user="data.currentUser"
          :feed-items="data.feedItems"
          @change-favorite-count="changeFavoriteCount($event)"
          @remove-micropost="removeMicropost($event)"
        />
      </div>
    </div>
  </div>
</template>


<script>
import UserInfo from './shared/UserInfo.vue'
import Stats from './shared/Stats.vue'
import Feed from './shared/Feed.vue'
import MicropostForm from './shared/MicropostForm.vue'

export default {
  name: 'Home',
  components: {
    UserInfo,
    Stats,
    Feed,
    MicropostForm
  },
  data () {
    return {
      data: {
        user: {},
        micropostCount: 0,
        followingCount: 0,
        followersCount: 0,
        favoritesCount: 0,
        feedItems: []
      }
    }
  },
  created () {
    this.axios.get('').then(res => {
      this.data = res.data
    })
  },
  methods: {
    changeFavoriteCount (count) {
      this.data.favoritesCount = this.data.favoritesCount + count
    },
    addMicropost (micropost) {
      this.data.feedItems.unshift(micropost)
      this.data.micropostCount++
    },
    removeMicropost (micropost) {
      this.data.feedItems = this.data.feedItems.filter(item => item.id !== micropost.id)
      this.data.micropostCount--
    }
  }
}
</script>

<style scoped>

</style>


