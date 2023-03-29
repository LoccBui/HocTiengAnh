<template>
  <div class="container"> 

    <div class="header"> 
      <h1 class="w80">Nghe và chọn kết quả</h1>
      <div class="w20">
        <el-button color="#0038FF"  @click="this.finishLearn()"> 
          <v-icon>mdi-arrow-right-thick</v-icon>
          Tiếp theo 
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
        
        <h5>{{ randomHasAppear }}</h5>
          <div class="options">

            <el-button color="var(--main-color)" 
            v-for="word in randomHasAppear" :key="word" @click="handleChoose(word)">
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
      titleQuestion: '',
      VN_Meaning:'',
      dataGetFromAPI: [],
      randomHasAppear: [],
      arrayQuestion: []
    }
  },

  mounted(){
    this.handleData()
  },

  methods:{

    showNotification(title ,message, type){
        ElNotification({
            title: `${title}`,
            message: `${message}`,
            type: `${type}`,
        })
    },

    handleChoose(word){
      if(word == this.titleQuestion){
        console.log('correct')
      }
      else{
        console.log('false')

      }
    },
  

    handleData(){
      const random = Math.floor(Math.random() * this.listWord.length);
      this.titleQuestion = this.listWord[random].Word 

      this.VN_Meaning = this.listWord[random].Vietnamese 


      this.getDataListenAndChoose(this.titleQuestion)
      this.randomHasAppear.push(this.titleQuestion)


    },

    async getDataListenAndChoose(Word){
        try{
          let result = await axiosInstance.post('getDataListenAndChoose',{
            "Word": `${Word}`
          })

          if(result.status == 200){
            console.log('lấy data thành công')
            console.log(result.data)

            this.dataGetFromAPI.push(...result.data)
            console.log(this.dataGetFromAPI)
            this.handleRandom()     
          }

        }
        catch(error){
            this.showNotification('Thông báo', 'Lấy dữ liệu thất bại', 'error')
            this.$router.push('/topic')

        }
    },

    handleRandom(){
        console.log('----------------------------------')

        console.log('bắt đầu random')
        console.log('data từ API', this.dataGetFromAPI.length)
              
        let valueRandom;
        const random = Math.floor(Math.random() * this.dataGetFromAPI.length);
        valueRandom = this.dataGetFromAPI[random].Word

        console.log("id random: ",  random)

        console.log('từ đã random: ' + valueRandom)
        console.log('từ trong mảng đã có: ' + this.randomHasAppear)
        console.log('độ dài trong mảng đã có: ' + this.randomHasAppear.length)

        if(this.randomHasAppear.length <= 5){
          if(!this.randomHasAppear.includes(valueRandom)){
            console.log('không trùng nên thêm')
            this.randomHasAppear.push(valueRandom)
            console.log("mảng sau thêm", this.randomHasAppear)

            console.log("độ dài sau thêm", this.randomHasAppear.length)
            console.log('thêm xong -> lặp lại')
            this.handleRandom()
         }
         else{
            console.log('bị trùng')
            this.handleRandom()
         }
        }
        else{
          console.log('mảng đã đầy')
          console.log('độ dài trong mảng sau xong: ' + this.randomHasAppear.length)
          this.handleQuestion()

        }

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


</style>