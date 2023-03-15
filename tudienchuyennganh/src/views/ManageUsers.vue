<template>
    <div class="container">
     
      <el-button class="mt-4" type="primary" @click="this.optionsAdd = true">Thêm tài khoản mới</el-button>
     
      <el-table 
        :data="dataUsersAPI" 
        :default-sort="{ prop: 'AccountID', order: 'ascending' }"
      >
  
      <el-table-column label="ID" prop="AccountID" width="150" sortable/>
      <el-table-column label="Tài khoản" prop="UserName" />
      
      <!-- <el-table-column label="Hoạt động" prop="Active" >
        <template #default="scope">
          <el-switch v-model="scope.row.active"
            >Chi tiết
          </el-switch>
        </template> 
      </el-table-column> -->


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
            @click="handleDeleteUser(scope.row.AccountID)"
            >Xóa
          </el-button>
        </template>
  
      </el-table-column>
    </el-table>


    <el-dialog v-model="optionsAdd" title="Chọn hình thức thêm">
      <div class="options-container">
        <div class="option-area">
          <el-button type="success" @click="openWith('excel')">
            <v-icon class="option-icon">mdi-microsoft-excel</v-icon>
            Thêm qua excel
          </el-button>
        </div>

        <div class="option-area">
          <el-button type="primary" @click="openWith('default')">
            <v-icon class="option-icon">mdi-plus-thick</v-icon>
            Thêm thủ công
          </el-button>         
        </div>
      </div>
  </el-dialog>


  <!-- Add By Excel -->
  <template>
    <el-dialog
        v-model="addByExcel"
        width="50%"
        title="Thêm bằng Excel"
        append-to-body
      >

      <el-upload
        ref="upload"
        class="upload-demo"
        :limit="1"
        drag
        :on-change="handleUpload"
        :before-upload="beforeUpload"
      >
        <v-icon style="font-size: 80px;">mdi-progress-upload</v-icon>

        <div class="el-upload__text">
          Thả file ở đây hoặc <em>chọn file</em>
        </div>

        <template #tip>
          <div class="el-upload__tip">
            Chỉ chọn 1 file (dạng xls)
          </div>
        </template>

      </el-upload>

      <el-table :data="tableData" style="width: 100%">
      <el-table-column prop="id" label="ID"></el-table-column>
      <el-table-column prop="name" label="Name"></el-table-column>
      <el-table-column prop="age" label="Age"></el-table-column>
      <el-table-column prop="gender" label="Gender"></el-table-column>
    </el-table>

     <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" size="large" @click="addNewUserByDefault()" > Thêm </el-button>
        </div>
      </template>

    </el-dialog>
  </template>

  <!-- Add By default -->
  <template>
    <el-dialog
        v-model="addByDefault"
        width="50%"
        title="Thêm thủ công"
        append-to-body
      >
     
      <el-input v-model="inputNewUsername" size="large" placeholder="Nhập tài khoản" />
      <el-input v-model="inputNewPassword" size="large" placeholder="Nhập mật khẩu" />
      <el-input v-model="inputNewEmail" size="large" placeholder="Nhập email" />

      
      <div>
        <el-select  v-model="value"  placeholder="Quyền truy cập" size="large" clearable >
        <el-option
          v-for="item in optionsRole"
          :key="item.value"
          :label="item.label"
          :value="item.value"
        />
      </el-select>
      </div>

      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" size="large" @click="addNewUserByDefault()"> Thêm </el-button>
        </div>
      </template>


    </el-dialog>
  </template>
  
  
  
    <AskBox 
        v-if="showAskBox"
        :title="'Bạn có muốn xóa tài khoản này ?'"
        @confirm="deleteUser"
        @close="this.showAskBox = false"
    />
  

  
    </div>
  </template>
  
  <script>
  import { ElMessage } from 'element-plus'
  import { ElNotification } from 'element-plus'

  import axiosInstance from '../axios'
  import AskBox from '@/components/AskBox.vue'
  import DetailVocab from '@/components/DetailVocab.vue'
  import * as XLSX from 'xlsx';

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
          optionsAdd: false,
          addByExcel: false,
          addByDefault: false,
          tableData: [],

          inputNewEmail: '',
          inputNewPassword: '',
          inputNewRoleID: '1',
          inputNewUsername: '',

          idNeedDelete: '',

          optionsRole: [
            {
              value: 'admin',
              label: 'Admin',
            },
            {
              value: 'user',
              label: 'Sinh viên',
            },
            {
              value: 'teacher',
              label: 'Giáo viên',
            },
          ] 
        }
          
      },
  
      mounted(){
        this.changeTitle()
        this.getAllUsers()
  
      },
  
      methods:{
        changeTitle(){
          document.title = "Quản lý tài khoản"
        },

        showNotification(title ,message, type){
            ElNotification({
                title: `${title}`,
                message: `${message}`,
                type: `${type}`,
            })
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

        openWith(typeOpen){
            if(typeOpen == 'excel'){
              this.addByExcel = true
            }
            else{
              this.addByDefault = true
            }
        },

        loadUploadedFile(file){
            console.log(file)
        },

        handleDeleteUser(idChoose){
          this.idNeedDelete = idChoose
          this.showAskBox = true
          
        }, 

        async deleteUser(){
          try{
              axiosInstance.delete(`/DeleteUser/${this.idNeedDelete}`)
              .then((res) => {
                  if(res.status == 200) {
                    this.showNotification('Thông báo', 'Xóa thành công', 'success')
                    this.showAskBox = false
                    this.getAllUsers()
                  }       
              })

          }
          catch{
            this.showNotification('Thông báo', 'Xóa không thành công', 'error')
          }

        },  

        async addNewUserByDefault(){
          let result = await axiosInstance.post('/addNewUser',{
              "Username": `${this.inputNewUsername}`,
              "Password": `${this.inputNewPassword}`,
              "Email": `${this.inputNewEmail}`,
              "RoleID": `${this.inputNewRoleID}`
          })

          if(result.status == 200){
              this.showNotification('Thông báo', 'Thêm tài khoản mới thành công', 'success')
              this.getAllUsers()
              this.inputNewEmail = this.inputNewPassword = this.inputNewUsername = ''
          }

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

        // Handle upload file 
        handleUpload(file) {
          const reader = new FileReader()
          reader.onload = (e) => {
            const data = new Uint8Array(e.target.result)
            const workbook = XLSX.read(data, { type: 'array' })
            const sheetName = workbook.SheetNames[0]
            const worksheet = workbook.Sheets[sheetName]
            const jsonData = XLSX.utils.sheet_to_json(worksheet)
            this.tableData = jsonData
            console.log(this.tableData)
          }
          reader.readAsArrayBuffer(file.raw)
        },
        
        //handle file is excel or not
        beforeUpload(file) {
          const isExcel =
            file.type === 'application/vnd.ms-excel' ||
            file.type ===
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
          if (!isExcel) {
            this.showNotification('Hệ thống','Chỉ chấp nhận định dạng Excel', 'error')
          }
          return isExcel
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

  .options-container{
    display: flex;
    align-items: center;
    justify-content: center;
    width: 100% ;
    height: 200px;
  }

  .option-area{
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    width: 50%;
    height: 100%;
    font-size: 50px;


    .el-button{
      width: 100%;
      height: 100%;
    }

    .option-icon{
      font-size: 50px;
     
    }
  }

  .el-select{
    margin-top: 20px;
    width: 100%;
  }

  .dialog-footer{


    .el-button{
      width: 100%;
    }
  }
  
  
  
  
  </style>