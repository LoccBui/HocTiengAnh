<template>
  <div class="container">

  <div v-if="reviewWords">

    <div class="info-word-area">
      <div class="info-word" v-for="words in currentVocab" :key="words.VocabID">
          <span class="txt-20"> ENGLISH </span>
          <h1 class="txt-40">{{  words.Word }} </h1>
          <span class="txt-20"> LABEL </span>
          <h1 class="txt-40">{{  words.Label }} </h1>
          <span class="txt-20"> VIETNAMESE </span>
          <h1 class="txt-40">{{  words.Vietnamese }}</h1>
      </div>
    
      <div class="next-action">
        <v-btn 
          color="primary"
          height="100%"
          block
          @click="nextWord()"
          @keyup.enter="nextWord()"
          >
          <v-icon>mdi-arrow-right-thick</v-icon>
          Tiếp theo
        </v-btn>
      </div>
    </div>
    
    <v-divider></v-divider>
    
    <span> AUDIO </span>
    <div class="audio-wrapper">
      <button type="button"  id='myvoice' @click="this.speak()">
        <img src="../../assets/icon/ic_audio.png" class="size-icon-48px" alt="Audio">
      </button> 
    </div>

  
  </div>

    <LearnByMeaningVue v-if="learnByMeaning"/>
  
  </div>
</template>

<script>

import {func} from '@/GlobalFunction/script.js'
import axiosInstance from '../axios'
import LearnByMeaningVue from './LearnByMeaning.vue'
 
export default {
  components: {LearnByMeaningVue},
  data(){
    return {
      idTopic: this.$route.params.id,
      englishWords : '',
      vietnameseMean : 'chọn',

      dataVocabAPI: [],
      currentVocab: [],
      currentIndex: 0,
      vocabLength: 0,


      reviewWords: true,
      learnByMeaning: false,

    }
  },
  mixins: [func],


  mounted(){
    this.changeTitle()

    this.getVocabularyByTopicID(this.idTopic)
  },

  beforeMount() {
  },

  methods:{
    changeTitle(){
        document.title = "Học từ"
    },

    speak(englishWords){
      func.speakWord(`${englishWords}`)
    },

    getVocabularyByTopicID(topicID){
      axiosInstance.get(`/learning/topicid=${topicID}`)
            .then(res => this.handleData(res.data))
            
    },

    handleData(dataAPI){
      console.log("datA",dataAPI)
        this.dataAPI = dataAPI
        this.vocabLength = dataAPI.length

        this.currentVocab.push(this.dataAPI[this.currentIndex])

        this.englishWords = this.dataAPI[this.currentIndex].Word

    },

    nextWord(){
      //Inscrease index and push the next word
      this.currentIndex++
      this.currentVocab.length = 0

      if(this.currentIndex != this.vocabLength){
        this.currentVocab.push(this.dataAPI[this.currentIndex])
        
        this.englishWords = this.dataAPI[this.currentIndex].Word
      }
      else{
        this.reviewWords = false
        this.learnByMeaning = true
      }

    }
    

    
  }
}
</script>

<style lang="scss" scoped>

.container{
  padding: 20px;

}

.btnNext{
  color: red !important;
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



// Mobile devices
@media screen and (max-width: 900px){

}

@media screen and (max-width: 768px){
  .info-word-area{
    display: flex;
    flex-direction: column;

    .info-word{
      width: 100%;
    }
  }


}

</style>>
