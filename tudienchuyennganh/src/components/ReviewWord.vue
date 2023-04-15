<template>
  <div class="container">
    
    <div class="heading">
      <h1 class="main-text">   Bạn vừa hoàn thành bài học !  </h1>
    </div>
  
    <div>Tổng điểm bạn nhận được: {{ totalScore }}</div>


    <div class="table-cover">

      <div class="word-cover">

        <h1 class="main-text"> Bạn vừa học...</h1>

        <div class="scrolling">

          <div class="word" v-for="word in dataReview" :key="word.VocabID">        
                <div>
                  <h3> {{ word.Word }} </h3>          
                  <h3> {{ word.Vietnamese }} </h3>  
                </div>  
                
                <div>
                  <el-button color="var(--main-color)">Thêm vào từ của tôi</el-button>
                </div>
          </div>

        </div>
      </div>
      
      <div class="ranking-cover">
        <div class="leader-board">
          <h1 class="main-text"> Bảng xếp hạng</h1>
          
          <div class="scrolling">
            <div v-for="user in listRanking" :key="user.AccountID" class="detail-user">
                <div class="left-side">
                  <span>
                    <el-avatar :src="`../../assets/img/avatar/${user.Image}.png`" class="avatar"/>
                  </span>
                  <span class="user-name">{{ user.Name }}</span>
                </div>

                <div>{{ user.TotalScore }}</div>
            </div>
          </div>  

        </div>
      </div>  
    </div>
    
    Gợi ý cho bạn
    <div>
      <el-button size="large" color="var(--main-color)">Quay về học từ</el-button>
    </div>

  </div>
</template>

<script>
import axiosInstance from '@/axios';

export default {
    props: ['dataReview', 'idTopic', 'totalScore'],
    data(){
        return{

            listRanking: '',
        }
    },

    mounted(){
      this.getRanking()
    },


    methods:{
      async getRanking(){
        console.log("topic id =", this.idTopic)

        let result = await axiosInstance.post(`ranking/topicid=${this.idTopic}`)

        if(result.status == 200){
          console.log(result.data)
          this.listRanking=(result.data)
        }
      }
    }
}
</script>

<style lang="scss" scoped>
.container{
  width: 100%;
}

.heading{
  display: flex;
  justify-content: center;
  background-color: #e5e5f7;
  opacity: 0.8;
  background-image: radial-gradient(circle at center center, #0038FF, #e5e5f7), repeating-radial-gradient(circle at center center, #0038FF, #0038FF, 10px, transparent 80px, transparent 40px);
  background-blend-mode: multiply;
  .main-text{
    font-size: 30px;
  }
}


.main-text{
    font-size: 30px;
    color: white;
  }



.table-cover{
  display: flex;

  .word-cover,
  .ranking-cover{
    width: 50%;
    padding: 2%;
    border-radius: 15px;
    box-shadow: rgba(0, 0, 0, 0.24) 0px 3px 8px;
    background-color: var(--tints-20);
  }

  .scrolling{
    max-height: 400px;
    overflow-y: scroll;

  }


  .ranking-cover{
    margin-left: 2%;
    flex: 1;
    display: flex;
    flex-direction: column;
  }

  .leader-board{
    
    .detail-user{
      
      background-color: white;
      display: flex;
      justify-content: space-between;
      border-bottom: 1px solid var(--main-color);
      padding: 2%;
      color: var(--main-color);


      .left-side{
        display: flex;
        align-items: center;
        height: 50px;
        width: 40%;

        .user-name{
          margin-left: 10%;
        }
      }

    }
  }


  .word-cover{
    border: 1px solid transparent;
  }

  .word{
    background-color: white;
    padding: 2%;
    color: var(--main-color);
    display: flex;
    justify-content: space-between;
    border-bottom: 1px solid var(--main-color);
  }
}

</style>