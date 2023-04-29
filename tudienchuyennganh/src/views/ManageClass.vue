<template>
  <div class="container">
   
    <el-button class="mt-4" color="#1565C0" @click="openOptionAddClass()"
    >Thêm lớp</el-button> 


  <el-table 
    :data="filterClass" 
    :default-sort="{ prop: 'IDCLASS', order: 'ascending' }"
    empty-text="Không có dữ liệu"
  >

    <el-table-column label="Mã lớp" prop="IDCLASS" width="150" sortable/>
    <el-table-column label="Tên lớp" prop="ClassName" />
    <el-table-column 
      label="Khoa" 
      prop="FacultyName" 
      sortable
      :filters="[
        { text: 'Công Nghệ Thông Tin', value: 'Công Nghệ Thông Tin' },
        { text: 'Dược', value: 'Dược' }
      ]"
      :filter-method="filterHandler"

      />

    <el-table-column align="center">

      <template #header>
        <el-input v-model="search" size="large" placeholder="Nhập tên lớp"  clearable/>
      </template>

      <template #default="scope">
        <el-button color="#1565C0" size="large" @click="handleShowDetail(scope.row)"
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


  <!-- Option box -->
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
        title="Thêm lớp bằng Excel"
        append-to-body
        fullscreen
        destroy-on-close	
      >
      <el-input v-model="inputNewTopicName" placeholder="Nhập tên chủ đề">Nhập tên chủ đề muốn tạo</el-input>
      <el-input v-model="inputTopicDescribe" placeholder="Nhập miêu tả chủ đề">Nhập miêu tả chủ đề</el-input>
      
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

      <el-table :data="tableData" max-width="1000px" max-height="500px" 
      empty-text="Chưa có dữ liệu"
      >
        <el-table-column prop="ClassName" label="Tên lớp"></el-table-column>
        <el-table-column prop="Faculty" label="Khoa" ></el-table-column>
     </el-table>

     <template #footer>
        <div class="dialog-footer">
          <el-button color="var(--main-color)" size="large" @click="addNewClass()" > Thêm </el-button>
        </div>
      </template>

    </el-dialog>
  </template>




  <AskBox 
      v-if="showAskBox"
      :title="'Bạn có muốn xóa lớp này ?'"
      :typeButton="'danger'"
      :btnYes="'Xóa'"
      @confirm="deleteClass"
      @close="this.showAskBox = false"
  />

  <DetailClass 
      v-if="showDetailClass"
      :dataClass="this.detailClass"
      @close="detailHasClosed"
      @update-data="refreshData"
  />



  </div>
</template>

<script>
import { ElNotification } from 'element-plus'

import axiosInstance from '../axios'
import AskBox from '@/components/AskBox.vue'
import DetailClass from '@/components/DetailClass.vue'
import { requireTokenMixin } from '@/mixin/requireTokenMixin'

import * as XLSX from 'xlsx';


  export default {
    components: {AskBox, DetailClass},
    mixins:[requireTokenMixin],

    data () {
      return {
        search: '',
        idTeacher: '',
        searchString: "",
        headers: [
          {title: "Mã Lớp"},
          {title: "Tên Lớp"},
          {title: "Khoa"},
          {title: "Hành động"},
        ],

        dataClass: [],
        facultyList: [],
        idClassDelete: '',
        teacherList: [],
        showAskBox: false,
        showSelectTeacherFaculty: false,

        showDetailClass: false,
        detailClass: '',

        optionsAdd: false,
        addByExcel: false,
        addByDefault: false,
        tableData: [],

        
      }
        
    },

    mounted(){
      this.changeTitle()

      this.getAllClasses()
      this.getAllFaculty()
    },

    computed: {
      filterClass(){
        if (!this.search) {
            return this.dataClass;
          }
          return this.dataClass.filter(cls => cls.ClassName.toLowerCase().includes(this.search.toLowerCase()));
      }
    },

    methods:{
      changeTitle(){
          document.title = "Quản lý lớp"
      },

      showNotification(title ,message, type){
            ElNotification({
                title: `${title}`,
                message: `${message}`,
                type: `${type}`,
            })
        },
 
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
          this.showNotification('Hệ thống','Xóa thành công', 'success')

        }else{
          this.showNotification('Hệ thống','Xóa thất bại', 'error')

        }
       
      },

      handleShowDetail(classDetail){
         this.detailClass = classDetail

         this.showDetailClass = true

      },

      

      detailHasClosed(){
        this.showDetailClass = false    
      },

      openOptionAddClass(){
        this.optionsAdd = true
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

      async addNewClass(){

        if( this.tableData.length > 0 ){

          for (var i = 0; i < this.tableData.length; i++){
              console.log(this.tableData[i].ClassName)
              console.log(this.tableData[i].Faculty)
              try{
                let result = await axiosInstance.post('newClass',{
                    "ClassName": `${this.tableData[i].ClassName}`,
                    "FacultyName": `${this.tableData[i].Faculty}`,            
                })

                if(result.status == 200){
                  this.addByExcel = false
                  this.getAllClasses()
                  this.getAllFaculty()
                  this.optionsAdd = false
                }
              }
              catch(error){
              }
            }
        }
        else{
          this.$message.error('Chưa có dữ liệu excel');
        }

       
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
      
      
    }
  }
</script>


<style lang="scss" scoped>
.container{
  height: 100vh;
}


// Option Add
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


.dialog-footer{
  .el-button{
    width: 100%;
  }
}

</style>