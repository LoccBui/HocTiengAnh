<template>
    <div class="container">
     
      <el-button class="mt-4" type="primary" @click="addNewClass()">Thêm lớp</el-button>
     
  
      <el-table 
        :data="dataUsersAPI" 
        :default-sort="{ prop: 'AccountID', order: 'ascending' }"
      >
  
      <el-table-column label="ID" prop="AccountID" width="150" sortable/>
      <el-table-column label="Tài khoản" prop="UserName" />
      
      <el-table-column label="Hoạt động" prop="Active" >
        <template #default="scope">
          <el-switch v-model="scope.row.active"
            >Chi tiết
          </el-switch>
        </template> 
      </el-table-column>

      <!-- :type="scope.row.RoleID === '1' ? '' : 'success'" -->

      <el-table-column 
        label="Vai trò" 
        prop="RoleID" 
        :filters="[
            { text: 'Sinh viên', value: '1' },
            { text: 'Giáo viên', value: '2' },
            { text: 'Admin', value: '3' },
        ]"
        :filter-method="filterHandler"
        >
        <template #default="scope">
          <el-tag
            :type="this.handleTypeTableRole(scope.row.RoleID)"
            >{{ this.handleTableNameRole(scope.row.RoleID) }} 
          </el-tag> 
        </template> 
      </el-table-column>
      
      <el-table-column>
  
        <template #header>
          <el-input v-model="search" size="large" placeholder="Tìm kiếm tài khoản" clearable @keyup="searchUser">
        </el-input>
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
          dataUsersAPI: '',
          showDetailBox: false,
          detailDataTopic: '',
          inputTopicName: '',
          inputTopicDescribe: '',
          
        }
          
      },
  
      mounted(){
        this.changeTitle()

        this.getAllUsers()
        // this.getAllFaculty()
  
        // this.getDataLocalStorage()
  
      },
  
      methods:{
        changeTitle(){
          document.title = "Quản lý người dùng"
        },
  
        //lấy topic theo id user
        getAllUsers(id){
            axiosInstance.get('getAllUsers')
            .then((res) => {
                this.dataUsersAPI = res.data
            })
        },

        handleTypeTableRole(role){
            console.log(role)
            if(role == 1){
                return 'success'
            }
            else if(role == 2){
                return 'danger'
            }
            else{
                return 'primary'
            }
        },

        handleTableNameRole(role){
            if(role == 1){
                return 'Sinh Viên'
            }
            else if(role == 2){
                return 'Giáo viên'
            }
            else{
                return 'Admin'
            }
        },

        
        filterHandler(value, row){
             return row.RoleID == value 
        },

        searchUser(){  
            return this.dataUsersAPI == this.search
        },

        // ------------------
        
        getDataLocalStorage(){
            let dataUser = JSON.parse(localStorage.getItem('userInfo'))
            this.getDataTopic(dataUser.accountID)
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