<template>
  <div class="container">
   
    <el-button class="mt-4" color="var(--main-color)" @click="addNewClass()"
    >Thêm lớp</el-button> 


  <el-table 
    :data="dataClass" 
    :default-sort="{ prop: 'IDCLASS', order: 'ascending' }"
  >

    <el-table-column label="Mã lớp" prop="IDCLASS" width="150" sortable/>
    <el-table-column label="Tên lớp" prop="ClassName" />
    <el-table-column 
      label="Khoa" 
      prop="FacultyName" 
      sortable
      :filters="[
        { text: 'CNTT', value: 'CNTT' },
        { text: 'Dược', value: 'Dược' }
      ]"
      :filter-method="filterHandler"

      />

    <el-table-column align="center">

      <template #header>
        <el-input v-model="search" size="large" placeholder="Nhập tên lớp" />
      </template>

      <template #default="scope">
        <el-button color="var(--main-color)" size="large" @click="handleABC(scope.$index, scope.$row)"
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



  <el-divider></el-divider>

  <AskBox 
      v-if="showAskBox"
      :title="'Bạn có muốn xóa lớp này ?'"
      :typeButton="'danger'"
      :btnYes="'Xóa'"
      @confirm="deleteClass"
      @close="this.showAskBox = false"
  />


  <div>
      <v-dialog
        v-model="dialog"
        width="auto"
        transition="dialog-bottom-transition"
      >
        <v-card width="500px" >
          <v-card-text>

            <v-text-field 
             label="Tên lớp"
             placeholder="Nhập tên lớp"
             variant="outlined"
             focused
             /> 

             <v-select
              label="Chọn khoa"
              :items="facultyList"
              @update:modelValue="selectFaculty"
            ></v-select>

            <v-select
              v-show="showSelectTeacherFaculty"
              label="Giáo viên chủ nhiệm"
              :items="teacherList"
            ></v-select>

            <v-btn color="primary" block>Thêm</v-btn>
            <v-btn  color="success" block>Import Excel</v-btn>

          </v-card-text>

          <v-card-actions>          
            <v-btn color="error" variant="flat" block @click="dialog = false">Đóng</v-btn>
          </v-card-actions>
        </v-card>
    </v-dialog>

  </div> 

  </div>
</template>

<script>
import { ElMessage } from 'element-plus'
import axiosInstance from '../axios'
import AskBox from '@/components/AskBox.vue'
  export default {
    components: {AskBox},
    data () {
      return {
        search: '',
        idTeacher: '',
        searchString: "",
        dialog: false,
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
        showSelectTeacherFaculty: false
        
      }
        
    },

    computed:{
     
    },

    mounted(){
      this.changeTitle()

      this.getAllClasses()
      this.getAllFaculty()
    },

    methods:{
      changeTitle(){
          document.title = "Quản lý lớp"
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
  padding: 5% 0;
}
</style>