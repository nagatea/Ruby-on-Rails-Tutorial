<template>
  <div v-if="feedItems.length">
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
          <img v-if="micropost.picture" :src="`/uploads/micropost/picture/${micropost.id}/${micropost.picture}`">
        </span>
        <span class="timestamp">
          <favorite-form 
            :micropost="micropost"
            @change-favorite-count="$emit('change-favorite-count', $event)"
          />
          Posted {{ timeAgoInWords(micropost.created_at) }}.
          <a v-if="currentUser.id === micropost.user_id" @click="removeMicropost(micropost)">delete</a>
        </span>
      </li>
    </ol>
  </div>
</template>

<script>
import Gravatar from '../helper/Gravatar.vue'
import FavoriteForm from '../users/FavoriteForm.vue'
import TimeAgo from 'javascript-time-ago'
import en from 'javascript-time-ago/locale/en'
TimeAgo.addLocale(en)
const timeAgo = new TimeAgo('en-US')
export default {
  name: 'Feed',
  components: {
    Gravatar,
    FavoriteForm
  },
  props: {
    currentUser: {
      type: Object,
      required: true
    },
    feedItems: {
      type: Array,
      default: []
    }
  },
  methods: {
    timeAgoInWords (date) {
      return timeAgo.format(new Date(date))
    },
    async removeMicropost (micropost) {
      let result = confirm('You sure?')
      if (!result) { return }
      await this.axios.delete(`/microposts/${micropost.id}`)
      this.$emit('remove-micropost', micropost)
    }
  }
}
</script>

<style scoped>
</style>
