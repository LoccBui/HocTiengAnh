<template>
    <v-app>
        <div id="container">

            <!-- Khung bao img và form -->
            <div id="frame-cover">

                <div class="frame-left">
                    <img class="brand-logo-img" src="../assets/gif/time-learn-en.gif" alt="LHU logo">
                </div>

                <div class="frame-right">
                    <h1 class="heading-text"> ĐĂNG NHẬP </h1>
                    <v-form
                        ref="form"
                        v-model="valid"
                        lazy-validation
                    >

                        <v-text-field
                        v-model="username" :rules="usernameRules"
                            :counter="10"
                            label="Nhập email của bạn"    
                            suffix="@gmail.com"
                            required
                            >
                        </v-text-field>

                        <v-text-field
                        v-model="password" :rules="passwordRules"
                            :counter="10"
                            :type="showPass ? 'text' : 'password'"
                            label="Nhập mật khẩu của bạn"  
                            :append-icon="showPass ? 'mdi-eye' : 'mdi-eye-off'"
                            hint="At least 8 characters"
                            @click:append="showPass = !showPass"  
                            required
                            >
                        </v-text-field>

                        <v-btn
                            color="primary"
                            block
                            :class="btn-login"
                            @click="login"
                            > Đăng nhập  
                        </v-btn>

                        <h3> 
                            <router-link class="forgot-pass-text" 
                            to="/forgot"> Quên mật khẩu  </router-link>   
                        </h3>

                        <v-btn color="primary" @click="auth()">Đăng kí google</v-btn>
                    
                    </v-form>

                    <span class="navigate">
                        <span class="no-hover-pointer"> Chưa có tài khoản ? </span>  
                        <h3>
                            <router-link class="primary-text-color hover-pointer" 
                            to="/register"> Đăng kí </router-link>   
                        </h3>
                    </span>
                </div>
            </div>
        </div>

        <!-- Dialog Confirm -->
        <!-- <DialogBox
            :title="'Trời pơ tin dc j=gna'"
            :type="'success'"
        /> -->

    </v-app>

</template>

<script>
import DialogBox from "../layouts/DialogBox.vue"
import axiosInstance from '../axios';

import axios from 'axios'
import router from "@/router";

import {EventBus} from '@/EventBus'

export default {
    name: "Login",
    components: {DialogBox},
    data() {
        return {
            valid: true,
            showPass: false,
            rules: {
                required: value => !!value || 'Required.',
                min: v => v.length >= 8 || 'Min 8 characters',
                emailMatch: () => (`The email and password you entered don't match`),
            },  
            password: '',
            passwordRules: [
                v => !!v || 'Bạn cần nhập mật khẩu',
                v => (v && v.length > 0) || 'Mật khẩu không được để trống',
            ],
            username: '',
            usernameRules: [
                v => !!v || 'Bạn cần nhập tài khoản',
                v => (v && v.length > 0) || 'Tài khoản không được để trống',
            ],
            
        }
    },

    mounted() {
        this.changeTitle()
    },

    methods:{
        changeTitle(){
            document.title = "Đăng Nhập"
        },

        login(){
            axiosInstance.get('/SelectAllUser')
            .then(res => console.log(res.data))
        },

        async auth(){
            const googleAuth = await this.$gAuth.signIn()
            console.log(googleAuth.qv)
            EventBus.$emit('hello', 123)

             router.push('/topic')
        },

        async login1() {
            if (this.username != '' && this.password != '') {
                let result = await axiosInstance.get(`/AuthLogin/${this.username}/${this.password}`)
    
                if (result.status == 200 && result.data.length > 0) {
                    console.log("1ok")
                    alert("ok")
                    this.userID = result.data[0].UserID
                    this.authUser()
                    window.localStorage.setItem("user-info", JSON.stringify(result.data[0]))
                }
                else {
                    console.log("2not ok")

                    alert("false")

                    this.errorLoginToast = true
                    this.alert = true
                    setTimeout(() => {
                        this.errorLoginToast = false
                        this.alert = false
                    }, 2000)
                }
            }
            else {
                const { valid } = await this.$refs.form.validate()
            }
        }
    }
}   
</script>

<style lang="scss" scoped>
#container{
    position: relative;
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
            width: 50%;
        }
    }   
}



</style>