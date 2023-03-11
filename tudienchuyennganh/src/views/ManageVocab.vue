<template>
  <div class="container">
   
    <el-button class="mt-4" type="primary" @click="addNewClass()"
    >Thêm từ vựng</el-button> 

    <el-table 
      :data="dataTopicsAPI" 
      :default-sort="{ prop: 'TopicID', order: 'ascending' }"
    >

    <el-table-column label="ID" prop="TopicID" width="150" sortable/>
    <el-table-column label="Tên chủ đề" prop="TopicName" />
    <el-table-column label="Miêu tả" prop="TopicDescribe" />
    <el-table-column label="Số từ" prop="QuantityWords" />
    <el-table-column label="Tạo bởi" prop="CreatedBy" />
    <el-table-column align="center">

      <template #header>
        <el-input v-model="search" size="large" placeholder="Nhập tên lớp" />
      </template>

      <template #default="scope">
        <el-button type="primary" size="large" @click="handleDetail(scope.row)"
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




  <AskBox 
      v-if="showAskBox"
      :title="'Bạn có muốn xóa lớp này ?'"
      @confirm="deleteClass"
      @close="this.showAskBox = false"
  />

  <DetailVocab  
    v-if="showDetailBox"
    :dataTopic="this.detailDataTopic"
    @close="detailHasClosed"
  />

  </div>
</template>

<script>
import { ElMessage } from 'element-plus'
import axiosInstance from '../axios'
import AskBox from '@/components/AskBox.vue'
import DetailVocab from '@/components/DetailVocab.vue'
  export default {
    components: {AskBox, DetailVocab},
    data () {
      return {
        search: '',
        idTeacher: '',
        searchString: "",
        dialog: false,

        dataClass: [],
        facultyList: [],
        idClassDelete: '',
        teacherList: [],
        showAskBox: false,
        showSelectTeacherFaculty: false,


        // ----
        dataTopicsAPI: [],
        showDetailBox: false,
        detailDataTopic: '',
        inputTopicName: '',
        inputTopicDescribe: '',
        
      }
        
    },

    mounted(){
      this.getAllClasses()
      this.getAllFaculty()

      console.log('mn vocab: mounted')
      this.changeTitle()
      this.getDataLocalStorage()

    },

    methods:{
      changeTitle(){
        document.title = "Quản lý từ vựng"
      },

      getDataLocalStorage(){
          let dataUser = JSON.parse(localStorage.getItem('userInfo'))
          this.getDataTopic(dataUser.accountID)
      },

      //lấy topic theo id user
      getDataTopic(id){
            axiosInstance.get(`getTopic/${id}`)
            .then((res) => {
             this.dataTopicsAPI.push(res.data[[0]])
            })
        },

      handleDetail(dataDetail){

        this.detailDataTopic = dataDetail

        this.showDetailBox = true

      },

      detailHasClosed(){
        this.showDetailBox = false

      },

      // ---------------

 
      getAllClasses(){
        axiosInstance.get('SelectAllClasses')
            .then(res => this.handleData(res.data))
      },


      //set data for v-table
      handleData(data){        
        this.dataClass.length =0
          this.dataClass.push(...data)
      },

      handleDeleteClass(idClassChoose){
        this.idClassDelete = idClassChoose
        this.showAskBox = true
      },

      async deleteClass(){

        let result = await axiosInstance.delete(`/DeleteClass/${this.idClassDelete}`)
            
        if (result.status == 200) {
           this.getAllClasses()
          this.showAskBox = false
          this.showMessage('Xóa thành công', 'success')

        }
       
      },
      handleABC(index, row){
        console.log("chạy nè",index, row)

          console.log(index,row)
      },



      addNewClass(){
        this.dialog = true
      },

      getAllFaculty(){
        // add faculty name to v-select
        axiosInstance.get('SelectAllFaculty')
            .then((res) => {
              for(let i = 0; i < res.data.length; i++){
                this.facultyList.push(res.data[i].FacultyName)
              }
            })
      },
      
      selectFaculty(data){
        this.showSelectTeacherFaculty = true
        axiosInstance.post(`getTeacherByFaculty/${data}`)
        .then((res)=> {
          this.teacherList.length = 0
          for(let i = 0; i < res.data.length; i++){
              this.teacherList.push(res.data[i].Name)
          
           }
        })
         
      },

      handleEdit(index, row){
        console.log("chạy nè",index, row)
      },

      filterHandler(value, row){
          // console.log(value, row.FacultyName)
          // console.log(value.FacultyName === value )
          return row.FacultyName === value 
      },

      showMessage(message, type){
        ElMessage({
          message: `${message}`,
          type: `${type}`,
          effect:"dark"
        })
      }

      
    }
  }
</script>


<style lang="scss" scoped>
.container{
    padding: 50px;
}

.el-dialog{

  .el-input + .el-input{
    margin-top: 20px;
  }
}



</style>