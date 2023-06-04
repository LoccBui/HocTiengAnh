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

          <div class="word" v-for="word,index in dataReview" :key="index">        
                <div>
                  <h3> {{ word.Word }} </h3>          
                  <h3> {{ word.Vietnamese }} </h3>  
                </div>  

                <div class="btn-cover" >

                    <el-button
                        title="Lưu vào bộ từ mặc định" color="var(--main-color)"  
                        @click="handleShowPersonCollection(word)" v-if="!word.isAdded && WordExists.length > 0 && index < WordExists.length  &&  word.VocabID != WordExists[index].VocabExists"
                        >
                      Thêm vào bộ từ của tôi
                    </el-button>

                  <el-button title="Đã thêm" color="var(--main-color)"  v-if="word.isAdded && WordExists.length > 0 && index < WordExists.length && word.VocabID != WordExists[index].VocabExists">
                    Đã thêm
                  </el-button>
                  

                  <el-button type="primary" disabled color="green" v-if=" WordExists.length > 0 && index < WordExists.length && word.VocabID == WordExists[index].VocabExists">
                    Đã có trong bộ từ
                  </el-button>

                  <el-button title="Chọn bộ từ khác" color="var(--main-color)" size="small" @click="openPersonalCollection(word)">...</el-button>

                </div>
          </div>

        </div>
      </div>
      
      <div class="ranking-cover" >
        <div class="leader-board">
          <h1 class="main-text" > Bảng xếp hạng</h1>
          
          <div class="loading" v-loading="loading" element-loading-text="Chưa có dữ liệu..." element-loading-background="#e6ebff">
          
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
    </div>
    
    Gợi ý cho bạn
    <div>
      <el-button size="large" color="var(--main-color)" @click="this.$router.push('/topic')">Quay về học từ</el-button>
    </div>


    <el-dialog
      class="personCollectionBox"
      v-model="personCollection"
      title="Chọn bộ từ cá nhân của bạn"
      width="auto"
      :before-close="handleClose"
    >

    
    <div v-if="notHaveCollectionWarn">
      <h1 class="warning-text">Bạn chưa có bộ từ vựng của riêng mình</h1>
    </div> 
    
    
    <div class="collection-cover">
      <el-button v-for="collection in arrCollection" :key="collection" class="collection" @click="chooseCollectionToAdd(collection)">
        <div class="w80">
          {{ collection.PersonalVocabName }}
        </div>

        <div class="w20 defaul-word" v-if="collection.IsDefault == true" >Mặc định</div>

      </el-button>


    </div>
    
    <template #footer>    
      <div class="btn-create-new">
       <el-button color="var(--main-color)" size="large" >Tạo mới 
        <v-icon>mdi-plus</v-icon>
       </el-button>
      </div>
    </template>
    </el-dialog>

  </div>
</template>

<script>
import axiosInstance from '@/axios';
import { ElNotification } from 'element-plus'
import Cookies from 'js-cookie';

export default {
    props: ['dataReview', 'idTopic', 'totalScore'],
    data(){
        return{
            listRanking: '',
            loading: true,
            personCollection: false,
            notHaveCollectionWarn: false,
            AccountID: '',
            arrCollection: [],
            isAdded: false,

            defaultCollection: '',
            defaultPersonalVocabID: '',

            WordExists: [],
            arrWordExists: [],
            selectedVocabID: ''
          }
    },

    mounted(){
      this.handleDataLocal()
      this.getDefaultCollection()
      this.getRanking()
    },


    methods:{
      showNotification(title ,message, type){
          ElNotification({
              title: `${title}`,
              message: `${message}`,
              type: `${type}`,
          })
      },
      

      handleDataLocal(){
        let dataUser = JSON.parse(Cookies.get('userInfo'))
        this.AccountID = dataUser.accountID
      },

      async getRanking(){
        let result = await axiosInstance.post('rankingTopic',{
          "TopicID": this.idTopic
        })

        if(result.status == 200){
          this.loading = false
          this.listRanking=(result.data)
        }
      },

      async getDefaultCollection(){
        try{
          let result = await axiosInstance.post('getPersonalCollection',{
            "AccountID": this.AccountID
          })

          if(result.status == 200){
            this.arrCollection = result.data

            this.defaultCollection = this.arrCollection.filter(item => item.IsDefault === true)

            this.defaultPersonalVocabID = this.defaultCollection[0].PersonalVocabID

            this.CheckWordExistInPersonalCollection()
          }
        }
        catch(ex) {
          this.notHaveCollectionWarn = true
        }
      },


      CheckWordExistInPersonalCollection(){
        // Dùng promise để đảm bảo response trả về đúng thứ tự, dùng async sẽ response theo kết quả nào trả về nhanh hơn
        const promises = this.dataReview.map(word => {
            return axiosInstance.post('wordExists', {
              "PersonalVocabID": this.defaultPersonalVocabID,
              "VocabID": word.VocabID,
              "AccountID": this.AccountID
            })
          })

          Promise.all(promises).then(responses => {
            this.WordExists = responses.map(res => res.data[0])
          })
      },

      handleShowPersonCollection(word){
        this.getPersonCollection(word)
      },

      async getPersonCollection(word){
      

        try{
          let result = await axiosInstance.post('getPersonalCollection',{
            "AccountID": this.AccountID
          })

          if(result.status == 200){
            this.arrCollection = result.data
            this.addToPersonalVocab(word)
          }
        }
        catch(ex) {
          this.notHaveCollectionWarn = true
        }
      },

      async addToPersonalVocab(word){

        const filterDefault = this.arrCollection.filter(item => item.IsDefault === true)

        try{
          let result = await axiosInstance.post('addToPersonalVocab',{
            "PersonalVocabID": filterDefault[0].PersonalVocabID,
            "VocabID": word.VocabID,
            "AccountID": this.AccountID
         })

         if(result.status == 200){
            word.isAdded = true;
            this.$forceUpdate();
            this.showNotification('Thông báo', 'Thêm thành công', 'success')
         }

        }
        catch(e){
          this.showNotification('Thông báo', 'Thêm không thành công', 'error')

        }        
      },


      addToSelectedCollection(PersonalVocabID){
          axiosInstance.post('addToPersonalVocab',{
            "PersonalVocabID": PersonalVocabID,
            "VocabID": this.selectedVocabID,
            "AccountID": this.AccountID
          })

          .then( () => {
            this.$forceUpdate();
            this.showNotification('Thông báo', 'Thêm thành công', 'success')
          })
          
          .catch( () => {
            this.showNotification('Thông báo', 'Thêm không thành công', 'error')
          })
      },


      handleClose(){
        this.personCollection = false
      },

      openPersonalCollection(word){

        this.selectedVocabID = word.VocabID
        console.log(word)
        
        this.personCollection = true
      },


      chooseCollectionToAdd(data){
        console.log(data)
        this.addToSelectedCollection(data.PersonalVocabID)

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
      align-items: center;
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

  .loading{
    height: 400px;
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

    .btn-cover{
      display: flex;
      align-items: center;

      .el-button{
        padding: 20px;
      }
    }
  }  
}

.el-dialog{
  border-radius: 20px !important;

  .warning-text{
    font-size: 30px;
  }

  .btn-create-new{
    .el-button{
      width: 100%;
      border-radius: 5px !important;
    }

    &:hover{
        color: white;
    }
  }

}

.collection-cover{
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: space-between;

    .collection{
      padding: 10%;
      width: 100%;
      margin: 0;
      
      &:hover{
        color: white;
      }
      
      .defaul-word{
        font-weight: 800;
      }
    }

    .collection + .collection{
      margin-top: 4%;
    }

  }

  
@media screen and (max-width: 900px){
    .table-cover{
      flex-direction: column;
    }

    .word-cover,
    .ranking-cover{
      width: 100% !important;
      margin: 10px 0 !important;;
    }
}

</style>