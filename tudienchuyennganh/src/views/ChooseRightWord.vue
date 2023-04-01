<template>
    <div class="container"> 
  
      <div class="header"> 

        <h1 class="left-side w80 normal-text">
          Chọn đúng từ

          <div class="timer">
            <h1>{{ countDownTimes }}</h1>
          </div>
        </h1>

        

        <div class="w20">
          <el-button color="#0038FF"  @click="this.selectAnswer()"> 
            <v-icon>mdi-check</v-icon>
            Chọn
          </el-button>
        </div>
      </div>
  
      <div>
        <div>
          <h2 class="w80 question-text">{{ VN_Meaning }}</h2>
        </div>
        <div class="w20"></div>
      </div>
  
      <div class="learning-wrapper">
  
        <div class="left-side-learning">
  
            <div class="options">
  
              <el-button color="var(--main-color)"
              v-for="(word, index) in randomHasAppear" :key="word" @click="handleChoose(word, index)"
              :class="{ 'success-button': isCorrect === true && selectedIndex === index && isFalse === false, 'error-button': isFalse === true && selectedIndex === index }"
              >
                {{ word }}
              </el-button>
  
            </div>
        </div>
  
        <div class="right-side-learning">
          <div class="level-word">
           <img :src="`../../assets/img/learning/level${this.levelWord}.png`" alt="Level Word">
          </div>
        </div>
  
      </div>
  </div>
  </template>
  
  <script>
import axiosInstance from '../axios'
import { ElNotification } from 'element-plus'
  
  
  export default {
    data(){
      return{
        idTopic: this.$route.params.id,
  
        arrWords: '',
  
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
      }
    },
  
    mounted(){
      this.getVocabularyByTopicID(this.idTopic)
      
      this.countDown()
    },
  
    methods:{
      countDown(){
        let countDown = setInterval(()=>{
          this.countDownTimes -= 1
          if(this.countDownTimes === 0){
            clearInterval(countDown)
            this.handleOvertime()
          }
        },1000)
      },

      handleOvertime(){
        this.$emit('step-Status', 'overtime')
        this.selectAnswer()
      },

      async getVocabularyByTopicID(topicID){
        let result = await axiosInstance.get(`/learning/topicid=${topicID}`)
  
        if(result.status == 200){
          this.arrWords = (result.data)
          this.handleData()
        }       
      },
  
  
      showNotification(title ,message, type){
          ElNotification({
              title: `${title}`,
              message: `${message}`,
              type: `${type}`,
          })
      },
  
      handleChoose(word, index){
        this.isCorrect = false;
        this.isFalse = false
  
  
        this.selectedWord = word
        this.selectedIndex = index;
        this.speak(word)
      },
  
      selectAnswer(){
  
        const correct = new Audio('../../assets/audio/correct.mp3');
        const wrong = new Audio('../../assets/audio/wrong.mp3');
  
        if(this.selectedWord == this.titleQuestion){

          this.$emit('step-Status', 'correct')

          this.isCorrect = true;
          this.isFalse = false
  
          correct.play();
  
          const time = setTimeout(() => {
            this.finishLearn();
            clearTimeout(time)
          }, 2000);

          
        }
        else if(this.selectedWord != this.titleQuestion){
          this.$emit('step-Status', 'wrong')

          this.isFalse = true
          wrong.play()  
          this.finishLearn();
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
  
        this.levelWord =  this.arrWords[random].Level 
  
        this.getDataListenAndChoose(this.titleQuestion)
  
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
            this.randomHasAppear.push(valueRandom);
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
  
  .container{
    width: 100%;
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
      background-color: #0038FF;
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
        box-shadow: rgba(14, 30, 37, 0.12) 0px 2px 4px 0px,#0038FF 0px 2px 16px 0px;
      }
    }
  }
  
  
  .success-button {
    background-color: green;
    border-color: green;
  }
  
  .error-button {
    background-color: red;
    border-color: red;
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
  
  </style>