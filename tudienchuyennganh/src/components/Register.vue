<template>
    <v-app>
        <div id="container">

            <!-- Khung bao img và form -->
            <div id="frame-cover">

                <div class="frame-left">
                    <img class="brand-logo-img" src="../assets/gif/forgot-pass.gif" alt="LHU logo">
                </div>

                <div class="frame-right">
                    <h1 class="heading-text"> ĐĂNG KÍ </h1>
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

                        <v-text-field
                            v-model="password"
                            :counter="10"
                            :rules="nameRules"
                            label="Nhập mật khẩu của bạn"    
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
                            <a href="#"> Quên mật khẩu </a>
                        </h3>
                    
                    </v-form>

                    <span class="navigate">
                        <h3>
                            <span class="no-hover-pointer"> Đã có tài khoản ? </span>  
                        </h3>
                        <h3>
                            <a class="primary-text-color" href="#" @click="moveToLogin"> Đăng nhập </a>  
                        </h3>
                    </span>
                </div>
            </div>
        </div>
    </v-app>

</template>

<script>
import router from "@/router";

export default {
    data() {
        return {}
    },

    mounted() {
        this.changeTitle()
    },

    methods:{
        changeTitle(){
            document.title = "Đăng kí"
        },

        moveToLogin(){
             router.push('/')
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