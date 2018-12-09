<template>
  <div v-if="feedItems[0]">
    <ol class="microposts">
      <li v-for="micropost in feedItems" :key="micropost.id" :id="`micropost-${micropost.id}`">
        <gravatar
          :user="{ name: micropost.user_name, email: micropost.user_email }"
          :size="50"
        />
        <span class="user">
          <a :href="`/users/${micropost.user_id}`">{{ micropost.user_name }}</a>
        </span>
        <span class="content">
          {{ micropost.content }}
          <img v-if="micropost.picture" :src="micropost.picture.url">
        </span>
        <span class="timestamp">
          <div v-if="isFavorite(micropost)">
            あるよ～～
          </div>
          <div v-else>
            ないよ～～
          </div>
          Posted {{ timeAgoInWords(micropost.created_at) }}.
          <a v-if="currentUser.id === micropost.user_id" href='#'>delete</a>
        </span>
      </li>
    </ol>
  </div>
</template>

<script>
import Gravatar from '../helper/Gravatar.vue'
import TimeAgo from 'javascript-time-ago'
import en from 'javascript-time-ago/locale/en'
TimeAgo.addLocale(en)
const timeAgo = new TimeAgo('en-US')
export default {
  name: 'Feed',
  components: {
    Gravatar
  },
  props: {
    currentUser: Object,
    feedItems: Array,
    isFavoriteItems: Array
  },
  methods: {
    timeAgoInWords (date) {
      return timeAgo.format(new Date(date))
    },
    isFavorite (micropost) {
      let tmp = this.isFavoriteItems.find(function (item) {
        return item.id === micropost.id
      })
      return tmp.is_favorite === 1
    }
  }
}
</script>

<style scoped>
</style>
