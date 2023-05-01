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
  
  </div>


  
   <div v-else-if="learning">

    <div class="header">

        <div class="w80">
          <el-progress color="var(--main-color)" v-model="progressLearning" :text-inside="true" :stroke-width="26" :percentage="progressPercent" />
        </div>
      
        <div class="flex1 score-cover">
            <span class="score-number">
              {{ totalScore }}
            </span> 
        </div>

    </div>


    <LearnByMeaningVue v-if="learnByMeaning"
    :listWord="dataAPI"
    :accountID="accountID"
    @step-Status="handleProgress"
    />

    <ChooseRightMeaning v-if="ChooseRightMeaning" 
      :listWord="dataAPI"
      :accountID="accountID"
      @finish-learn="handleFinishLearn"
      @step-Status="handleProgress"
    />

    <FillInABlank v-if="FillInABlank"
      :listWord="dataAPI"
      :accountID="accountID"
      @finish-learn="handleFinishLearn"
      @step-Status="handleProgress"
    />

    <ListenAndChoose v-if="ListenAndChoose"
      :listWord="dataAPI"
      :accountID="accountID"
      @finish-learn="handleFinishLearn"
      @step-Status="handleProgress"
    />

    <ChooseRightWord v-if="ChooseRightWord"
      :listWord="dataAPI"
      :accountID="accountID"
      @finish-learn="handleFinishLearn"
      @step-Status="handleProgress"
      />
  
    <CorrectListening v-if="CorrectListening"
      :listWord="dataAPI"
      @finish-learn="handleFinishLearn"
      @step-Status="handleProgress"
    />  
    

    
  </div>

  <div v-else>
    <ReviewWord v-if="showReviewWord"
      :dataReview="dataAPI"
      :idTopic="idTopic"
      :totalScore="totalScore"
    />
  </div>
  
   

  
  </div>
</template>

<script>

import axiosInstance from '../axios'

import LearnByMeaningVue from './LearnByMeaning.vue'
import ChooseRightMeaning from './ChooseRightMeaning.vue'
import FillInABlank from './FillInABlank.vue'
import ListenAndChoose from './ListenAndChoose.vue'
import ChooseRightWord from './ChooseRightWord.vue'
import CorrectListening from './CorrectListening.vue'
import Cookies from 'js-cookie';

import ReviewWord from '@/components/ReviewWord.vue'

export default {
  components: {LearnByMeaningVue, ChooseRightMeaning, FillInABlank, ListenAndChoose, ChooseRightWord, CorrectListening, ReviewWord},
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
      totalScore: 0,

      progressPercent: 0,
      progressLength: '',
      progressLearning: '',

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
      ],

      showReviewWord:false,

      learning: false,

      accountID: ''

    }
  },

  created(){
    document.title = "Học từ"

  },

  mounted(){
    this.getVocabularyByTopicID(this.idTopic)
  },


  methods:{
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
      let dataUser = JSON.parse(Cookies.get('userInfo'))

      this.accountID = dataUser.accountID

      axiosInstance.post(`learning/topicid`, {
        "TopicID": topicID,
        "AccountID": dataUser.accountID
      })
      .then(res => this.handleData(res.data))    
    },

    handleProgress(status){

      const totalStep = (this.vocabLength * 2) 
      const inscreasePercent = (100 / totalStep)


      if(this.progressPercent != 100){
        switch(status){
          case "correct": 
            this.totalScore += 100
            this.progressPercent += inscreasePercent
            break;
          case "wrong": 
            this.totalScore += 0
            this.progressPercent += inscreasePercent
            break;
          case "mention": 
            this.totalScore += 50
            this.progressPercent += inscreasePercent
            break;
          default: 
            this.totalScore += 0
            this.progressPercent += inscreasePercent
            break;
        }

        if(this.progressPercent == 100){
          this.learnByMeaning = false
          this.ChooseRightMeaning =  false
          this.FillInABlank = false
          this.ListenAndChoose = false
          this.ChooseRightWord = false
          this.CorrectListening = false
          this.showReviewWord = true
        }
        else{
          this.randomLearningType()
        }
      }
    },

    handleData(dataAPI){
        console.log(dataAPI)
      
        this.progressLength = dataAPI.length
        console.log(this.progress)

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
        this.learning = true
        // this.learnByMeaning = true
   
        this.randomLearningType()
        
      }

    },

    handleFinishLearn(){
      this.randomLearningType()
    },

    randomLearningType() {

      if(this.progressPercent == 100){
        this.learning = false
      }
      else{

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

      }

    },
  }
}
</script>

<style lang="scss" scoped>

.container{
  min-height: 600px;
  padding: 0 2%;
}
.btnNext{
  color: red !important;
}
.info-word-area{
  display: flex;
  height: auto;

  .info-word{
    width: 85%;
  }

  .next-action{
    flex: 1;

    .el-button{
      font-size: 25px;
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
  box-shadow: rgba(50, 50, 93, 0.25) 0px 6px 12px -2px, var(--main-color) 0px 3px 7px -3px;
  width: 150px;
  height: inherit;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 5px;
  padding: 5px;
  animation: sparkle infinite 3s linear;
}


@keyframes sparkle{
  0%{
    box-shadow: rgba(50, 50, 93, 0.25) 0px 3px 6px -0px, var(--main-color) 0px 3px 7px -3px;

  }
  100%{
    box-shadow: rgba(50, 50, 93, 0.25) 0px 10px 15px 4px, var(--main-color) 0px 3px 7px -3px;

  }
}


.header{
  display: flex;
  align-items: center;
  .el-progress{
    width: 100%;
  }

  .score-cover{          
    width: 100%;
    display: flex;
    justify-content: center;
  }

  .score-number{
    border-radius: 20px;
    padding: 10px 0px;
    text-align: center;
    width: 100px;
    display: flex;
    justify-content: center;
    align-items: center;
    box-shadow: rgba(0, 0, 0, 0.16) 0px 3px 6px, rgba(0, 0, 0, 0.23) 0px 3px 6px;
  }


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
