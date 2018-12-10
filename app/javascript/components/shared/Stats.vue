<template>
  <div v-if="user" class="stats">
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
    user: Object,
    followingCount: Number,
    followersCount: Number,
    favoritesCount: Number
  }
}
</script>

<style scoped>
</style>
