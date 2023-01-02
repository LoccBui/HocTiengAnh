<template>
  <router-view />
</template>

<script setup>

</script>

<style>
:root{
  --main-color: #0038FF;
  --gray-text: #888888;
}

*{ 
  margin: 0;
  padding: 0;
  border: 0;
  font-size: 100%;
 }

a{
  text-decoration: none;
}

a:active{
  color: #0038FF;
}

a:visited {
  color: #888888;
}


/* redefine class */

.primary-text-color{
  color: #0038FF !important;
}

.hover-pointer:hover{
  cursor: pointer;
}

.no-hover-pointer{
  cursor: default;
}
</style>
