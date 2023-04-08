<template>
   <div class="container">
      <div class="laban-wrapper">
        <!-- <iframe class="widget-laban" width="100%" scrolling="no"  src="https://dict.laban.vn/widget/widget?w=1500&h=1000&hl=2&th=3"></iframe> -->

        <el-input placeholder="Nhập từ"
        v-model="inputWord" 
        @keyup.enter="searchWord()"
        >Nhập từ cần tra</el-input>

        
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
      async searchWord(){
        console.log(this.inputWord)
        // let result = await axiosInstance.post(`https://api.tracau.vn/WBBcwnwQpV89/s/hello/vn`, {
        //   Headers:{
        //     'Access-Control-Allow-Origin': '*',
        //     'Access-Control-Allow-Methods': '*'
        //   }
        // })

        // if(result.status == 200){
        //   console.log(result.data)
        // }

        const options = {
          method: 'GET',
          url: 'https://mashape-community-urban-dictionary.p.rapidapi.com/define',
          params: {term: `${this.inputWord}`},
          headers: {
            'X-RapidAPI-Key': 'c5960726e9msh6b961461b45c9aep1e2415jsnafb867e7e961',
            'X-RapidAPI-Host': 'mashape-community-urban-dictionary.p.rapidapi.com'
          }
        };

        axiosInstance.request(options).then(function (response) {
          console.log(response.data.list);
          // this.resultWord = response.data.list
        }).catch(function (error) {
          console.error(error);
        });
      }
    }
}
</script>

<style lang="scss" scoped>
.container{
  width: 100%;
  height: 1000px;
}

.widget-laban{
  padding: 20px;
  width: 100% !important;
  height: 1000px;
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