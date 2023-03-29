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
        <el-button type="primary" size="large" @click="nextWord()">
          <v-icon>mdi-arrow-right-thick</v-icon>
          Tiếp theo
        </el-button>
      </div>
    </div>


    <div class="progress-learning">
      <router-view></router-view>
    </div>


    
    <v-divider></v-divider>

    
    <span> AUDIO </span>
    <div class="audio-wrapper">
      <button type="button"  id='myvoice' @click="this.speak()">
        <img src="../../assets/icon/ic_audio.png" class="size-icon-48px" alt="Audio">
      </button> 
    </div>

    <el-button @click="randomLearningType()">random</el-button>
    <h1 v-if="ChooseRightMeaning">step1</h1>
    <h1 v-if="FillInABlank">step2</h1>
    <h1 v-if="ListenAndChoose">step3</h1>
    <h1 v-if="ChooseRightWord">step4</h1>
    <h1 v-if="CorrectListening">step5</h1>

  
  </div>


  
   <div v-else>

    <div class="header">
      <el-progress :text-inside="true" :stroke-width="26" :percentage="progressPercent" />

        <div class="temporary"></div>

        <div class="score-cover">
              {{ totalScore }}
        </div>

    </div>


            <LearnByMeaningVue v-if="learnByMeaning"
            :listWord="dataAPI"
            />
    
            <ChooseRightMeaning v-if="ChooseRightMeaning" 
              :listWord="dataAPI"
              @finish-learn="handleFinishLearn"
            />
    
            <FillInABlank v-if="FillInABlank"
              @finish-learn="handleFinishLearn"
            />
    
            <ListenAndChoose v-if="ListenAndChoose"
            :listWord="dataAPI"
            @finish-learn="handleFinishLearn"
            />
    
            <ChooseRightWord v-if="ChooseRightWord"
            @finish-learn="handleFinishLearn"
            />
          
            <CorrectListening v-if="CorrectListening"
            @finish-learn="handleFinishLearn"
            />  
        

   </div>
  
  </div>
</template>

<script>

import {func} from '@/GlobalFunction/script.js'
import axiosInstance from '../axios'

import LearnByMeaningVue from './LearnByMeaning.vue'
import ChooseRightMeaning from './ChooseRightMeaning.vue'
import FillInABlank from './FillInABlank.vue'
import ListenAndChoose from './ListenAndChoose.vue'
import ChooseRightWord from './ChooseRightWord.vue'
import CorrectListening from './CorrectListening.vue'
 
export default {
  components: {LearnByMeaningVue, ChooseRightMeaning, FillInABlank, ListenAndChoose, ChooseRightWord, CorrectListening},
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

      randomHasAppear: [],
     
      ChooseRightMeaning: false,
      FillInABlank: false,
      ListenAndChoose: false,
      ChooseRightWord: false,
      CorrectListening: false,

      randomTimes:0,
        

      learningSteps: [
        {
          'id': 1,
          'name': 'ChooseRightMeaning'
        },
        {
          'id': 2,
          'name': 'FillInABlank'
        },
        {
          'id': 3,
          'name': 'ListenAndChoose'
        },
        {
          'id': 4,
          'name': 'ChooseRightWord'
        },
        {
          'id': 5,
          'name': 'CorrectListening'
        }
      ]

    }
  },
  mixins: [func],


  mounted(){
    this.changeTitle()
    this.speak()
    this.getVocabularyByTopicID(this.idTopic)
    alert('mouas')
  },


  methods:{
    changeTitle(){
        document.title = "Học từ"
    },
    
    speak() {
        //set biến đếm để nói 1 lần        
        const listenBtn = document.getElementById('myvoice');
        let numTimesSpoken = 0;

        listenBtn.addEventListener('click', (e) => {
          e.preventDefault();

          if (numTimesSpoken < 1) {
            const msg = new SpeechSynthesisUtterance(`${this.currentVocab[0].Word}`);
            
            window.speechSynthesis.speak(msg);

            numTimesSpoken++;
          }
        });

     },

    getVocabularyByTopicID(topicID){
      axiosInstance.get(`/learning/topicid=${topicID}`)
            .then(res => this.handleData(res.data))
            
    },

    handleData(dataAPI){
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
        // this.learnByMeaning = true
        this.randomLearningType()
      }

    },

    handleFinishLearn(){
      console.log('finish step -> random  learning type')
      this.randomLearningType()
    },

    randomLearningType() {
        let valueRandom;

        //Random id trong mảng step đã có
        const random = Math.floor(Math.random() * this.learningSteps.length);
        valueRandom = this.learningSteps[random].id;
        console.log('Giá trị random', valueRandom)


        //nếu step đã xuất hiện trước đó thì ko push vào -> random lại
        if (!this.randomHasAppear.includes(valueRandom)) {
          console.log('Add vào', valueRandom)

          this.randomHasAppear.push(valueRandom);
          
          //Lấy name để kiểm tra nếu trùng với v-if component thì cho xuất hiện
          var component = this.learningSteps.find((item)=>{
              if(item.id == random + 1){
                return item.name
              }
          })

          if(component){
            console.log(component.name)
            console.log("this.ChooseRightMeaning", this.ChooseRightMeaning)
            console.log("this.FillInABlank", this.FillInABlank)
            console.log("this.ListenAndChoose", this.ListenAndChoose)
            console.log(" this.ChooseRightWord", this.ChooseRightWord)
            console.log("this.CorrectListening", this.CorrectListening)


            this.ChooseRightMeaning = component.name === 'ChooseRightMeaning'
            this.FillInABlank = component.name === 'FillInABlank'
            this.ListenAndChoose = component.name === 'ListenAndChoose'
            this.ChooseRightWord = component.name === 'ChooseRightWord'
            this.CorrectListening = component.name === 'CorrectListening'

            this.randomTimes+=1 
            //  số lần random max =  số từ * 2 
            // nếu bằng max -> học xong
            console.log('random times:', this.randomTimes)
          }

        }
        else{
          //nếu full mảng -> xóa mảng đã chứa các phần tử trước và random add lại
          if(this.randomHasAppear.length == this.learningSteps.length){
            console.warn('Mảng full -> reset', valueRandom)
            this.randomHasAppear.length = 0
            this.randomLearningType()
          }
          // Giá trị random đã có trong mảng -> random lại
          else{
            console.log('Không add ->  random lại', valueRandom)
            this.randomLearningType()
          }

        }
        console.log('Giá trị đã random:', this.randomHasAppear);
    },
  }
}
</script>

<style lang="scss" scoped>

.container{
  width: 100%;
  height: 100%;
  padding: 2% 0;
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

    .el-button{
      width: 100%;
      height: 100%;
      background-color: var(--main-color);
    }
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

</style>
