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

                    <div  v-else>
                        <Timer :time="120"
                        @confirm-OTP="confirmOTP"
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
            wrongOTP: 0
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
           })           
        },


        async confirmOTP(data){
            let result = await axiosInstance.get(`verify/${this.accountID}/${data}`)

            if(result.status == 200){

                if(result.data[0].VerifyStatus == 200){
                    alert('move to change password')
                }
                else{
                    alert('wrong otp')
                    this.wrongOTP+=1
                    console.log(this.wrongOTP)
                }
            
            }


        }

            
            // Generate OTP for account -> sp_GenerateOTP

            // Send OTP to email have verified 
            // var emailParams = {
            //     user_name: 123,
            //     otp_code: "54682",
            //     from_name: "Học từ vựng Tiếng Anh",
            //     user_email: "buihuuloc2001@gmail.com",
            // }
            
            // emailjs.send(
            //     `${import.meta.env.VITE_SERVICE_ID}`,
            //     `${import.meta.env.VITE_TEMPLATE_ID}`, 
            //      emailParams, 
            //      `${import.meta.env.VITE_PUBLIC_KEY_ID}`)
            //     .then(function(response) {
            //         alert("status" + response.status)
            //     })
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