<template>
    <v-app>
        <div id="container">

            <!-- Khung bao img và form -->
            <div id="frame-cover">

                <div class="frame-left">
                    <img class="brand-logo-img" src="../../assets/gif/time-learn-en.gif" alt="LHU logo">
                </div>

                <div class="frame-right">
                    <h1 class="heading-text"> ĐĂNG NHẬP </h1>

                    

                    <div class="google-btn hover-pointer" @click="auth()" >
                        
                        <div class="google-icon-wrapper">
                        <img class="google-icon" src="https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg"/>
                        </div>
                        <p class="btn-text"><b>Đăng nhập với Google</b></p>
                    </div>

                    <h1 class="sub-text"> hoặc </h1>

                    <v-form
                        ref="form"
                        v-model="valid"
                        lazy-validation
                    >
                    
                        <v-alert
                        v-if="showAlert"
                        type="error"
                        text="Sai tài khoản hoặc mật khẩu"
                        >
                        </v-alert>


                        <v-text-field
                        v-model="username" :rules="usernameRules"
                            :counter="10"
                            label="Nhập tài khoản của bạn"    
                            required
                            @keyup.enter="login()"
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
                            @keyup.enter="login()"
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

                        <h1>{{ Vue3GoogleOauth.isInit }}</h1>
                        <h1>{{ Vue3GoogleOauth.isAuthorized }}</h1>
                    
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
import axiosInstance from '../axios'


import { inject, toRefs } from "vue"

import emitter from '../eventBus.js'



export default {

    setup(props) {
      const { isSignIn } = toRefs(props);

        const Vue3GoogleOauth = inject("Vue3GoogleOauth");
            return{
                Vue3GoogleOauth, isSignIn
            }

    },
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
            showAlert: false
        }
    },

    mounted() {
        this.changeTitle()
    },

    methods:{
        changeTitle(){
            document.title = "Đăng Nhập"
        },

        async login(){
            if (this.username != '' && this.password != '') {

                let result = await axiosInstance.post(`/login/${this.username}/${this.password}`)
                if (result.status == 200 && result.data.length > 0) {

                    // Account has in database
                    var hasAccountID = Object.values(result.data[0])
                    if(hasAccountID != 0){
                        this.getDataUser(hasAccountID)

                        this.$router.push('/topic')
                    }
                    else 
                    {
                        this.showAlert = true 

                        setTimeout(() => {
                            this.showAlert = false 
                        }, 3000);
                    }

                    
                }
                else {
                    console.log(result.status)
                }
            }
            else {
                // turn on warning validate

                const { valid } = await this.$refs.form.validate()
            }
            
         
        },

        getDataUser(idUser){
            axiosInstance.get(`/user/id=${idUser}`)
            .then((res) => {

                var dataUser = {
                    accountID: '',
                    email: '',
                    name: ''
                }
                
                dataUser.accountID = res.data[0].AccountID
                dataUser.email = res.data[0].Email
                dataUser.name = res.data[0].Name
                emitter.emit('data', dataUser);
            })
        },

        async auth(){
            try {
                const googleUser = await this.$gAuth.signIn();
                if (!googleUser) {
                    return null;
                }
                
                this.$router.push('/topic')
                
                    
            } 
            catch (error) {
                //on fail do something
                console.error(error);
                return null;
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

// google buton
.google-btn {
  width: 100%;
  height: 42px;
  background-color: #4285f4;
  border-radius: 2px;
  box-shadow: 0 3px 4px 0 rgba(0,0,0,.25);


  .google-icon-wrapper {
    position: absolute;
    margin-top: 1px;
    margin-left: 1px;
    width: 40px;
    height: 40px;
    border-radius: 2px;
    background-color: #fff;
  }
  .google-icon {
    position: absolute;
    margin-top: 11px;
    margin-left: 11px;
    width: 18px;
    height: 18px;
  }
  .btn-text {
    text-align: center;
    margin: 11px 11px 0 0;
    color: #fff;
    font-size: 14px;
    letter-spacing: 0.2px;
    font-family: "Roboto";
  }
  &:hover {
    box-shadow: 0 0 6px #4285f4;
  }
  &:active {
    background: #1669F2;
  }
}
//end google buton

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

    .sub-text{
        font-size: 20px;
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