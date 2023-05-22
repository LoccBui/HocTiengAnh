<template>
  <div id="app">
    <router-view />
  </div>
</template>

<script setup>
       // disable console.log
       console.log = function () {}; 
</script>

<style lang="scss">

#app{
  position: relative;
  width: 100vw;
  height: auto;
  border: none;
}

.el-button:focus,
.el-button:active,
.el-button:hover{
  outline: none;
  border: .3px solid #0038FF !important;
  opacity: 0.7 !important;
  background-color: #e6ebff !important;  
  color: #0038FF !important;
}



.el-button:focus{
  background-color: #e6ebff !important;
  color: #0038FF!important
}

.el-dialog{
  border-radius: 10px !important;
}


/* color pallete picker: https://imagecolorpicker.com/color-code/0038ff */
:root{
  --main-color: #0038FF;
  --light-blue-90: #010101;
  --gray-text: #888888;

  --tints-80: #ccd7ff;
  --tints-90: #e6ebff;
  --tints-20: #3360ff;

  --success: #28A745;
  --error: #FF0000;
  --normal: #888888;
}

*{ 
  margin: 0;
  padding: 0;
  border: 0;
  border-color: red;
  font-size: 100%;
  font-family: 'Noto Sans JP', 'Nunito Sans', Roboto, Arial, sans-serif;    
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

/* Scroll bar css*/
::-webkit-scrollbar {
   width: 8px;
 }

::-webkit-scrollbar-track {
  background: #f1f1f1;

}

::-webkit-scrollbar-thumb {
  background: #1565C0;
  border-radius: 5px;
}

::-webkit-scrollbar-thumb:hover {
  background: #555;
}

.section::-webkit-scrollbar-thumb {
    box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.3);
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

.txt-60{
  font-size: 60px;
}

.m-ud-8{
  margin: 8px 0;
}

.size-icon-48px{
  width: 48px;
}

.w80{
  width: 80%;
}

.w20{
  width: 20%;
}

.flex1{
  flex: 1;
}

// Elemnt ÚI
.el-input{
  ::placeholder {
    text-align: left; 
    font-weight: 400;
  }
}


</style>
