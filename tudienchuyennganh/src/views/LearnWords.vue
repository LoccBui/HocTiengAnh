<template>
  <div class="container">

    <div class="info-word-area">
      <div class="info-word">
        <span class="txt-20"> ENGLISH </span>
          <h1 class="txt-40">{{  englishWords }} </h1>
        <span class="txt-20"> VIETNAMESE </span>
          <h1 class="txt-40">{{  vietnameseMean }}</h1>
      </div>
    
      <div class="next-action">
        <v-btn 
          color="primary"
          height="100%"
          block>
        <v-icon>mdi-arrow-right-thick</v-icon>
      
        Tiếp theo
        </v-btn>
      </div>
    </div>
    
    <v-divider></v-divider>
    
    <span> AUDIO </span>
    <div class="audio-wrapper">
      <button type="button"  id='myvoice'>
        <img src="../assets/icon/ic_audio.png" class="size-icon-48px" alt="Audio">
      </button>
      
    </div>

   
    
    
    <hr style="width:50%; height: 40px;">

    
  
  </div>
</template>

<script>

import {func} from '@/Function/script.js'
 
export default {
  data(){
    return {
      englishWords : 'choose',
      vietnameseMean : 'chọn',

    }
  },
  mixins: [func],


  mounted(){
    this.changeTitle()
    console.log('learnword:1')

    this.speak()
  },

  beforeMount() {
    window.onload = function(){
      console.log('2')
      var a=document.getElementById('myvoice')
      a.click()
    }
  },

  methods:{
    changeTitle(){
        document.title = "Học từ"
    },

    speak(){
      func.speakWord(`${this.englishWords}`)
    }
  }
}
</script>

<style lang="scss" scoped>

.container{
  padding: 20px;

}
.info-word-area{
  display: flex;
  height: auto;

  .info-word{
    width: 90%;
  }

  .next-action{
    flex: 1;
  }

  .btn-next{
    background-color: red;
  }
}

.audio-wrapper{
  background-color: var(--light-blue-90);
  width: 100px;
  height: inherit;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 5px;
  padding: 5px;
}

</style>>
