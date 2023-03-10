<template>

<div>
    <el-dialog 
        v-model="showBox"  
        title="Chi tiết"
        width="90%"
        fullscreen
        :destroy-on-close="true"
        >

    <template #default>
      <el-dialog
        v-model="innerVisible"
        width="30%"
        title="Inner Dialog"
        append-to-body
      />

      <el-input v-model="inputTopicName" :placeholder="`${this.inputTopicName}`" />
      <el-input v-model="inputTopicDescribe" :placeholder="`${this.inputTopicDescribe}`" />
      <el-divider></el-divider>

        <!-- Data table -->
  <el-table 
      :data="dataTableTopic" 
      :default-sort="{ prop: 'TopicID', order: 'ascending' }"
    >

    <el-table-column label="ID" prop="VocabID" width="50" sortable/>
    <el-table-column label="Từ" prop="Word" />
    <el-table-column label="Số từ" prop="Vietnamese" />
    <el-table-column label="Miêu tả" prop="VN_Example" />
    <el-table-column label="Số từ" prop="Frquency" />
    <el-table-column label="Tạo bởi" prop="Active" />
    <el-table-column label="Tên chủ đề" prop="Resources" />
    <el-table-column align="center">

      <template #header>
        <el-input v-model="search" size="large" placeholder="Nhập tên lớp" />
      </template>

      <template #default="scope">
        <el-button type="success" size="large" @click="handleDetail(scope.row)"
          >Chi tiết
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

      
    </template>

    <template #footer>
      <div class="dialog-footer">
        <el-button @click="outerVisible = false">Cancel</el-button>
        <el-button type="primary" @click="innerVisible = true"> Xác nhận </el-button>
      </div>
    </template>

    



  </el-dialog>


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
            dataTableTopic: []
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
            
        }
    }
    
}
</script>

<style scoped>

</style>