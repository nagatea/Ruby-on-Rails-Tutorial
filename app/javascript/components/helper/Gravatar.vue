<template>
  <div>
    <img :src="gravaterUrl(user, size)" :alt="user.name" class="gravatar">
  </div>
</template>

<script>
import crypto from 'crypto'

export default {
  name: 'Gravatar',
  props: {
    user: {
      type: Object,
      required: true
    },
    size: {
      type: Number,
      default: 80
    }
  },
  computed: {
    
  },
  methods: {
    gravaterUrl (user, size) {
      const gravatarId = this.createMD5Hash(this.user.email)
      const res = `https://secure.gravatar.com/avatar/${gravatarId}?s=${size}`
      return res
    },
    createMD5Hash (str) {
      const md5hash = crypto.createHash('md5')
      return md5hash.update(str, 'binary').digest('hex')
    }
  }
}
</script>

<style scoped>

</style>
