<template>
  <div class="container mt-4"> 

    <div class="header"> 

      <h1 class="left-side w80 normal-text">
        Nghe phát âm và chọn từ

        <div class="timer">
          <h1 style="text-align: center;">{{ countDownTimes }}</h1>
        </div>
      </h1>

      <div class="w20">
        <el-button color="var(--main-color)"  class="btn-next" @click="this.finishLearn()" :disabled="stopClick"> 
          <v-icon>mdi-check</v-icon>
          Tiếp theo
        </el-button>
      </div>
    </div>

    <div class="body">
      <div class="left-side w80">
        <el-button color="var(--main-color)" @click="speak(`${titleQuestion}`)">
          <v-icon>mdi-volume-high</v-icon>
        </el-button>
      </div>

      <div class="w20"></div>
    </div>

    <div class="learning-wrapper">

      <div class="left-side-learning">

          <div class="options">

            <el-button color="var(--main-color)"
              v-for="(word, index) in randomHasAppear" :key="word" 
              :class="{
                'success-button': isCorrect && selectedIndex === index && !isFalse,
                'error-button': isFalse && selectedIndex === index
              }"
              @click="handleChoose(word, index)"
              :disabled="stopChoosing"
            >
              {{ word }}
            </el-button>

          </div>
      </div>

      <div class="right-side-learning">
      
      </div>

    </div>
</div>
</template>

<script>
import axiosInstance from '../axios'
import { ElNotification } from 'element-plus'


export default {
  props: ['listWord', 'accountID'],

  data(){
    return{
      idTopic: this.$route.params.id,

      arrWords: '',
      vocabID: '',
      levelWord: '',
      titleQuestion: '',
      VN_Meaning:'',
      dataGetFromAPI: [],
      randomHasAppear: [],
      arrayQuestion: [],
      isCorrect: false,
      isFalse: false,
      selectedIndex: -1,
      selectedWord: '',
      countDownTimes: 30,
      stopClick: true,
      stopChoosing: false
    }
  },

  mounted(){
    this.getVocabularyByTopicID(this.idTopic)
    
    this.countDown()
  },

  methods:{
    countDown() {
      let countDown = setInterval(() => {
        this.countDownTimes -= 1;
        if (this.countDownTimes === 0) {
          // this.handleOvertime();
          clearInterval(countDown);
        }
      }, 1000);
    },


    handleOvertime(){
      this.$emit('step-Status', {
        vocabID: this.vocabID,
        level: this.levelWord,
        result: 'overtime'
      });
      this.selectAnswer()
    },

    async getVocabularyByTopicID(topicID){
      this.arrWords = (this.listWord)
      this.handleData() 
    },


    showNotification(title ,message, type){
        ElNotification({
            title: `${title}`,
            message: `${message}`,
            type: `${type}`,
        })
    },

    handleChoose(word, index){
      this.stopClick = false
      this.selectedWord = word
      this.selectedIndex = index;

      this.selectAnswer()
    },

    selectAnswer() {

      const correct = new Audio('../../assets/audio/correct.mp3');
      const wrong = new Audio('../../assets/audio/wrong.mp3');
      
      this.stopChoosing = true

      if(this.selectedWord){
        if (this.selectedWord == this.titleQuestion) {

          this.isCorrect = true;
          this.isFalse = false;
          correct.play();
          this.$emit('step-Status', {
            vocabID: this.vocabID,
            level: this.levelWord,
            result: 'correct'
          });

          const time = setTimeout(() => {
            this.finishLearn();
            clearTimeout(time)
          }, 2000);
          
        } 

        
        else if (this.selectedWord != this.titleQuestion) {

          this.isCorrect = false;
          this.isFalse = true;
          wrong.play();
          this.$emit('step-Status', {
            vocabID: this.vocabID,
            level: this.levelWord,
            result: 'wrong'
          });    

          const time = setTimeout(() => {
              this.finishLearn();
              clearTimeout(time)
          }, 2000);
        }

      }
      else{
        this.$emit('step-Status', {
          vocabID: this.vocabID,
          level: this.levelWord,
          result: 'wrong'
        });  
        const time = setTimeout(() => {
          wrong.play();
          this.finishLearn();
          clearTimeout(time)
        }, 2000);

      }
    },

    speak(word) {
        //set biến đếm để nói 1 lần        
        const listenBtn = document.getElementById('myvoice');
        let numTimesSpoken = 0;

          if (numTimesSpoken < 1) {
            const msg = new SpeechSynthesisUtterance(`${word}`);
            
            window.speechSynthesis.speak(msg);

            numTimesSpoken++;
          }

     },
  

    handleData(){
      const random = Math.floor(Math.random() * this.arrWords.length);

      this.titleQuestion = this.arrWords[random].Word 


      this.VN_Meaning = this.arrWords[random].Vietnamese 

      this.vocabID = this.arrWords[random].VocabID

      this.levelWord = this.arrWords[random].Level

      this.getDataListenAndChoose(this.titleQuestion)

      console.log(this.vocabID, this.levelWord)

    },

    async getDataListenAndChoose(Word){      
        try{
          let result = await axiosInstance.post('getDataListenAndChoose',{
            "Word": `${Word}`
          })

          if(result.status == 200){
            this.dataGetFromAPI.length = 0
            this.dataGetFromAPI.push(...result.data)
            this.handleRandom()     
          }

        }
        catch(error){
            this.showNotification('Thông báo', 'Lấy dữ liệu thất bại', 'error')
        }
    },

    handleRandom(){
        this.randomHasAppear.push(this.titleQuestion)
             
        let valueRandom;
        

        while(this.randomHasAppear.length < 6){
          const random = Math.floor(Math.random() * this.dataGetFromAPI.length);
          valueRandom = this.dataGetFromAPI[random].Word;

          if(!this.randomHasAppear.includes(valueRandom) && valueRandom != this.titleQuestion){
            this.randomHasAppear.push(valueRandom);
          }

        }

        this.handleQuestion()

    },

    handleQuestion(){
      this.randomHasAppear.sort(() => Math.random() - 0.5)
    },

    finishLearn(){
      this.$emit('finish-learn')
    }, 
      
  }
}
</script>

<style lang="scss" scoped>

.container{
  width: 100%;
  padding: 20px 0 0 0 !important;
}
.normal-text{
  font-size: 30px;
  font-weight: normal;
}

.w80{
  width: 80%;
}

.w20{
  flex: 1;
}


.header{
  display: flex;
  height: 120px;


  .el-button{
    font-size: 20px;
    width: 100%;
    height: 100%;
  }

  .left-side {
    display: flex;
    align-items: center; 
    justify-content: space-between;
    padding-right: 5%;
  }

  .timer{
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 40px;
    width: 100px;
    height: 100px;
    border-radius: 50%;
    background-color: var(--main-color);
  }
}

.body{

  .left-side{
    display: flex; 
    justify-content: center;

    .el-button{
      height: 100px;
      width: 100px;
      border-radius: 50%;
    }
  }
  
}


.question-text{
  font-size: 30px;
  font-weight: 600;
  text-align: center;
}

.learning-wrapper{
  display: flex;
  align-items: center;
  width: 100%;

  .left-side-learning{
    width: 80%;

    .options{
      display: flex;
      flex-wrap: wrap;
      justify-content: space-between;


      .el-button {
        font-size: 40px;
        height: 80px;
        margin: 10px 0;
        flex-basis: 40%;
      }
    }
  }

  .right-side-learning{
    flex: 1;
    display: flex;
    justify-content: center;
    align-items: center;

    .level-word{
      width: 200px;
      height: 200px;
      border-radius: 50%;
      display: flex;
      justify-content: center;
      align-items: center;
      box-shadow: rgba(14, 30, 37, 0.12) 0px 2px 4px 0px,var(--main-color) 0px 2px 16px 0px;
    }
  }
}


.success-button {
  background-color: green !important;
  border-color: green  !important;
  color: white !important ;
}

.error-button {
  background-color: red  !important;
  border-color: red  !important;
  color: white !important ;
}

.options{
  .el-button{
    outline: 0;
    &:hover{
      background-color: rgb(77 , 116, 255);
      border-color: rgb(77 , 116, 255);
    }

    &:focus{
      background-color: rgb(77 , 116, 255);
      outline: 0;
      border-color: rgb(77 , 116, 255);
    }

    &:active{
      background-color: rgb(77 , 116, 255);
      outline: 0;
      border-color: rgb(77 , 116, 255);

    }
  }
}

@media screen and (max-width: 900px){
  .header{
    flex-direction: column;

    h1{
      width: 100%;
    }

    .btn-next{
      display: none;
    }
  }

  .body{
    .left-side{
      width: 100% !important;
    }
  }

  .left-side-learning{
    width: 100% !important;

    .options{
      flex-direction: column;
    }
  }

}

</style>