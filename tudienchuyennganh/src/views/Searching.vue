<template>
   <div class="container">
      <div class="laban-wrapper">
        <iframe class="widget-laban" width="100%" scrolling="no"   src="https://dict.laban.vn/widget/widget?w=1500&h=1000&hl=2&th=3"></iframe>

        <!-- <el-input placeholder="Nhập từ"
        v-model="inputWord" 
        @keyup.enter="searchWord()"
        >Nhập từ cần tra</el-input> -->

        
      </div>
    </div>
</template>

<script>
import axiosInstance from '../axios'
export default {
    data(){
      return{
        inputWord: '',
      }
    },

    mounted(){
        this.changeTitle()
    },

    methods:{
      changeTitle(){
        document.title = "Tra từ"
      },
      
      searchWord(){
      


      
      }
    }
}
</script>

<style lang="scss" scoped>
.container{
  width: 100%;
  height: 100vh;
}
.poweredby {
  display: none  !important;
}

@media screen and (max-width: 768px){
    iframe {
      margin-left: 10%;
      width: 20%;
      height: auto;
      overflow-y: scroll;
    }

    .laban-wrapper{
      width: 100%;
    }



    .slide-content-popup>ul>li {
      width: 2px !important;
    }
}

// style="background-color: red; border:0; padding:0;width:100%;height:1000px;"
</style>