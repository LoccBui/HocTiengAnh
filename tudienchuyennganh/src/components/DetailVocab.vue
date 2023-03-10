<template>

<div>
    <el-dialog 
        v-model="showBox"  
        title="Chi tiết"
        width="90%"
        fullscreen
        :destroy-on-close="true"
        >
    
      <el-input v-model="inputTopicName" :placeholder="`${this.inputTopicName}`" />
      <el-input v-model="inputTopicDescribe" :placeholder="`${this.inputTopicDescribe}`" />
      <el-divider></el-divider>

        <!-- Data table -->
      <el-table 
        :data="dataTableTopic" 
        :default-sort="{ prop: 'TopicID', order: 'ascending' }"
      >

      <el-table-column label="ID" prop="VocabID" width="50" sortable/>
      <el-table-column label="Từ vựng" prop="Word" />
      <el-table-column label="Nghĩa" prop="Vietnamese" />
      <el-table-column label="Miêu tả" prop="VN_Example" />
      <el-table-column label="Tần suất" prop="Frquency" />
      <el-table-column label="Active" prop="Active" />
      <el-table-column label="Nguồn" prop="Resources" />
      <el-table-column align="center">

      <template #header>
        <el-input v-model="search" size="large" placeholder="Nhập tên lớp" />
      </template>

      <template #default="scope">
        <el-button type="primary" size="large" @click="handleVocabChoose(scope.row)"
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
        <el-button @click="this.showBox = false">Đóng</el-button>

        <el-button type="primary" > Xác nhận </el-button>
      </div>
    </template>

  </el-dialog>

  <!-- Detail vocab choose -->
  <template>
    <el-dialog
        v-model="innerVisible"
        width="80%"
        title="Chi tiết từ"
        append-to-body
      >
      <el-input v-model="dataDetailVocab.Word"  />
      <el-input v-model="dataDetailVocab.Vietnamese"  />
      <el-input v-model="dataDetailVocab.VN_Example"  />
      <el-input v-model="dataDetailVocab.Position"  />
      <el-input v-model="dataDetailVocab.Lemma"  />
      <el-input v-model="dataDetailVocab.Label"  />
      <el-input v-model="dataDetailVocab.IPA"  />
      <el-input v-model="dataDetailVocab.Example"  />
      <el-input v-model="dataDetailVocab.Active"  />
      <el-input v-model="dataDetailVocab.Cluster"  />
      <el-input v-model="dataDetailVocab.Resources"  />

      <template #footer>
        <div class="dialog-footer">
          <el-button @click="this.innerVisible = false">Đóng</el-button>

          <el-button type="primary" > Xác nhận </el-button>
        </div>
      </template>


    </el-dialog>

   

  </template>


  </div>
</template>

<script>
import axiosInstance from '../axios'

export default {
    props: ['showDetailBox','dataTopic'],
    data(){
        return {
            showBox: true,
            inputTopicName: this.dataTopic.TopicName,
            inputTopicDescribe: this.dataTopic.TopicDescribe,
            topicID: this.dataTopic.TopicID,
            dataTableTopic: [],
            innerVisible: false,

            detailVocab: '',

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

    mounted(){
        this.getDataTableTopic()
    },

    methods: {
        getDataTableTopic(){
            axiosInstance.get(`/detail/topicid=${this.topicID}`)
            .then((res) => {
                console.log(res.data)
                this.dataTableTopic.push(...res.data)
            })
            
        },

        handleVocabChoose(dataVocabChoose){

          //Tự động gán giá trị data object cùng với data của từ đã chọn
          var keys = Object.keys(dataVocabChoose)
          keys.forEach((data)=>{
            this.dataDetailVocab[data] = dataVocabChoose[data]
          })


          this.innerVisible = true
        }
    }
    
}
</script>

<style scoped>
.dialog-footer button:first-child {
  margin-right: 10px;
}
</style>