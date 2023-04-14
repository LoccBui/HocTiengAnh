<template>
    <div class="setting-account-container">
    
        <div class="info-wrapper">
            <div class="wrapper">

                <el-col>
                    <h1 class="txt-40">Cài đặt tài khoản</h1>

                    <div class="avatar-wrapper">
                        <div>
                            <img :src="`../../assets/img/avatar/${imageUser}.png`" />
                        </div>

                        <div class="change-img">
                            <el-button
                            style="width: auto;"
                            @click="this.openPick()"
                            > Chọn avatar khác
                            </el-button>
                        </div>
                    </div>

                

                
                    <el-col :span="24">
                        <h1 class="info-user">Họ và tên</h1>
                        <el-input v-model="inputName" />
                    </el-col>

                    <el-col :span="24">
                        <h1 class="info-user"> Giới tính</h1>
                        <el-switch v-model="gender" :inactive-text="'Nữ'" :active-text="'Nam'"></el-switch>
                    </el-col>

                    <el-col :span="24">
                        <h1 class="info-user">Email</h1>
                        <el-input v-model="inputEmail" />
                    </el-col>
                    
                    <el-col :span="24">
                        <h1 class="info-user"> Lớp </h1>
                        <el-input v-model="inputClass" disabled	 />
                    </el-col>

                    <el-col :span="24">
                        <h1 class="info-user"> Khoa </h1>
                        <el-input v-model="inputFaculty" disabled />
                    </el-col>

                    <div class="confirm-btn">
                        <el-button  type="primary" @click="handleChangeInfo()" >Xác nhận</el-button>
                    </div>
                </el-col>
            </div>

            <div class="wrapper">

                <el-col>
                    <h1 class="txt-40">Thay đổi mật khẩu</h1>

                    <el-col :span="24">
                        <h1 class="info-user">Mật khẩu mới</h1>
                        <el-input show-password v-model="inputNewPassword" 	/>
                    </el-col>

                    <el-col :span="24">
                        <h1 class="info-user" >Xác nhận mật khẩu</h1>
                        <el-input show-password  v-model="inputNewPasswordConfirm"  @keyup.enter="changePassword()"/>
                    </el-col>

                    <div class="confirm-btn">
                        <el-button type="primary" @click="changePassword()">Thay đổi mật khẩu</el-button>
                    </div>

                </el-col>

            </div>
            
        </div>


       

        <el-dialog v-model="openPickAvatar" title="Hãy chọn avatar mới" width="45%">
            <span>
                Hãy chọn avatar mới

                <div class="images-pick" >
                     <el-button v-for="img in arrSourcesImage" :key="img.id" @click="chooseAvatar(img.source)">
                        <img class="img-choose" :src="`../../assets/img/avatar/${img.source}.png`" />
                    </el-button>
                </div>
            </span>
            <template #footer>
            <span class="dialog-footer">
                <el-button @click="openPickAvatar = false">Đóng</el-button>
                <el-button type="primary" @click="this.confirmAvatar()">
                Xác nhận
                </el-button>
            </span>
            </template>
        </el-dialog>


    </div>
</template>

<script>
import axiosInstance from '../axios'
import { ElNotification } from 'element-plus'

import CryptoJS from 'crypto-js';

import md5 from 'md5';

export default {
    data(){
        return{
            accountID: '',

            roleUser: '',

            imageUser: '',
            inputName: '',
            gender: '',
            inputEmail: '',
            inputClass: '',
            inputFaculty: '',

            maGV: '',
            maSV: '',
            inputNewPasswordConfirm: '',
            inputNewPassword: '',

            selectedAvatar: '',

            openPickAvatar: false,
            arrSourcesImage:[
                {'id': 1, 'source': 'male1'},
                {'id': 2, 'source': 'male2'},
                {'id': 3, 'source': 'male3'},
                {'id': 4, 'source': 'male4'},
                {'id': 5, 'source': 'female1'},
                {'id': 6, 'source': 'female2'},
                {'id': 7, 'source': 'female3'},
                {'id': 8, 'source': 'female4'},
                {'id': 9, 'source': 'default'},
            ]
        }
    },

    mounted(){
        this.changeTitle()
        this.getDataAvailable()
    },

    methods: {
        changeTitle(){
          document.title = "Cài đặt tài khoản"
        },

        openPick(){
            this.openPickAvatar = true
        },

        showNotification(title ,message, type){
            ElNotification({
                title: `${title}`,
                message: `${message}`,
                type: `${type}`,
            })
        },    

        chooseAvatar(source){
            this.selectedAvatar = source
        },

        changePassword(){
            if(this.inputNewPasswordConfirm != this.inputNewPassword){
                this.showNotification('Thông báo', 'Mật khẩu không trùng nhau', 'error')
                    this.$message.error('Mật khẩu phải trùng nhau.');
            }
            else{
                this.showNotification('Thông báo', 'Mật khẩu trùng nhau', 'success')

                // const secretKey = 123;
                // const data = 'passwordHere';
                //  const encryptedData = CryptoJS.AES.encrypt(data, secretKey).toString();

                axiosInstance.post('test1', {
                    encryptedData
                })
                .then(response => {
                    console.log(response);
                    // Xử lý phản hồi từ server
                })
                .catch(error => {
                    // Xử lý lỗi
                    console.log(error);
                });


            }
        },

        async handleChangeInfo(){
            
            let result, email;

            //send lên account đổi email trước
            console.log(this.inputEmail)
            console.log(this.inputName)

            if(this.inputEmail.endsWith('@gmail.com') && this.inputEmail != "" && this.inputName != ""){

                email = await axiosInstance.post('updateInfoAccount', {
                    "AccountID": this.accountID,
                    "Email": `${this.inputEmail}`,
                })

                console.log(this.roleUser)

                
                // phân loại để gửi theo loại user
                try{

                    switch(this.roleUser){
                        case 10:
                            result = await axiosInstance.post('updateInfoGiaoVien', {
                                "MaGV": this.maGV,
                                "Name": `${this.inputName}`,
                                "Gender": `${this.gender == true ? 'Nam' : 'Nữ'}`
                            })


                            if(result.status == 200 && email.status == 200){
                                window.location.reload()

                                this.getDataAvailable()
                                // note: đổi lại get data của main layout
                                this.showNotification('Thông báo', 'Cập nhật thành công', 'success')
                            }
                            else{
                                this.showNotification('Thông báo', 'Cập nhật không thành công', 'error')
                            }
                            break;

                        case 1: 
                            result = await axiosInstance.post('updateInfoSinhVien', {
                                "MaSV": this.maSV,
                                "Name": `${this.inputName}`,
                                "Gender": `${this.gender  == true ? 'Nam' : 'Nữ'}`
                            })
        
                            if(result.status == 200 && email.status == 200){
                                window.location.reload()
                                this.getDataAvailable()
                                // note: đổi lại get data của main layout
                                this.showNotification('Thông báo', 'Cập nhật thành công', 'success')
                            }
                            else{
                                this.showNotification('Thông báo', 'Cập nhật không thành công', 'error')
                            }
                            break;

                        default:{
                            if(result.status == 200 && email.status == 200){
                                window.location.reload()
                                this.getDataAvailable()
                                // note: đổi lại get data của main layout
                                this.showNotification('Thông báo', 'Cập nhật thành công', 'success')
                            }
                            else{
                                this.showNotification('Thông báo', 'Cập nhật không thành công', 'error')
                            }
                            break;
                        }
                    }
                }
                catch(e){
                    this.showNotification('Thông báo', 'Lỗi khi cập nhật', 'error')
                }
            }
            else{
                this.showNotification('Thông báo', 'Dữ liệu không chính xác', 'error')
            }

        },

        async confirmAvatar(){
            let result = await axiosInstance.post('changeAvatar', {
                "AccountID": this.accountID,
                "Image": `${this.selectedAvatar}`
            })

            if(result.status == 200) {
                this.showNotification('Thông báo', 'Cập nhật ảnh thành công', 'success')
                window.location.reload()
            }else{
                this.showNotification('Thông báo', 'Cập nhật ảnh không thành công', 'error')
            }
            
        },  

        async getDataAvailable(){
            let dataUser = JSON.parse(localStorage.getItem('userInfo'))


            this.accountID = dataUser.accountID

            let result = await axiosInstance.post('settingAccount', {
                "AccountID": this.accountID
            })

            if(result.status == 200){
                console.log(result.data[0].Gender)
                this.imageUser =  result.data[0].Image
                this.inputName = result.data[0].Name
                this.gender = result.data[0].Gender == 'Nam' ? true : false
                this.inputEmail = result.data[0].Email
                this.inputClass = result.data[0].ClassName
                this.inputFaculty = result.data[0].FacultyName
                this.roleUser = result.data[0].Priority
                this.maGV = result.data[0].MaGV || undefined
                this.maSV = result.data[0].MaSV || undefined
                
            }
        }
    }

}
</script>

<style lang="scss" scoped>
.setting-account-container{ 
    background-color: transparent;
    height: 100%;

    .el-dialog__title{
        font-weight: 600;
        font-size: 25px;
    }

    .el-dialog__body{
        font-size: 15px;
    }
   
    .el-dialog{
        border-radius: 10px;
    }
}

.txt-40{
    font-weight: 500;
    font-size: 20px;
    color: var(--gray-text);
}

.el-col + .el-col {
    margin-top: 20px;
}

.info-user{
    color: var(--gray-text);
    font-weight: 500;
}

.confirm-btn{
    padding: 20px 0;
}

.avatar-wrapper{
    display: flex;
    align-items: center;

    .change-img{
        margin-left: 40px;
    }
}

.info-wrapper{
    display: flex;  
    padding: 0 100px;

    .wrapper{
        height: fit-content;
        padding: 10px;
        border: 1px solid transparent;
        border-radius: 10px;
        width: 50%;
        display: flex;
        align-items: start;
        justify-content: center;
        box-shadow: rgba(50, 50, 93, 0.25) 0px 6px 12px -2px, rgba(0, 0, 0, 0.3) 0px 3px 7px -3px;
        margin-bottom: 50px;
    }

    .wrapper + .wrapper{
        margin-left: 20px;
    }
}

.images-pick{
    display: flex;
    flex-wrap: wrap;
    justify-content: start;
    align-items: center;

    .el-button{
        width: 120px;
        height: 120px;
        border-radius: 50%;
        margin: 20px;
    }

}
</style>

