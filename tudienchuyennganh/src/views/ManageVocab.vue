<template>
  <div class="container">
   
    <el-button type="primary" @click="this.optionsAdd = true" size="large" color="var(--main-color)"
      >Thêm chủ đề mới
    </el-button>  

    <el-table 
      :data="filterVocab" 
      :default-sort="{ prop: 'TopicID', order: 'ascending' }"
      empty-text="Không có dữ liệu"
    >

    <el-table-column label="ID" prop="TopicID" width="150" sortable/>
    <el-table-column label="Tên chủ đề" prop="TopicName" />
    <el-table-column label="Miêu tả" prop="TopicDescribe" />
    <el-table-column label="Số từ" prop="QuantityWords" />
    <el-table-column label="Tạo bởi" prop="CreatedBy" />
    <el-table-column align="center">

      <template #header>
        <el-input v-model="search" size="large" placeholder="Nhập tên chủ đề" clearable/>
      </template>

      <template #default="scope">
        <el-button type="primary" color="var(--main-color)" size="large" @click="handleDetail(scope.row)"
          >Chi tiết 
        </el-button>
        <el-button
          size="large"
          type="danger"
          @click="handleDeleteTopic(scope.row.TopicID)"
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
        fullscreen
      >
      <el-input v-model="inputNewTopicName" placeholder="Nhập tên chủ đề">Nhập tên chủ đề muốn tạo</el-input>
      <el-input class="mt-4" v-model="inputTopicDescribe" placeholder="Nhập miêu tả chủ đề" type="textarea">Nhập miêu tả chủ đề</el-input>
      
      <el-divider />

      <el-upload
        class="upload-demo"
        :auto-upload="false"
        :limit="1"
        :action="''"
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

      <el-table :data="tableData" max-width="1000px" max-height="500px">
      <el-table-column prop="Word" label="Word"></el-table-column>
      <el-table-column prop="IPA" label="IPA" ></el-table-column>
      <el-table-column prop="Label" label="Label"></el-table-column>
      <el-table-column prop="Lemma" label="Lemma"></el-table-column>
      <el-table-column prop="Vietnamese" label="Vietnamese" width="250px"></el-table-column>
      <el-table-column prop="Cluster" label="Cluster"></el-table-column>
      <el-table-column prop="Position" label="Position"></el-table-column>
      <el-table-column prop="Example" label="Example" width="400px"	></el-table-column>
      <el-table-column prop="VN_Example" label="VN_Example" width="400px"></el-table-column>
      <el-table-column prop="Resources" label="Resources" width="300px"></el-table-column>
    </el-table>

     <template #footer>
        <div class="dialog-footer">
          <el-button color="var(--main-color)" size="large" @click="addNewTopic()" > Thêm </el-button>
        </div>
      </template>

    </el-dialog>
  </template>




  <AskBox 
      v-if="showAskBox"
      :title="'Bạn có muốn xóa chủ đề này ?'"
      :typeButton="'danger'"
      :btnYes="'Xóa'"
      @confirm="deleteTopic"
      @close="this.showAskBox = false"
  />

  <DetailVocab  
    v-if="showDetailBox"
    :dataTopic="this.detailDataTopic"
    @close="detailHasClosed"
    @update-data="refreshData"
  />

  </div>
</template>

<script>
import { ElNotification } from 'element-plus'

import axiosInstance from '../axios'
import AskBox from '@/components/AskBox.vue'
import DetailVocab from '@/components/DetailVocab.vue'
import * as XLSX from 'xlsx';


  export default {
    components: {AskBox, DetailVocab},
    data () {
      return {
        idTeacher: '',
        
        dataClass: [],
        facultyList: [],
        teacherList: [],
        showAskBox: false,
        showSelectTeacherFaculty: false,
        
        
        // ----
        idTopicDelete: '',
        search: '',
        dataTopicsAPI: '',
        showDetailBox: false,
        detailDataTopic: '',
        inputTopicName: '',
        inputTopicDescribe: '',
        optionsAdd: false,
        addByExcel: false,
        addByDefault: false,
        tableData: [],
        inputNewTopicName: '',
        keyManageVocab: 0,
        
      }
        
    },

    computed: {
        filterVocab(){
          if (!this.search) {
              return this.dataTopicsAPI;
            }
            return this.dataTopicsAPI.filter(cls => cls.TopicName.toLowerCase().includes(this.search.toLowerCase()));
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
              console.log(res.data)
             this.dataTopicsAPI = res.data
            })
        },

      handleDetail(dataDetail){

        this.detailDataTopic = dataDetail

        this.showDetailBox = true

      },

      detailHasClosed(){
        this.showDetailBox = false
      },

      refreshData(){
        this.getDataLocalStorage()
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

      handleDeleteTopic(idTopicChoose){
        this.idTopicDelete = idTopicChoose
        this.showAskBox = true
      },

      async deleteTopic(){
        console.log(this.idTopicDelete)

        let result = await axiosInstance.delete(`/DeleteTopic/${this.idTopicDelete}`)
            
        if (result.status == 200) {
          this.showAskBox = false
          this.getDataLocalStorage() //recall api for refresh topic
          this.showNotification('Hệ thống','Xóa thành công', 'success')
        }
        else{
          this.showNotification('Hệ thống','Xóa không thành công', 'error')
        }
       
      },

      handleABC(index, row){
        console.log("chạy nè",index, row)

          console.log(index,row)
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

      openWith(typeOpen){
        if(typeOpen == 'excel'){
          this.addByExcel = true
        }
        else{
          this.addByDefault = true
        }
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

      async addNewTopic(){
        let quantiyWord = this.tableData.length
        let dataUser = JSON.parse(localStorage.getItem('userInfo'))
        let createdBy = dataUser.name
        let idFaculty = dataUser.IDFACULTY

       try{

          let result = await axiosInstance.post('/addNewTopic',{
              "IdFACULTY": idFaculty,
              "TopicName": `${this.inputNewTopicName}`,
              "TopicDescribe": `${this.inputTopicDescribe}`,
              "QuantityWords": quantiyWord,
              "CreatedBy": `${createdBy}`
          })

          if(result.status == 200) {

            // Nếu tạo chủ đề thành công -> thêm từ vào chủ đề mới tạo
            this.handleAddVocabToTopic(result.data[0].Data)

            this.addByExcel = this.optionsAdd = false       
            this.showNotification('Thông báo', 'Thêm thành công', 'success')
            this.getDataLocalStorage() //recall api for refresh topic
          }
          else{
            this.showNotification('Thông báo', 'Thêm chủ đề không thành công', 'error')
          }

          
       }
       catch(error){
          this.showNotification('Thông báo', 'Thêm chủ đề không thành công', 'error')
       }
      }, 


      async handleAddVocabToTopic(TopicID){
            console.log(TopicID)

            for (var i = 0; i < this.tableData.length; i++){
              console.log(this.tableData[i].Word)
              try{
                let result = await axiosInstance.post('/addVocabToNewTopic',{
                    "TopicID": TopicID,
                    "Word": `${this.tableData[i].Word}`,
                    "IPA": `${this.tableData[i].IPA}`,
                    "Label": `${this.tableData[i].Label}`,
                    "Lemma": `${this.tableData[i].Lemma}`,
                    "Vietnamese": `${this.tableData[i].Vietnamese}`,
                    "Cluster": `${this.tableData[i].Cluster}`,
                    "Position": `${this.tableData[i].Position}`,
                    "Example": `${this.tableData[i].Example}`,
                    "VN_Example": `${this.tableData[i].VN_Example}`,
                    "Resources": `${this.tableData[i].Resources}`
                })
              }
              catch(error){
                this.showNotification('Thông báo', 'Thêm không thành công', 'error')
              }
            }

      },

     

      showNotification(title ,message, type){
            ElNotification({
                title: `${title}`,
                message: `${message}`,
                type: `${type}`,
            })
      },

      
    }
  }
</script>


<style lang="scss" scoped>

.container{
  height: 100vh;

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