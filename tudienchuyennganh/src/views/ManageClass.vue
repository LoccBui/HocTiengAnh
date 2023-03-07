<template>
  <div class="container">
 
    <div>
      <v-btn color="primary" @click="addNewClass()">Thêm lớp mới</v-btn>
    </div>

    <v-card
    class="mx-auto"
    color="grey-lighten-3"
    max-width="400"
  >
    <v-card-text>
      <v-text-field
        :loading="loading"
        density="compact"
        variant="solo"
        label="Search templates"
        append-inner-icon="mdi-magnify"
        single-line
        hide-details
        @click:append-inner="onClick"
      ></v-text-field>
    </v-card-text>
  </v-card>

    <v-table>
    <thead>
      <tr>

        <th class="text-left" v-for="item in headers" :key="item">
          {{ item.title }}
        </th>

      </tr>
    </thead>

    <tbody>
      <tr v-for="item in dataClass"
        :key="item.IDCLASS"> 
        <td>{{ item.IDCLASS}}</td>  
        <td>{{ item.ClassName }}</td>    
        <td>{{ item.FacultyName  }}</td>    
        <td>
          <v-btn color="error" @click="handleDeleteClass(item.IDCLASS)"> Xóa </v-btn>
        </td>
      </tr>
    </tbody>
  </v-table>

  <AskBox 
      v-if="showAskBox"
      :title="'Bạn có muốn xóa lớp này ?'"
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
              :items="facultyList"
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
import axiosInstance from '../axios'
import AskBox from '@/components/AskBox.vue'

  export default {
    components: {AskBox},
    data () {
      return {
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

        showAskBox: false,
        showSelectTeacherFaculty: false
        
      }
        
    },

    mounted(){
      this.getAllClasses()
      this.getAllFaculty()
    },

    methods:{
 
      getAllClasses(){
        // let dataUser  = JSON.parse(localStorage.getItem('userInfo'))
        // console.log(dataUser)

        axiosInstance.get('SelectAllClasses')
            .then(res => this.handleData(res.data))
      },


      //set data for v-table
      handleData(data){        
          this.dataClass.push(...data)
      },

      handleDeleteClass(idClassChoose){
        this.idClassDelete = idClassChoose
        this.showAskBox = true
      },

      async deleteClass(){

        let result = await axiosInstance.delete(`/DeleteClass/${this.idClassDelete}`)
            
        if (result.status == 200) {
            location.reload()
        }
       
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
        console.log(data)
        this.showSelectTeacherFaculty = true
      }

      
      
    }
  }
</script>


<style lang="scss" scoped>
.container{
    padding: 50px;
}
</style>