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
                            v-model="name"
                            :counter="10"
                            :rules="nameRules"
                            label="Nhập email của bạn"    
                            suffix="@gmail.com"
                            required
                            >
                        </v-text-field>

                        <v-text-field
                            v-model="password"
                            :counter="10"
                            :rules="[rules.required, rules.min]"
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
                            > Đăng nhập  
                        </v-btn>

                        <h3 class="forgot-pass-text"> 
                            <a href="#" 
                            @click="moveToForgot"> Quên mật khẩu </a>
                        </h3>
                    
                    </v-form>

                    <span class="navigate">
                        <span class="no-hover-pointer"> Chưa có tài khoản ? </span>  
                        <h3>
                            <a class="primary-text-color hover-pointer" @click="moveToRegister"> Đăng kí </a>  
                        </h3>
                    </span>
                </div>
            </div>
        </div>

        <!-- Dialog Confirm -->
        <DialogBox
            :title="'Trời pơ tin dc j=gna'"
            :type="'success'"
        />

    </v-app>

</template>

<script>
import router from "@/router";
import DialogBox from "../layouts/DialogBox.vue"

export default {
    name: "Login",
    components: {DialogBox},
    data() {
        return {
            showPass: false,
            rules: {
                required: value => !!value || 'Required.',
                min: v => v.length >= 8 || 'Min 8 characters',
                emailMatch: () => (`The email and password you entered don't match`),
            },  
        }
    },

    mounted() {
        this.changeTitle()
    },

    methods:{
        changeTitle(){
            document.title = "Đăng Nhập"
        },

        moveToRegister(){
             router.push('/register')
        },

        moveToForgot(){
            router.push('/forgot')
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