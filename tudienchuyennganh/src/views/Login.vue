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

                    <v-form
                        ref="form"
                        v-model="valid"
                        lazy-validation
                    >
                

                        <v-text-field
                            v-model="username" :rules="usernameRules"
                            :counter="10"
                            label="Nhập tài khoản của bạn"  
                            color="primary"
                            variant="underlined"

                            required
                            autofocus
                            @keyup.enter="login()"
                            >
                        </v-text-field>

                        <v-text-field
                        v-model="password" :rules="passwordRules"
                            :counter="10"
                            :type="showPass ? 'text' : 'password'"
                            label="Nhập mật khẩu của bạn"  
                            color="primary"
                            variant="underlined"
                            :append-icon="showPass ? 'mdi-eye' : 'mdi-eye-off'"
                            hint="Tối thiểu 10 kí tự"
                            @click:append="showPass = !showPass"  
                            @keyup.enter="login()"
                            required
                            >
                        </v-text-field>

                        
                        <el-button type="primary" class="btn-login" @click="login">Đăng nhập</el-button>

                        <h3 class="forgot-pass-text"> 
                            <router-link to="/forgot"> 
                            <span style="color: var(--main-color)">
                                Quên mật khẩu 
                            </span> </router-link>   
                        </h3>
                    
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
    </v-app>

</template>

<script>
import DialogBox from "../layouts/DialogBox.vue"
import axiosInstance from '../axios'

import { ElNotification } from 'element-plus'

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
        this.getFacultyForSelect()
    },

    methods:{
        changeTitle(){
            document.title = "Đăng Nhập"
        },

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

        async login(){
            if (this.username != '' && this.password != '') {

                try{
                    let result = await axiosInstance.post(`/login/${this.username}/${this.password}`)
                    if (result.status == 200 && result.data.length > 0) {

                        // Account has in database
                        let hasAccountID = Object.values(result.data[0])
                        console.log('hasAccountID',hasAccountID)
                        if(hasAccountID != 0){
                            this.getDataUser(hasAccountID)
                        }
                        else 
                        {
                            this.showNotification('Thông báo', 'Tài khoản hoặc mật khẩu không chính xác', 'error')
                        }
                    
                    }
                }       
                catch{
                    this.showNotification('Thông báo', 'Tài khoản hoặc mật khẩu không chính xác', 'error')
                }        
            }
            else {
                // turn on warning validate
                const { valid } = await this.$refs.form.validate()
            }
            
         
        },

        getDataUser(idUser){
            console.log('idUser',idUser)
            axiosInstance.get(`/user/id=${idUser}`)
            .then((res) => {
                console.log(res.data[0])

                let dataUser = {
                    accountID: '',
                    email: '',
                    name: '',
                    MaGV: '',
                    IDFACULTY: '', 
                    Role: '',
                }
                
                if(res.data[0].Active == 0){
                    dataUser.accountID = res.data[0].AccountID
                    dataUser.Role = res.data[0].RoleID

                    localStorage.setItem('isNew', true)

                    localStorage.setItem('userInfo', JSON.stringify(dataUser))
                     window.location.href = '/topic'

                }
                else {
                    
                    dataUser.accountID = res.data[0].AccountID
                    dataUser.email = res.data[0].Email
                    dataUser.name = res.data[0].Name
                    dataUser.MaGV = res.data[0].MaGV || 0
                    dataUser.IDFACULTY = res.data[0].IDFACULTY
                    dataUser.Role = res.data[0].Priority

                    localStorage.setItem('userInfo', JSON.stringify(dataUser))
                    localStorage.setItem('isNew', false)

                    window.location.href = '/topic'
                }
               


            })
        },  
    }
}   
</script>

<style lang="scss" scoped>
#container{
    position: relative;
    width: 90%;
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
    padding: 20px 0px;

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
        color: var(--main-color) !important;
        margin-top: 15px;
    }

    .btn-login{
        padding: 0px 0px;
        width: 100%;
        height: 40px;
        background-color: var(--main-color);

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