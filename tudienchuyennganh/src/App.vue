<template>
  <router-view />
</template>

<script setup>
       // disable console.log
      //  console.log = function () {}; 
</script>

<style>
/* color pallete picker: https://imagecolorpicker.com/color-code/0038ff */
:root{
  --main-color: #0038FF;
  --light-blue-90: #e6ebff;
  --gray-text: #888888;

  --tints-80: #ccd7ff;
  --tints-90: #e6ebff;

  --success: #28A745;
  --error: #FF0000;
  --normal: #888888;
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

/* size */

.txt-20{
  font-size: 20px;
}


.txt-40{
  font-size: 40px;
}

.size-icon-48px{
  width: 48px;
}


</style>
