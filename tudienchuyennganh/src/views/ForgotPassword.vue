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

                        <v-alert
                            v-if="alertNotHaveEmail"
                            color="error"
                            icon="$success"
                            text="Email của bạn chưa được đăng kí trong hệ thống"
                            max-height="70px"
                        ></v-alert>

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
                        <Timer :time="120" />

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

import Timer from '@/components/Timer.vue';


export default {
    components: {Timer},
    data() {
        return {
            valid: false, 
            alertNotHaveEmail: false,
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
            notShowTimer: true
        }
    },

    mounted() {
        this.changeTitle()
    },

    methods:{
        changeTitle(){
            document.title = "Quên mật khẩu"
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
                    this.alertNotHaveEmail = true

                    setTimeout(() => {
                        this.alertNotHaveEmail = false 
                    }, 3000);
                }
            }
        },

        async generateOTPForEmail(accountID){
            let result = await axiosInstance.get(`generateOTP/${accountID}`)
            if(result.status == 200){
                console.log(result.data[0].OTPCode)
                this.notShowTimer = !this.notShowTimer
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
    height: 100vh;
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
    #frame-cover{
        display: flex;
        flex-direction: column;
    }

    .frame-left{
        width: 100%;
        display: flex;
        justify-content: center;

        .brand-logo-img{
            width: 100%;
        }
    }   
}


</style>