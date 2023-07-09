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

    created(){
      document.title = "Tra từ"

    },
}
</script>

<style lang="scss" scoped>
.container{
  width: 100%;
  height: 100vh;
}

.widget-laban{
  height: 500px;
}

@media screen and (max-width: 768px){

    .container{
      min-height: 200px !important;
    }

    iframe {
      width: 100%;
      overflow-y: scroll;
    }
    
    .widget-laban{
      min-height: 700px;
      width: 100%;
    }
}

// style="background-color: red; border:0; padding:0;width:100%;height:1000px;"
</style>