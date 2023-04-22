<template>

<div>
    <el-dialog 
        v-model="showBox"  
        title="Chi tiết chủ đề"
        width="90%"
        fullscreen
        :destroy-on-close="true"
        >

        <div class="addVocab">
          <el-button color="var(--main-color)">Thêm từ vựng</el-button>
        </div>
    

      <el-input v-model="inputTopicName" :placeholder="`${this.inputTopicName}`" @input="this.checkChange()"  />
      <el-input v-model="inputTopicDescribe" :placeholder="`${this.inputTopicDescribe}`" @input="this.checkChange()" />
      <el-divider></el-divider>

        <!-- Data table -->
      <el-table 
        max-height="400px"
        :data="filteredVocab" 
        :default-sort="{ prop: 'TopicID', order: 'ascending' }"
      >

      <el-table-column label="ID" prop="VocabID" width="50" sortable/>
      <el-table-column label="Từ vựng" prop="Word" />
      <el-table-column label="Nghĩa" prop="Vietnamese" />
      <el-table-column label="Miêu tả" prop="VN_Example" />
      <el-table-column label="Nguồn" prop="Resources" />
      <el-table-column align="center">

      <template #header>
        <el-input v-model="search" size="large" placeholder="Nhập từ cần tìm" @input="handleSearch"/>
      </template>

      <template #default="scope">
        <el-button color="var(--main-color)" size="large" @click="handleVocabChoose(scope.row)"
          >Sửa
        </el-button>
        <el-button
          size="large"
          type="danger"
          @click="handleDeleteClass(scope.row.IDCLASS)"
          >Xóa
        </el-button>
      </template>

    </el-table-column>
  </el-table>

      
    <template #footer>
      <div class="dialog-footer">
        <el-button color="danger" size="large" @click="this.showBox = false">Đóng</el-button>

        <el-button color="var(--main-color)" size="large" @click="this.confirmTopic()">
         Xác nhận 
         </el-button>
      </div>
    </template>

  </el-dialog>

  <!-- Detail vocab -->
  <template>
    <el-dialog
        v-model="innerVisible"
        title="Chi tiết từ"
        height="50%"
        width="50%"
        append-to-body
        align-center
      >

       <el-form
       label-width="130px"
      :label-position="labelPosition">
 

      <el-form-item  label="Từ vựng"> 
        <el-input v-model="dataDetailVocab.Word" @input="this.checkChange()" />
      </el-form-item>

      <el-form-item label="Nghĩa">
        <el-input v-model="dataDetailVocab.Vietnamese" @input="this.checkChange()" />
      </el-form-item>

    
      <el-form-item label="Ví dụ tiếng việt">
        <el-input 
        type="textarea"
        v-model="dataDetailVocab.VN_Example" @input="this.checkChange()" />
      </el-form-item>
    
      <el-form-item label="Vị trí">
        <el-input v-model="dataDetailVocab.Position" @input="this.checkChange()" />
      </el-form-item>

       
      <el-form-item label="Lemma">
        <el-input v-model="dataDetailVocab.Lemma" @input="this.checkChange()" />
      </el-form-item>

      <el-form-item label="Loại">
        <el-input v-model="dataDetailVocab.Label" @input="this.checkChange()" />
      </el-form-item>
      
      
      <el-form-item label="Phát âm">
        <el-input v-model="dataDetailVocab.IPA" @input="this.checkChange()" />
      </el-form-item>

      
      <el-form-item label="Câu ví dụ">
        <el-input type="textarea" v-model="dataDetailVocab.Example" @input="this.checkChange()" />
      </el-form-item>

   
      <el-form-item label="Hiển thị">
        <el-switch v-model="dataDetailVocab.Active"  active-text="Hiện" inactive-text="Ẩn" @change="this.checkChange"/>
      </el-form-item>
      
     
      
      <el-form-item label="Cụm từ ">
        <el-input v-model="dataDetailVocab.Cluster" @input="this.checkChange()" />
      </el-form-item>
       
       
      <el-form-item label="Nguồn tham khảo">
        <el-input type="textarea" v-model="dataDetailVocab.Resources" @input="this.checkChange()" />
      </el-form-item>
    </el-form>

      <template #footer>
        <div class="dialog-footer">
          <el-button @click="this.innerVisible = false">Đóng</el-button>

          <el-button type="primary" @click="this.confirmChange()"> Xác nhận </el-button>
        </div>
      </template>


    </el-dialog>

   

  </template>


  </div>
</template>

<script>
import axiosInstance from '../axios'
import { ElNotification } from 'element-plus'


export default {
    props: ['showDetailBox','dataTopic'],
    data(){
        return {
            showBox: true,
            inputTopicName: this.dataTopic.TopicName,
            inputTopicDescribe: this.dataTopic.TopicDescribe,
            topicID: this.dataTopic.TopicID,
            filteredVocab: [],
            innerVisible: false,

            detailVocab: '',
            labelPosition: 'left',

            search: '',
            vocab: '',
            isChange: false,

      

            dataDetailVocab: {
              Word: '',
              Vietnamese: '',
              VN_Example: '',
              Position: '',
              Lemma: '',
              Label: '',
              IPA: '',
              Example: '',
              Active: '',
              Cluster: '',
              Resources:''
            }
        }
    },

    watch:{
        showBox: function(){
            this.$emit('close')
        }
    },

    computed: {
    // Mảng sản phẩm đã lọc theo giá trị tìm kiếm
        filteredVocab() {
          if (!this.search) {
            return this.vocab;
          }
        return this.vocab.filter(vocab => vocab.Word.toLowerCase().includes(this.search.toLowerCase()));
      }
    },

    mounted(){
        this.getDataTableTopic()
    },

    methods: {
        getDataTableTopic(){
            axiosInstance.get(`vocabdetail/topicid=${this.topicID}`)
            .then((res) => {
                this.vocab = res.data
                console.log(this.vocab)
            })         
        },

        showNotification(title ,message, type){
            ElNotification({
                title: `${title}`,
                message: `${message}`,
                type: `${type}`,
            })
        },    

        handleVocabChoose(dataVocabChoose){

          //Tự động gán giá trị data object cùng với data của từ đã chọn
          var keys = Object.keys(dataVocabChoose)
          keys.forEach((data)=>{
            this.dataDetailVocab[data] = dataVocabChoose[data]
          })

          this.innerVisible = true
        },

        // Nếu có input nào thay đổi thì thay đổi thành có sự thành đổi -> không cần phải post lên api mỗi khi ko có xác nhận
        checkChange(){
          this.isChange = true
        },  

        async confirmChange(){
          //Đã có sự thay đổi ô input bất kì
          if(this.isChange){
            let result = await axiosInstance.put('updateVocabByTopicID', {
              "TopicID": parseInt(this.dataDetailVocab.TopicID),
              "VocabID": parseInt(this.dataDetailVocab.VocabID),
              "Word": `${this.dataDetailVocab.Word}`,
              "IPA": `${this.dataDetailVocab.IPA}`,
              "Label": `${this.dataDetailVocab.Label}`,
              "Lemma": `${this.dataDetailVocab.Lemma}`,
              "Vietnamese": `${this.dataDetailVocab.Vietnamese}`,
              "Cluster": `${this.dataDetailVocab.Cluster}`,
              "Position": `${this.dataDetailVocab.Position}`,
              "Example": `${this.dataDetailVocab.Example}`,
              "VN_Example": `${this.dataDetailVocab.VN_Example}`,
              "Resources": `${this.dataDetailVocab.Resources}`,
              "Active": this.dataDetailVocab.Active == true ? 1 : 0
            })

            if(result.status == 200){
              this.showNotification('Thông báo', 'Cập nhật thành công', 'success')
              this.getDataTableTopic()
              this.innerVisible = false
            }
            else{
              this.showNotification('Thông báo', 'Cập nhật không thành công', 'error')
            }


            this.isChange = false

          }
          else{
            this.isChange = false
            console.log('xác nhận chưa thay đổi')
            this.innerVisible = false
          }
        },

        async confirmTopic(){
          if(this.isChange){
            let result = await axiosInstance.put('updateTopic', {
                "TopicID": this.topicID,
                "TopicName": `${this.inputTopicName}`,
                "TopicDescribe": `${this.inputTopicDescribe}`,
            })

            if(result.status == 200){
                this.showNotification('Thông báo', 'Cập nhật chủ đề thành công', 'success')
                this.getDataTableTopic()
                this.showBox = false
                this.$emit('update-data')
            }
            else{
              this.showNotification('Thông báo', 'Cập nhật chủ đề không thành công', 'error')
            }

            this.isChange = false
          }
          else{
            this.isChange = false
            console.log('xác nhận chưa thay đổi')
            this.showBox = false
          }
    
        }
    }
    
}
</script>

<style scoped>
.dialog-footer button:first-child {
  margin-right: 10px;
}


.addVocab{
  margin-bottom: 20px;
}

</style>