<template>
  <div class="container"> 

    <div class="header"> 
      <h1 class="left-side w80 normal-text">
        Điền vào chỗ trống     

        <div class="timer">
          <h1>{{ countDownTimes }}</h1>
       </div>
      </h1>



      <div class="flex1">
        <el-button color="#0038FF"  @click="this.selectAnswer()"> 
          <v-icon>mdi-check</v-icon>
          Chọn
        </el-button>
      </div>
    </div>

    <div>
      <div class="w80 question-area">
        <span class="question-text"> {{  this.replaceWord(`${Example}`)  }} <span>
            <v-tooltip  
              min-width="200px"
              activator="parent"
              location="right"
            >Số lượng kí tự cần điền
            
            </v-tooltip>
            
            <el-button type="primary" bg text="true" size="large" >
              {{ englishWord.length }}
            </el-button>
          </span>
          
        </span>
      
      </div>
      <div class="w20"></div>
    </div>
    
    <div class="learning-wrapper">

      <div class="left-side-learning">

          <div class="options">


            <el-input v-model="inputAnswer" class="input-answer" 
            placeholder="Nhập kết quả của bạn tại đây"
            @keyup.enter="selectAnswer()"   
            >\</el-input>
            
            
            <span class="mention" v-if="mention">
              Gợi ý: 
              <div v-html="`${this.hightlighKeyWord(VN_Example, Vietnamese) }`"></div>
            </span>
          </div>


          <el-button style="min-width: 100px; height: 50px; " type="success" @click="this.mention = true">
            Gợi ý nghĩa tiếng việt (50% điểm của câu)
          </el-button>
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
      Vietnamese: '',
      arrWords: '',
      englishWord: '',
      levelWord: '',
      word: '',
      VN_Meaning:'',
      Example: '',
      VN_Example: '',
      dataGetFromAPI: [],
      randomHasAppear: [],
      arrayQuestion: [],
      isCorrect: false,
      isFalse: false,
      selectedIndex: -1,
      selectedWord: '',
      inputAnswer: '',
      mention: false,
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
        if(this.countDownTimes == 0){
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

      if(this.inputAnswer == this.englishWord){

        if(this.mention == true){
          this.$emit('step-Status', 'mention')
        }
        else{
          this.$emit('step-Status', 'correct')
        }

        this.isCorrect = true;
        this.isFalse = false

        correct.play();

        const time = setTimeout(() => {
          this.finishLearn();
        }, 2000);


      }
      else{
        this.$emit('step-Status', 'wrong')

        this.isFalse = true
        wrong.play()  

        const time = setTimeout(() => {
          this.finishLearn();
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

      this.word = this.arrWords[random].Word 

      this.levelWord =  this.arrWords[random].Level 

      this.englishWord = this.arrWords[random].Word 

      this.Vietnamese = this.arrWords[random].Vietnamese

      this.Example = this.arrWords[random].Example

      this.VN_Example = this.arrWords[random].VN_Example

      console.log(this.arrWords[random])

      this.getDataListenAndChoose(this.word)
    },

    async getDataListenAndChoose(Word){  

        try{
          let result = await axiosInstance.post('getVietnameseMeaning',{
            "Word": `${Word}`,
            "Vietnamese": `${this.Vietnamese}`,
          })

          if(result.status == 200){
            console.log("-----data api")
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
        this.randomHasAppear.push(this.Vietnamese)

        let valueRandom;
        

        while(this.randomHasAppear.length < 4){
          const random = Math.floor(Math.random() * this.dataGetFromAPI.length);
          valueRandom = this.dataGetFromAPI[random].Vietnamese;
          this.randomHasAppear.push(valueRandom);
        }

        this.handleQuestion()

    },

    hightlighKeyWord(inputString, keywords){
      console.log('hightlighKeyWord')

      console.log(inputString, keywords)

      const pattern = new RegExp(`\\b(${keywords.replace(/,/g, '|')})\\b`, 'gi');
       return inputString.replace(pattern, '<strong>$1</strong>');
    },


    replaceWord(Word){
      const replace = Word.replace(`${this.englishWord}`, match => {
        const numDashes = match.length;
        return '  _  '.repeat(numDashes);
      });

      return replace
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
  padding: 0;
  width: 100%;
  height: 100%;
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
    padding-right:5%;
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


.input-answer{
  height: 100px; 
  line-height: 90px; 
}

.mention{
  font-size: 20px;
}
.question-text{
  font-size: 40px;
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
      flex-direction: column;
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