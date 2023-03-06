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
          <v-btn color="red" @click="deleteClass(item.IDCLASS)"> Xóa </v-btn>
        </td>
      </tr>
    </tbody>
  </v-table>


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
            ></v-select>

            <v-btn color="primary" block>Thêm</v-btn>
            <v-btn color="success" block>Import Excel</v-btn>

          </v-card-text>

          <v-card-actions>          
            <v-btn color="error" block @click="dialog = false">Đóng</v-btn>
          </v-card-actions>
        </v-card>
    </v-dialog>
  </div>

  </div>
</template>

<script>
import axiosInstance from '../axios'


  export default {
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

        facultyList: [
            'CNTT',
            'Dược',
            'Marketing'
        ]

        
      }
        
    },

    mounted(){
      this.getAllClasses()



    },

    methods:{
 
      getAllClasses(){
        // let dataUser  = JSON.parse(localStorage.getItem('userInfo'))
        // console.log(dataUser)

        axiosInstance.get('SelectAllClasses')
            .then(res => this.handleData(res.data))
      },


      handleData(data){
        console.log("data", data)
        
          this.dataClass.push(...data)
          console.log(this.dataClass)
      },

      deleteClass(idClass){
        alert(idClass)
      },

      addNewClass(){
        this.dialog = true
      }

      
      
    }
  }
</script>


<style lang="scss" scoped>
.container{
    padding: 50px;
}
</style>