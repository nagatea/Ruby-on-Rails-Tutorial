<template>
  <div :id="`favorite_form-${micropost.id}`">
    <input v-if="micropost.is_favorite" type='button' name='commit' :value="`${micropost.favorite_count} likes`" class='favorite' :data-disable-with="`${micropost.favorite_count} likes`" @click='unfavorite'>
    <input v-else type='button' name='commit' :value="`${micropost.favorite_count} likes`" class='non-favorite' :data-disable-with="`${micropost.favorite_count} likes`" @click='favorite'>
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
    async unfavorite () {
      await this.axios.delete('/favorite_relationships', {
        params: { id: this.micropost.favorite_relationships_id }
      })
      this.micropost.favorite_count--
      this.micropost.is_favorite = 0
      this.$emit('change-favorite-count', -1)
    }
  }
}
</script>

<style scoped>

</style>
