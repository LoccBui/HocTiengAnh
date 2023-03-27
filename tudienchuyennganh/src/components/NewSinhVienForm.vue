<template>
  <div class="container">
    <el-dialog
    v-model="dialogVisible"
    title="Học từ vựng xin chào ✨"
    width="40%"
    :show-close="false"
    :close-on-press-escape="false"
    :close-on-click-modal="false"
  >
    <span style="line-height: 20px;">
        Có vẻ như bạn là người mới ! Phiền bạn nhập vài thông tin để tụi mình xây dựng bài học cho bạn nhé 💖
    </span>
    
    <el-form :model="form" label-width="120px" :label-position="'left'">


    <el-form-item label="Họ và tên"> 
        <el-input v-model="inputName" placeholder="Tên của bạn" clearable />    
    </el-form-item>

    <el-form-item label="Giới tính"> 
        <el-switch  v-model="gender" size="medium" active-text="Nam" inactive-text="Nữ">Giới tính</el-switch>
    </el-form-item>


    <el-form-item label="Khoa">
        <el-select v-model="selectFaculty"  @change="handleSelectFaculty" :key="refreshFaculty">
            <el-option
                v-for="item in facultyList"
                :key="item.value"
                :label="item.label"
                :value="item.value"
            />
        </el-select>
    </el-form-item>
    

    
    <el-form-item label="Lớp" v-if="showSelectClass">
        <el-select  v-model="selectedClass" @change="handleSelectClass" :key="refreshClass">
            <el-option
                v-for="item in classList"
                :key="item"
                :label="item.label"
                :value="item.value"
            />
         </el-select>
    </el-form-item>

    </el-form>

    <template #footer>
      <span class="dialog-footer">
        <el-button type="primary" @click="confirm()">
          Xác nhận thông tin
        </el-button>
      </span>
    </template>
  </el-dialog>
  </div>
</template>

<script>
import axiosInstance from '../axios'


export default {
    data(){
        return{
            dialogVisible: true,
            gender: 'false',
            inputName: '',

            facultyList: [],            
            selectedFaculty: '',
            
            classList: [],
            selectedClass: '',
          
            showSelectClass: false,
            refreshFaculty: false,
            refreshClass: false
        }
    },

    mounted(){
      this.getFacultyForSelect()
    },

    methods: {
        getFacultyForSelect(){
            axiosInstance.get('SelectAllFaculty')
            .then((res) => {
            
                this.facultyList.length = 0
                
                this.facultyList = res.data.map(item => ({ label: item.FacultyName, value: item.IDFACULTY }))

            })
        },

        handleSelectFaculty(IDFACULTY){
            this.refreshFaculty = !this.refreshFaculty
            this.refreshClass = !this.refreshClass


            // refresh lại sau khi chọn lại khoa
            this.classList.length = 0
            this.selectedClass = ''

            this.showSelectClass = true;
            this.getClassForSelect(IDFACULTY);
        },

        getClassForSelect(IDFACULTY){
            console.log(IDFACULTY)
            axiosInstance.get(`getClassByID/${IDFACULTY}`)
            .then((res) => {
            
                this.classList.length = 0
                
                this.classList = res.data.map(item => ({ label: item.ClassName, value: item.IDCLASS }))

            })
        },

        handleSelectClass(){
            console.log(this.selectedClass)
        },

        confirm(){

            let dataUser = JSON.parse(localStorage.getItem('userInfo'))

            console.log(dataUser)

            console.log("AccountID" , dataUser.accountID)
            console.log("Name" , this.inputName)
            console.log("Gender" , this.gender == false ? 'Nữ': 'Nam')
            console.log("IDCLASS" , this.selectedClass)

            


            //Thiếu : check điều kiện nhập
            // đủ điền kiện mới ko disable nút xác nhận

            // this.addToDatabase()
        },

        async addToDatabase(){
            try{
                let result = axiosInstance.post('addInfoNewSinhVien', {
                    "AccountID": '',
                    "Name": '',
                    "Gender": '',
                    "IDCLASS": ''
                })
            }
            catch(error){

            }
            
        }
    }
}
</script>

<style lang="scss" scoped>

.el-select{
    width: 100%;
}

.el-form{
    margin-top: 5%;
}

.dialog-footer{
    .el-button{
        width: 100%;
    }
}

.input-cover{
    border: 1px solid black;
    padding: 10px;
}
</style>