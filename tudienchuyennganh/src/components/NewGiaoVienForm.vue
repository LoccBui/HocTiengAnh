<template>
  <div class="container">
    <el-dialog
        v-model="dialogVisible"
        width="40%"
        :show-close="false"
        :close-on-press-escape="false"
        :close-on-click-modal="false"
    >

    <template #header>
        <h1 class="title-text">Học từ vựng xin chào ✨</h1>
    </template>

    <span style="line-height: 30px; font-size: 20px;">
       Có vẻ như bạn là người mới ! Nhờ bạn nhập vài thông tin để tụi mình xây dựng bài học cho bạn nhé 💖
    </span>

    <el-form  
    ref="ruleFormRef"
    :model="ruleForm"
    :rules="rules"
    status-icon
    label-width="20%" :label-position="'left'" >

        <el-form-item label="Họ và tên" prop="name" > 
            <el-input
                v-model="ruleForm.name" 
                clearable   
            />  
        </el-form-item>

        <el-form-item label="Giới tính"> 
            <el-switch  v-model="gender" size="medium" active-text="Nam" inactive-text="Nữ">Giới tính</el-switch>
        </el-form-item>

        <el-form-item label="Khoa" prop="faculty">
        <el-select v-model="ruleForm.faculty"  @change="handleSelectFaculty"
            placeholder="Khoa">
                <el-option
                    v-for="item in facultyList"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value"
                />
            </el-select>
        </el-form-item>
        
    
        <el-form-item label="Lớp chủ nhiệm" v-if="showSelectClass" prop="class">
            <el-select  v-model="ruleForm.class" @change="handleSelectClass" 
            placeholder="Lớp chủ nhiệm">
                <el-option
                    v-for="item in classList"
                    :key="item"
                    :label="item.label"
                    :value="item"
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
import { ElNotification } from 'element-plus'


export default {
    data(){
        return{
            dialogVisible: true,
            gender: 'false',         
            facultyList: [],            
            
            classList: [],
            showSelectClass: false,
            refreshFaculty: false,
            refreshClass: false,

            // form

            ruleForm : {
                inputName: '',
                faculty: '',
                class: ''
            },

            rules: {
                name: [{ required: true, message: 'Bạn cần nhập họ tên', trigger: 'blur' }],
                faculty: [{required: true, message: 'Bạn cần chọn khoa',trigger: 'change'}],
                class: [{required: true, message: 'Bạn cần chọn lớp', trigger: 'change'}],
            }       

        }
    },

    mounted(){
        this.getFacultyForSelect()
    
    },

    methods: {

        showNotification(title ,message, type){
            ElNotification({
                title: `${title}`,
                message: `${message}`,
                type: `${type}`,
            })
        },

        getFacultyForSelect(){
            axiosInstance.get('SelectAllFaculty')
            .then((res) => {
            
                this.facultyList.length = 0
                
                this.facultyList = res.data.map(item => ({ label: item.FacultyName, value: item.IDFACULTY }))

            })
        },

        handleSelectFaculty(IDFACULTY){
            this.refreshFaculty = !this.refreshFaculty


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


        async confirm(){
            // valid thành công
            await  this.$refs.ruleFormRef.validate((valid) => {
                if (valid) {
                     this.addToDatabase()             
                } else {
                    console.log('chưa valid')
                    this.$message.error('Dữ liệu còn thiếu.');
                    return false;
                }
            });

        },

        async addToDatabase(){
            let dataUser = JSON.parse(localStorage.getItem('userInfo'))

            

            try{


                let addToGiaoVien = await axiosInstance.post('addInfoNewGiaoVien', {
                    "AccountID": dataUser.accountID,
                    "Name": `${this.ruleForm.name}`,
                    "Gender": `${this.gender == false ? 'Nữ': 'Nam'}`,
                })

                let MaGV = addToGiaoVien.data[0].MaGV


                let addToClass =  await axiosInstance.post('addGiaoVienToClass', {
                    "ClassName": `${this.ruleForm.class.label}`, 
                    "MaGV": MaGV,
                    "IDFACULTY":this.ruleForm.faculty 
                })


              
                if(addToClass.status == 200 && addToGiaoVien.status == 200){

                     this.getDataUser(dataUser.accountID)
                }
            }
            catch(error){
                this.showNotification('Thông báo', 'Thêm không thành công', 'error')

            }
            
        },


        async getDataUser(idUser){
            let res = await axiosInstance.get(`/user/id=${idUser}`)
           

                let dataUser = {
                    accountID: '',
                    email: '',
                    name: '',
                    MaGV: '',
                    IDFACULTY: '', 
                    Role: '',
                }
                
                       
                dataUser.accountID = res.data[0].AccountID
                dataUser.email = res.data[0].Email
                dataUser.name = res.data[0].Name
                dataUser.MaGV = res.data[0].MaGV || 0
                dataUser.IDFACULTY = res.data[0].IDFACULTY
                dataUser.Role = res.data[0].Priority

                localStorage.setItem('userInfo', JSON.stringify(dataUser))
                localStorage.setItem('isNew', false)
                    
                this.$emit('finish-update-information')

            
        },  
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


.title-text{
    font-size: 30px;
    font-weight: 500;
}
</style>