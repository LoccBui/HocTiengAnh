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
                        <el-button  color="var(--main-color)" size="large" @click="handleChangeInfo()" >Xác nhận</el-button>
                    </div>
                </el-col>
            </div>

            <div class="wrapper">

                <el-row style="width: 100%; " >

                    <el-col>
                        <h1 class="txt-40">Thay đổi mật khẩu</h1>

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
                            <el-button color="var(--main-color)" size="large" @click="changePassword()">Thay đổi mật khẩu</el-button>
                        </div>

                        
                    </el-col>

                    
                     <el-divider />

                     <el-col>
                        <h1 class="txt-40">Bộ từ cá nhân</h1>
                        <div class="confirm-btn">
                            <el-button color="var(--main-color)" size="large" @click="handleShowPersonCollection()">Thay đổi mặc định bộ từ cá nhân</el-button>
                        </div>
                     </el-col>

                </el-row>

            </div>
            
        </div>


       

        <el-dialog v-model="openPickAvatar" title="Hãy chọn avatar mới" width="45%"  align-center>
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
                <el-button @click="openPickAvatar = false" type="danger" size="large">Đóng</el-button>
                <el-button color="var(--main-color)" size="large" @click="this.confirmAvatar()">
                Xác nhận
                </el-button>
            </span>
            </template>
        </el-dialog>


    <div class="personalCollection">

        <el-dialog
            v-model="personCollection"
            title="Chọn bộ từ cá nhân của bạn"
            width="30%"
            :before-close="handleClose"
            align-center

        >

            
            <div v-if="notHaveCollectionWarn">
                <h1 class="warning-text">Bạn chưa có bộ từ vựng của riêng mình</h1>
            </div>
            
            
            <div class="collection-cover">
                <el-button v-for="collection in arrCollection" :key="collection" class="collection" @click="setDefaultPersonalVocab(collection)">
                    <div>
                        {{ collection.PersonalVocabName }}
                    </div>
                    
                    <div class="ml-4 defaul-word" v-if="collection.IsDefault == true" >Mặc định</div>
                </el-button>
            </div>
            
            <template #footer>    
            <div class="btn-create-new">
            <el-button color="var(--main-color)" size="large" @click="handleOpenCreateNewVocab()">Tạo mới 
                <v-icon>mdi-plus</v-icon>
            </el-button>
            </div>
            </template>
        </el-dialog>

    </div>

 <!-- Dialog input new personal vocab -->
    <div class="personalVocabDialog">
        <el-dialog
            v-model="showPersonalVocabDialog"
            title="Thêm bộ từ mới"
            width="30%"
            :before-close="() => this.showPersonalVocabDialog = false"
        >

            <el-form  
                ref="ruleFormRef"
                :model="ruleForm"
                :rules="rules"
                status-icon
                label-width="20%" :label-position="'left'" >

                <el-form-item label="Tên bộ từ" prop="personalVocabname" >
                    <el-input prop="inputPersonalVocabName" size="large" 
                    v-model="ruleForm.personalVocabname" placeholder="Nhập tên bộ từ"   />
                </el-form-item>

            </el-form>
            <template #footer>
            <span class="dialog-footer">
                <el-button color="var(--main-color)" size="large" @click="createNewPersonalVocab()">
                    Xác nhận
                </el-button>
            </span>
            </template>
        </el-dialog>
    </div>

    </div>
</template>

<script>
import axiosInstance from '../axios'
import { ElNotification } from 'element-plus'
import Cookies from 'js-cookie';
import { requireTokenMixin } from '@/mixin/requireTokenMixin'


export default {
    mixins:[requireTokenMixin],

    data(){
        return{
            accountID: '',

            Priority: '',

            imageUser: '',
            inputName: '',
            gender: '',
            inputEmail: '',
            inputClass: '',
            inputFaculty: '',

            maGV: '',
            maSV: '',

            selectedAvatar: '',
            roleID: '',

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
            ],

            personCollection: false,
            notHaveCollectionWarn: false,
            arrCollection: [],

            showPersonalVocabDialog: false,

            ruleForm : {
                inputPersonalVocabName: '',
                inputNewPassword: '',
                inputConfirmNewPassword: ''
            },

            rules: {
                personalVocabname: [{ required: true, message: 'Bạn cần nhập tên bộ từ mới', trigger: 'change' }],
                newPassword: [{ required: true, message: 'Bạn cần mật khẩu mới', trigger: 'change' }],
                confirmNewPasword: [{ required: true, message: 'Bạn cần nhập xác nhận mật khẩu', trigger: 'change' }],
            }       

        }
    },

    created(){
        document.title = "Cài đặt tài khoản"
    },

    mounted(){
        this.getDataAvailable()
    },

    methods: {


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
                            this.$refs.ruleFormRef.resetFields();

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

        async handleChangeInfo(){
            
            console.log(this.Priority)
            var result, email;


            if(this.inputEmail.endsWith('@gmail.com') && this.inputEmail != "" && this.inputName != ""){

                email = await axiosInstance.post('updateInfoAccount', {
                    "AccountID": this.accountID,
                    "Email": `${this.inputEmail}`,
                    "Name": `${this.inputName}`,
                })

                
                // phân loại để gửi theo loại user
                try{

                    switch(this.roleID){
                        case 1:
                            result = await axiosInstance.post('updateInfoGiaoVien', {
                                "MaGV": this.maGV,
                                "Gender": `${this.gender == true ? 'Nam' : 'Nữ'}`
                            })


                            if(result.status == 200 && email.status == 200){
                                window.location.reload()
                                this.getDataAvailable()
                                this.showNotification('Thông báo', 'Cập nhật thành công', 'success')
                            }
                            else{
                                this.showNotification('Thông báo', 'Cập nhật không thành công', 'error')
                            }
                            break;

                        case 3: 
                            result = await axiosInstance.post('updateInfoSinhVien', {
                                "MaSV": this.maSV,
                                "Gender": `${this.gender  == true ? 'Nam' : 'Nữ'}`
                            })
        
                            if(result.status == 200 && email.status == 200){
                                window.location.reload()
                                this.getDataAvailable()
                                this.showNotification('Thông báo', 'Cập nhật thành công', 'success')
                            }
                            else{
                                this.showNotification('Thông báo', 'Cập nhật không thành công', 'error')
                            }
                            break;
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

        confirmAvatar(){
            axiosInstance.post('changeAvatar', {
                "AccountID": this.accountID,
                "Image": `${this.selectedAvatar}`
            })

            .then( () => {
                this.showNotification('Thông báo', 'Cập nhật ảnh thành công', 'success')
                window.location.reload()
            })

            .catch( () => {
                this.showNotification('Thông báo', 'Cập nhật ảnh không thành công', 'error')
            })
            
        },  

        async getDataAvailable(){
            
            let dataUser = JSON.parse(Cookies.get('userInfo'))

            this.accountID = dataUser.accountID

            let result = await axiosInstance.post('settingAccount', {
                "AccountID": this.accountID
            })

            if(result.status == 200){
                console.log(result.data[0])
                this.imageUser =  result.data[0].Image
                this.inputName = result.data[0].Name
                this.gender = result.data[0].Gender == 'Nam' ? true : false
                this.inputEmail = result.data[0].Email
                this.inputClass = result.data[0].ClassName
                this.inputFaculty = result.data[0].FacultyName
                this.Priority = result.data[0].Priority
                this.maGV = result.data[0].MaGV || undefined
                this.maSV = result.data[0].MaSV || undefined

                this.roleID = result.data[0].RoleID
                
            }
        },


    handleShowPersonCollection(){
        this.personCollection = true
        this.getPersonCollection()
      },

    async getPersonCollection(){
            try{
                let result = await axiosInstance.post('getPersonalCollection',{
                    "AccountID": this.accountID
                })

                if(result.status == 200){
                    this.arrCollection = result.data
                }
                }
            catch(ex) {
                this.notHaveCollectionWarn = true
            }
      },

    // Personal vocab
    setDefaultPersonalVocab(collection){
        try{
            axiosInstance.post('changeDefaultPersonalVocab', {
            "AccountID": this.accountID,
            "PersonalVocabID": collection.PersonalVocabID
            })
            .then(() => {
                this.getPersonCollection()
                this.showNotification('Thông báo', 'Cập nhật thành công', 'success')
            })

        }
        catch(e){
            this.showNotification('Thông báo', 'Cập nhật ảnh không thành công', 'error')
        }  
    },

    handleOpenCreateNewVocab(){
        this.showPersonalVocabDialog = true
    },


    async createNewPersonalVocab(){

        await  this.$refs.ruleFormRef.validate((valid) => {
            if (valid) {
                try{
                    axiosInstance.post('createPersonalVocab', {
                        "AccountID": this.accountID,
                        "PersonalVocabName": `${this.ruleForm.personalVocabname}`
                    })
                    .then(() => {
                        this.showPersonalVocabDialog = false
                        this.ruleForm.personalVocabname = ''
                        this.getPersonCollection()
                        this.showNotification('Thông báo', 'Thêm thành công', 'success')
                    })

                }
                catch(e){
                    this.showNotification('Thông báo', 'Thêm không thành công', 'error')
                }  

            } else {
                this.$message.error('Dữ liệu còn thiếu.');
                return false;
            }
        });
    }
},




   


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

        .el-button{
            background-color: transparent !important;
        }

        .el-button:hover{
            background-color: transparent !important;
        }
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


.personalCollection{
    .el-dialog{
    border-radius: 20px !important;

    .warning-text{
        font-size: 20px;
    }

    .btn-create-new{
        .el-button{
        width: 100%;
        border-radius: 5px !important;
        }

        &:hover{
            color: white;
        }
    }
    }
}

.collection-cover{
    display: flex;
    flex-direction: column;

    .collection{
      padding: 8%;
      margin: 0;
      
      &:hover{
        color: white;
      }
      
      .defaul-word{
        font-weight: 800;
        font-size: 20px;
        color: var(--main-color);
      }
    }

    .collection + .collection{
      margin-top: 4%;
    }

  }

.personalVocabDialog{


    .dialog-footer{
        
        .el-button{
            width: 100%;
        }
    }

}
</style>

