<template>
  <div :id="`favorite_form-${micropost.id}`">
    <input v-if="micropost.is_favorite" type='button' name='commit' :value="favoriteCount" class='favorite' :data-disable-with="favoriteCount" @click='cancelFavorite'>
    <input v-else type='button' name='commit' :value="favoriteCount" class='non-favorite' :data-disable-with="favoriteCount" @click='favorite'>
  </div>
</template>

<script>
export default {
  name: 'FavoriteForm',
  props: {
    micropost: {
      type: Object,
      required: true
    }
  },
  computed: {
    favoriteCount () {
      return `${this.micropost.favorite_count} likes`
    },
  },
  methods: {
    async favorite () {
      let res = await this.axios.post('/favorite_relationships', {
        micropost_id: this.micropost.id
      })
      this.micropost.favorite_relationships_id = res.data.favorite_relationships_id
      this.micropost.favorite_count++
      this.micropost.is_favorite = 1
      this.$emit('change-favorite-count', 1)
    },
    async cancelFavorite () {
      await this.axios.delete(`/favorite_relationships/${this.micropost.favorite_relationships_id}`)
      this.micropost.favorite_count--
      this.micropost.is_favorite = 0
      this.$emit('change-favorite-count', -1)
    }
  }
}
</script>

<style scoped>

</style>
