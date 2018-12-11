<template>
  <form class='new_micropost' id='new_micropost' accept-charset='UTF-8'>
    <div class='field'>
      <textarea v-model="content" placeholder='Compose new micropost...' name='micropost[content]' id='micropost_content'></textarea>
    </div>
    <input v-if="content" type='button' name='commit' value='Post' class='btn btn-primary' data-disable-with='Post' @click='createMicropost'>
    <input v-else type='button' name='commit' value='Post' class='btn' data-disable-with='Post'>
    <span class='picture'>
      <input accept='image/jpeg,image/gif,image/png' type='file' name='micropost[picture]' id='micropost_picture' ref='picture' @change="postPicture">
    </span>
  </form>
</template>

<script>
export default {
  name: 'MicropostForm',
  props: ['user'],
  data () {
    return {
      content: '',
      picture: null,
      micropost: {
        id: 0,
        content: "",
        user_id: 0,
        created_at: "",
        updated_at: "",
        picture: null,
        favorite_count: 0,
        user_name: "",
        user_email: "",
        user_admin: "",
        is_favorite: 0,
        favorite_relationships_id: null
      }
    }
  },
  methods: {
    createMicropost () {
      let formData = new FormData()
      formData.append('micropost[content]', this.content)
      formData.append('micropost[picture]', this.picture)
      let config = {
        headers: {
          'content-type': 'multipart/form-data'
        }
      }

      this.axios.post(`/microposts`, formData, config)
        .then((res) => {
          let result = res.data
          this.micropost.id = result.id
          this.micropost.content = result.content
          if (this.picture) {
            this.micropost.picture = result.picture.url.match(/\d\/(.+)/i)[1]
          }
          this.micropost.user_id = this.user.id
          this.micropost.created_at = result.created_at
          this.micropost.updated_at = result.updated_at
          this.micropost.user_name = this.user.name
          this.micropost.user_email = this.user.email
          this.micropost.user_admin = this.user.admin
          this.$emit('add-micropost', JSON.parse(JSON.stringify(this.micropost)))
        })
        .then((res) => {
          this.content = ''
          this.picture = null
          this.micropost.content = ''
          this.micropost.picture = null
          document.getElementById('micropost_picture').value = ''
        })
    },
    postPicture () {
      let picture = this.$refs.picture.files[0]
      if (picture) {
        if (picture.size /1024 / 1024 > 5) {
          alert('Maximum file size is 5MB. Please choose a smaller file.')
        } else {
          this.picture = picture
        }
      }
    }
  }
}
</script>

<style scoped>

</style>
