<template>
  <div class="container"> 

    <div class="header"> 
      <h1 class="w80">Nghe và chọn kết quả</h1>
      <div class="w20">
        <el-button color="#0038FF"  @click="this.finishLearn()" > 
          <v-icon>mdi-arrow-right-thick</v-icon>
          Tiếp theo 
        </el-button>

        <el-button color="green"  @click="this.selectAnswer()"> 
          <v-icon>mdi-check</v-icon>
          Chọn
        </el-button>
      </div>
    </div>

    <div>
      <div>
        <h2 class="w80 question-text">{{ VN_Meaning }}</h2>
        <h2 class="w80 question-text">Kết quả: {{ titleQuestion }}</h2>
      </div>
      <div class="w20"></div>
    </div>

    <div class="learning-wrapper">

      <div class="left-side-learning">

        <h3>{{ this.dataGetFromAPI }}</h3>
        <h1>----------------</h1>
        
        <h5>{{ randomHasAppear }}</h5>
          <div class="options">

            <el-button color="var(--main-color)"
            v-for="(word, index) in randomHasAppear" :key="word" @click="handleChoose(word, index)"
            :class="{ 'success-button': isCorrect === true && selectedIndex === index, 'error-button': isCorrect === false && selectedIndex === index }"
            >
              <v-icon> mdi-volume-high </v-icon>
              {{ Word }}
            </el-button>

          </div>
      </div>

      <div class="right-side-learning">
        level 2
      </div>

    </div>
</div>
</template>

<script>
import axiosInstance from '../axios'
import { ElNotification } from 'element-plus'


export default {
  props: ['listWord'],

  data(){
    return{
      idTopic: this.$route.params.id,

      arrWords: '',

      titleQuestion: '',
      VN_Meaning:'',
      dataGetFromAPI: [],
      randomHasAppear: [],
      arrayQuestion: [],
      isCorrect: false,
      selectedIndex: -1,
      selectedWord: ''
    }
  },

  mounted(){
    this.getVocabularyByTopicID(this.idTopic)

    console.warn('---listen and choose')
    // this.handleData()

  },

  methods:{

    async getVocabularyByTopicID(topicID){
      let result = await axiosInstance.get(`/learning/topicid=${topicID}`)

      if(result.status == 200){
        this.arrWords = (result.data)

        console.log('data đã get', this.arrWords)
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
      this.selectedWord = word
      this.selectedIndex = index;
      console.log(this.selectedWord)

      this.speak(word)
      
    },

    selectAnswer(){

      const correct = new Audio('../../assets/audio/correct.mp3');
      const wrong = new Audio('../../assets/audio/wrong.mp3');


      if(this.selectedWord == this.titleQuestion){
        this.isCorrect = true;

        correct.play();

        setTimeout(() => {
          this.finishLearn();
        }, 2000);

      }
      else{
        wrong.play()  
        this.isCorrect = false;
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
      console.info('--> xử lí handle data')
      console.log(this.arrWords[0])

      const random = Math.floor(Math.random() * this.arrWords.length);

      this.titleQuestion = this.arrWords[random].Word 

      this.VN_Meaning = this.arrWords[random].Vietnamese 


       this.getDataListenAndChoose(this.titleQuestion)
      // this.randomHasAppear.push(this.titleQuestion)


    },

    async getDataListenAndChoose(Word){
        console.log(Word)
      
        try{
          let result = await axiosInstance.post('getDataListenAndChoose',{
            "Word": `${Word}`
          })

          if(result.status == 200){
            console.log('lấy data thành công')
            this.dataGetFromAPI.length = 0
            this.dataGetFromAPI.push(...result.data)
            this.handleRandom()     
          }

        }
        catch(error){
            this.showNotification('Thông báo', 'Lấy dữ liệu thất bại', 'error')
            // this.$router.push('/topic')

        }
    },

    handleRandom(){
        console.log('----------------------------------')

        console.log('bắt đầu random')
        console.log('từ đã có: ', this.dataGetFromAPI)
        console.log('độ dài list từ API', this.dataGetFromAPI.length)

        this.randomHasAppear.push(this.titleQuestion)
              
        let valueRandom;
        

        while(this.randomHasAppear.length < 6){
          const random = Math.floor(Math.random() * this.dataGetFromAPI.length);
          valueRandom = this.dataGetFromAPI[random].Word;
          this.randomHasAppear.push(valueRandom);
        }

        console.log('--> xong ', this.randomHasAppear)
        this.handleQuestion()

    },

    handleQuestion(){
      console.log('xử lí random câu hỏi')
      console.log('mảng ban đầu', this.randomHasAppear)
      
      console.log('mảng sau sort', this.randomHasAppear.sort(() => Math.random() - 0.5))
    },

    finishLearn(){
        console.log('emit')
        this.$emit('finish-learn')
    }, 
      
  }
}
</script>

<style lang="scss" scoped>
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
  height: 80px;

  .el-button{
    width: 100%;
    height: 100%;
  }
}


.question-text{
  font-size: 20px;
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
  }
}


.success-button {
  background-color: green;
}

.error-button {
  background-color: red;
}

</style>