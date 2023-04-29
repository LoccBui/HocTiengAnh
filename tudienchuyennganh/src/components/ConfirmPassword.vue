<template>
    <div class="container">
      <el-dialog
          v-model="dialogVisible"
          title="Yêu cầu xác thực"
          width="40%"
          :show-close="false"
          :close-on-press-escape="false"
          :close-on-click-modal="false"
      >
  
      <span style="line-height: 30px; font-size: 20px;">
          Bạn vừa chọn thêm giáo viên
        <br>
          <b>Hành động này yêu cầu xác thực </b>
        <br>
          Vui lòng nhập mật khẩu tài khoản của bạn
      </span>
  
      <el-form  
      ref="ruleFormRef"
      :model="ruleForm"
      :rules="rules"
      status-icon
      label-width="30%" :label-position="'left'" >
  
  
      <el-form-item label="Tài khoản hiện tại" > 
         <h1>{{ Username }}</h1>
      </el-form-item>

      <el-form-item label="Mật khẩu" prop="password" > 
          <el-input
              v-model="ruleForm.password" 
              type="password"
              show-password	
              
          />  
      </el-form-item>
  
    </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button type="primary" @click="confirm()">
            Xác thực
          </el-button>
        </span>
      </template>
    </el-dialog>
    </div>
  </template>
  
  <script>
  import axiosInstance from '../axios'
  import { ElNotification } from 'element-plus'
  import Cookies from 'js-cookie';

  
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

              Email: '',
              Username: '',
  
              // form
  
              ruleForm : {
                  password:''
              },
  
              rules: {
                  password: [{ required: true, message: 'Bạn cần nhập mật khẩu', trigger: 'blur' }],
              }       
  
          }
      },
  
      mounted(){
        this.getEmailUser()
      },
  
      methods: {
  
          showNotification(title ,message, type){
              ElNotification({
                  title: `${title}`,
                  message: `${message}`,
                  type: `${type}`,
              })
          },

          async getEmailUser(){
            let dataUser = JSON.parse(Cookies.get('userInfo'))
            this.Email = dataUser.email

            let result = await axiosInstance.post('getUsername',{
                "Email": `${this.Email}`
            })
               
            if(result.status == 200){
                this.Username = result.data[0].Username
            }
          },
  
          async confirm(){

              await  this.$refs.ruleFormRef.validate((valid) => {
                  if (valid) {
                    this.authenUser()
                  } else {
                      this.$message.error('Dữ liệu còn thiếu.');
                      return false;
                  }
              });
  
          },

          async authenUser(){
            try{
                let result = await axiosInstance.post(`/login/${this.Username}/${this.ruleForm.password}`)
                    if (result.status == 200 && result.data[0].AccountID != 0) {
                        this.$emit('authenticate', true)
                    }
                    else{
                        this.$emit('authenticate', false)

                    }
                } 

            catch{
                this.showNotification('Thông báo', 'Tài khoản hoặc mật khẩu không chính xác', 'error')
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