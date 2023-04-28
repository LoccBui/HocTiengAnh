<template>
   <div class="container">
      <div class="laban-wrapper">
        <iframe class="widget-laban" width="100%" src="https://dict.laban.vn/widget/widget?w=1500&h=1000&hl=2&th=3"></iframe>
      </div>
    </div>
</template>


<script>
import { requireTokenMixin } from '@/mixin/requireTokenMixin'

export default {
  mixins:[requireTokenMixin],
    data(){
      return{
        inputWord: '',

        meaning: '',
        otherMeaning: '',
        example: [],
        Transliteration: '',
        seeMore: '',
        definitions: []
      }
    },

    mounted(){
        this.changeTitle()
    },

    methods:{
      changeTitle(){
        document.title = "Tra từ"
      }
    }
}
</script>

<style lang="scss" scoped>
.container{
  width: 100%;
  min-height: 600px;
}

.widget-laban{
  height: 500px;
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