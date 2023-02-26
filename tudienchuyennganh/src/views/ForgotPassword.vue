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
                    <v-form
                        ref="form"
                        v-model="valid"
                        lazy-validation
                    >

                        <v-text-field
                            v-model="name"
                            :counter="10"
                            :rules="nameRules"
                            label="Nhập email của bạn"    
                            required
                            >
                        </v-text-field>

                        <v-btn
                            color="primary"
                            block
                            :class="btn-login"
                            @click="sendEmailVerification()"
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
            </div>
        </div>
    </v-app>

</template>

<script>
import emailjs from '@emailjs/browser';


export default {
    data() {
        return {}
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
        
        sendEmailVerification(){

            //1. check email có tồn tại trong hệ thống không  ( != 0 là tồn tại) => lấy thêm username
            //2. Nếu có thì lấy dữ liệu từ input, axios get OTP 

            var emailParams = {
                user_name: 123,
                otp_code: "54682",
                from_name: "Học từ vựng Tiếng Anh",
                user_email: "buihuuloc2001@gmail.com",
            }
            
            emailjs.send(
                `${import.meta.env.VITE_SERVICE_ID}`,
                `${import.meta.env.VITE_TEMPLATE_ID}`, 
                 emailParams, 
                 `${import.meta.env.VITE_PUBLIC_KEY_ID}`)
                .then(function(response) {
                    alert("status" + response.status)
                })
        }
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
    justify-content: space-evenly;

    .heading-text{
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