<template>
  <div v-if="user">
    <garvatar :user="user" />
    <h1>{{ user.name }}</h1>
    <a :href="`./users/${user.id}`">view my profile</a>
    <span>Microposts: {{ micropostCount }}</span>
  </div>
</template>

<script>
import Garvatar from '../helper/Gravatar.vue'

export default {
  name: 'UserInfo',
  components: {
    Garvatar
  },
  props: {
    user: Object,
    micropostCount: Number
  }
}
</script>

<style scoped>

</style>
