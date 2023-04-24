<template>
   <div class="container">
      <div class="laban-wrapper">
        <!-- <iframe class="widget-laban" width="100%" src="https://dict.laban.vn/widget/widget?w=1500&h=1000&hl=2&th=3"></iframe> -->

        <el-input placeholder="Nhập từ"
        v-model="inputWord" 
        @keyup.enter="searchWord()"
        >Nhập từ cần tra
        </el-input>


        <div>
          Phát âm: {{ Transliteration }}
        </div>

        <div>
          Nghĩa tiếng việt: {{ meaning }}
        </div>

        <div>
          Nghĩa khác: {{ otherMeaning }}
        </div>

        <el-divider />


        <div v-for="(item) in definitions" :key="item">
            {{ item[0]?.verb|| item[0]?.noun}}
            <div v-html="`${item[0]?.verb || item[0]?.noun}`"></div>
        </div>

        <br>


        <el-divider />
        
        <div>
          Ví dụ khác {{ seeMore }}
        </div>

        <div v-for="item in example" :key="item">
          <div v-html="`${item}`"></div>
        </div>
        
      </div>
    </div>
</template>

<script>
import axiosInstance from '../axios'
export default {
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
      },
      
      searchWord(){
          axiosInstance.get(`https://api.datpmt.com/${import.meta.env.VITE_URL_TRANSLATE}/translate?string=${this.inputWord}`)
          .then( (res) => this.meaning = res.data )


          axiosInstance.get(`https://api.datpmt.com/${import.meta.env.VITE_URL_TRANSLATE}/alternate_translations?keyword=${this.inputWord}`)
          .then( (res) => this.otherMeaning = res.data )

          axiosInstance.get(`https://api.datpmt.com/${import.meta.env.VITE_URL_TRANSLATE}/examples?keyword=${this.inputWord}`)
          .then( (res) => this.example.push(res.data) )

          axiosInstance.get(`https://api.datpmt.com/${import.meta.env.VITE_URL_TRANSLATE}/transliteration?keyword=${this.inputWord}`)
          .then( (res) => this.Transliteration = res.data)
          

          axiosInstance.get(`https://api.datpmt.com/${import.meta.env.VITE_URL_TRANSLATE}/see_more?keyword=${this.inputWord}`)
          .then( (res) => this.seeMore = res.data)

          axiosInstance.get(`https://api.datpmt.com/${import.meta.env.VITE_URL_TRANSLATE}/definitions?keyword=${this.inputWord}`)
          .then( (res) => this.definitions.push(res.data))
      }

    }
}
</script>

<style lang="scss" scoped>
.container{
  width: 100%;
  height: 600px;
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