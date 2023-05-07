<template>
    <v-app>
        <div id="container">
            <!-- Khung bao img và form -->
            <div id="frame-cover">

                <div class="frame-left">
                    <img class="brand-logo-img" src="../../assets/gif/forgot-pass.gif" alt="LHU logo">
                </div>

                <div class="frame-right">
                    <h1 class="heading-text"> QUÊN MẬT KHẨU </h1>

                    <div v-if="notShowTimer">

                        <v-form
                            ref="form"
                            v-model="valid"
                            @submit.prevent="handleEmail()"
                        >

                            <v-text-field
                                v-model="emailInput" :rules="emailRules"
                                :counter="10"            
                                label="Nhập email của bạn"    
                                required
                                autofocus

                                @keyup.enter="handleEmail()"
                                >
                            </v-text-field>

                            <v-btn
                                color="primary"
                                block
                                @click="handleEmail()"
                                > Lấy lại mật khẩu  
                            </v-btn>
                        
                        </v-form>

                        <span class="navigate">
                            <h3>
                                <a class="primary-text-color hover-pointer"
                                @click="moveToLogin"> Quay về trang đăng nhập </a>  
                            </h3>
                        </span>     
                    </div>

                    <div  v-else-if="showInputOTP">
                        <Timer 
                        :key="refreshKey"
                        :time="120"
                        @confirm-OTP="confirmOTP"              
                        @refreshNewOTP="refreshNewOTP"
                        :accountID ="this.accountID"
                        :wrongOTP="this.wrongOTP"

                        />

                        <div class="navigate-otp">
                            <h3>
                                <a class="primary-text-color hover-pointer"
                                @click="moveToLogin"> Quay về trang đăng nhập </a>  
                            </h3>
                        </div>  
                        
                    </div>

                    <div v-else>
                        <el-form  
                            ref="ruleFormRef"
                            :model="ruleForm"
                            :rules="rules"
                            status-icon
                            :label-position="'left'" >

                            <el-form-item prop="newPassword" >
                                <el-input prop="inputNewPassword" size="large"   show-password
                                v-model="ruleForm.newPassword" placeholder="Mật khẩu mới"   />
                            </el-form-item>

                            <el-form-item prop="confirmNewPasword" >
                                <el-input prop="inputConfirmNewPassword" size="large"   show-password
                                v-model="ruleForm.confirmNewPasword" placeholder="Xác nhận mật khẩu"   />
                            </el-form-item>
                         </el-form>

                         <div class="confirm-btn">
                            <el-button  
                             style="width: 100%;"
                             color="var(--main-color)" 
                             size="large" @click="changePassword()">
                             Thay đổi mật khẩu</el-button>
                        </div>
                    </div>


                </div>


                
                
            </div>
            
        </div>
    </v-app>

</template>

<script>
import emailjs from '@emailjs/browser';
import axiosInstance from '../axios'
import { ElNotification } from 'element-plus'

import Timer from '@/components/Timer.vue';


export default {
    components: {Timer},
    data() {
        return {
            valid: false, 
            emailInput: '', 
            emailFilter: '',
            accountID: '',
            emailTail: '@gmail.com',
            emailRules: [
                v => !!v || 'Bạn cần nhập email',
                v => (v && v.length > 0) || 'Email không được để trống',
                v => (v && v.length > 10) || 'Email không được dưới 10 kí tự',
                v => !v || /^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/.test(v) || 'Email không hợp lệ'
            ],

            // timer
            notShowTimer: true,

            //otp
            wrongOTP: 0,
            refreshKey: 0,

            //new password
            ruleForm : {
                inputNewPassword: '',
                inputConfirmNewPassword: ''
            },

            rules: {
                newPassword: [{ required: true, message: 'Bạn cần mật khẩu mới', trigger: 'change' }],
                confirmNewPasword: [{ required: true, message: 'Bạn cần nhập xác nhận mật khẩu', trigger: 'change' }],
            }    
        }
    },

    created(){
        document.title = "Quên mật khẩu"

    },

    mounted() {
    },

    methods:{
        showNotification(title ,message, type){
            ElNotification({
                title: `${title}`,
                message: `${message}`,
                type: `${type}`,
            })
         },

        moveToLogin(){
            this.$router.push('/')
        },

        refreshNewOTP(){
            this.refreshKey++
            // this.sendEmailVerification()
        },

        async handleEmail(){
            // Điều kiện: - Form not break rule, not empty input, match email suffix
            if (this.valid && this.emailInput != '' && this.emailInput.matchAll('@gmail.com')) {
                this.emailFilter = this.emailInput.replace('@gmail.com', '') 
                    this.sendEmailVerification()   
            }

            else {
                const { valid } = await this.$refs.form.validate()
            }
        },
  
        
        async sendEmailVerification(){
            let result = await axiosInstance.get(`getEmail/${this.emailFilter}`)
            if(result.status == 200){
                this.accountID = result.data[0].AccountID
                //Have account in database
                if(this.accountID != 0){
                    this.generateOTPForEmail(this.accountID)
                }
                else{
                    this.showNotification('Thông báo', 'Email không tồn tại trong hệ thống', 'error')
                }
            }
        },

        generateOTPForEmail(accountID){
           axiosInstance.get(`generateOTP/${accountID}`)

           .then( (result) => {
              this.notShowTimer = !this.notShowTimer
              this.showInputOTP = true
              this.sendEmailToUser(result.data[0])
           })           

        },

        //handle value OTP value confirm
        async confirmOTP(data){
            let result = await axiosInstance.get(`verify/${this.accountID}/${data}`)

            if(result.status == 200){

                if(result.data[0].VerifyStatus == 200){
                    this.showInputOTP = this.notShowTimer = false
                    this.$forceUpdate()
                }
                else{
                    this.wrongOTP+=1
                }
            
            }
        },


        async changePassword(){

            await  this.$refs.ruleFormRef.validate((valid) => {
            if (valid) {
                try{
                    if(this.ruleForm.newPassword != this.ruleForm.confirmNewPasword){
                        this.showNotification('Thông báo', 'Mật khẩu không trùng nhau', 'error')
                    }
                    else{

                        axiosInstance.post('changePassword', {
                            "Password": `${this.ruleForm.confirmNewPasword}`,
                            "AccountID": this.accountID
                        })

                        .then(() => {
                            this.showNotification('Thông báo', 'Đổi mật khẩu thành công', 'success')
                            this.$router.push('/login')
                        })
                    }

                }
                catch(e){
                    this.showNotification('Thông báo', 'Thêm không thành công', 'error')
                }  

            } else {
                this.$message.error('Dữ liệu còn thiếu.');
                return false;
            }
            });
        },

        sendEmailToUser(data){

            // Send OTP to email have verified 
            var emailParams = {
                user_name: `${data.Name}`,
                otp_code: `${data.OTPCode}`,
                from_name: "Học từ vựng Tiếng Anh",
                user_email: `${this.emailInput}`,
            }
            
            emailjs.send(
            `${import.meta.env.VITE_SERVICE_ID}`,
            `${import.meta.env.VITE_TEMPLATE_ID}`, 
                emailParams, 
            `${import.meta.env.VITE_PUBLIC_KEY_ID}`)

            .then(() => {
                this.showNotification('Thông báo', 'Đã gửi OTP', 'success')
            })
            
        }

        

    

            
            
    }
}   
</script>

<style lang="scss" scoped>
#container{
    width: 80%;
    margin: 0 auto;
    display: flex;
    align-items: center;
}

#frame-cover{
    width: 100%;
    min-height: 80%;
    display: flex;
}

/* Khung trái chiếm 50% */
.frame-left{
    width: 50%;
    display: flex;
    align-items: center;

    .brand-logo-img{
       width: 100%;
    }
}



.frame-right{
    flex: 1;
    display: flex;
    flex-direction: column;
    justify-content: center;
    .heading-text{
        margin-bottom: 10%;
        font-size: 40px;
        color: var(--main-color);
        text-align: center;
        cursor: default;
    }

    .forgot-pass-text{
        padding: 5% 0px;
        color: var(--gray-text);
        text-align: end;
    }

    .navigate{
        display: flex;
        justify-content: space-evenly;
    }
}

.navigate-otp{
    width: 100%;
    margin-top: 50px;
    text-align: center;
}


@media screen and (max-width: 900px){

    #container{
        height: 100%;
        margin: 0 auto;
    }

    #frame-cover{
        display: flex;
        flex-direction: column;
    }

    .frame-left{
        width: 100%;
        display: flex;
        justify-content: center;

        .brand-logo-img{
            width: 50%;
        }
    }   

    .navigate{
        margin-top: 50px;
        font-size: 20px;
    }
}


</style>