<template>
  <div class="stats">
    <a :href="`/users/${user.id}/following`">
      <strong id="following" class="stat">
        {{ followingCount }}
      </strong>
      following
    </a>
    <a :href="`/users/${user.id}/followers`">
      <strong id="followers" class="stat">
        {{ followersCount }}
      </strong>
      followers
    </a>
    <a :href="`/users/${user.id}/favorites`">
      <strong id="favorites" class="stat">
        {{ favoritesCount }}
      </strong>
      favorites
    </a>
  </div>
</template>

<script>
export default {
  name: 'Stats',
  props: {
    user: {
      type: Object,
      required: true
    },
    followingCount: {
      type: Number,
      required: true
    },
    followersCount: {
      type: Number,
      required: true
    },
    favoritesCount: {
      type: Number,
      required: true
    }
  }
}
</script>

<style scoped>
</style>
