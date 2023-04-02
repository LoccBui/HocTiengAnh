<template>
    <div class="setting-account-container">
    
        <div class="info-wrapper">
            <div class="wrapper">

                <el-col>
                    <h1 class="txt-40">Cài đặt tài khoản</h1>

                    <div class="avatar-wrapper">
                        <div>
                            <img src="../../assets/img/male.png" />
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
                        <h1 class="info-user">Tài khoản</h1>
                        <el-input v-model="input" />
                    </el-col>

                    <el-col :span="24">
                        <h1 class="info-user"> Giới tính</h1>
                        <el-input v-model="input" />
                    </el-col>

                    <el-col :span="24">
                        <h1 class="info-user">Email</h1>
                        <el-input v-model="input" />
                    </el-col>
                    
                    <el-col :span="24">
                        <h1 class="info-user"> Lớp </h1>
                        <el-input v-model="inpit"  />
                    </el-col>

                    <el-col :span="24">
                        <h1 class="info-user"> Khoa </h1>
                        <el-input v-model="inpit"  />
                    </el-col>

                </el-col>
            </div>

            <div class="wrapper">

                <el-col>
                    <h1 class="txt-40">Thay đổi mật khẩu</h1>

                    <el-col :span="24">
                        <h1 class="info-user">Mật khẩu hiện tại</h1>
                        <el-input v-model="input" />
                    </el-col>

                    <el-col :span="24">
                        <h1 class="info-user">Mật khẩu mới</h1>
                        <el-input show-password="true" v-model="inputPassword" 	/>
                    </el-col>

                    <el-col :span="24">
                        <h1 class="info-user">Xác nhận mật khẩu</h1>
                        <el-input v-model="input" />
                    </el-col>
                    
                    <el-col :span="24">
                        <h1 class="info-user"> Lớp </h1>
                        <el-input v-model="inpit"  />
                    </el-col>

                    <el-col :span="24">
                        <h1 class="info-user"> Khoa </h1>
                        <el-input v-model="inpit"  />
                    </el-col>

                    <el-col :span="24">
                        <h1 class="info-user"> Giới tính</h1>
                        <el-input v-model="input" />
                    </el-col>


                </el-col>
            </div>
            
        </div>
        <div class="info-wrapper">
            <div class="wrapper">

                <el-col>
                    <h1 class="txt-40">Cài đặt tài khoản</h1>

                    <div class="avatar-wrapper">
                        <div>
                            <img src="../../assets/img/male.png" />
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
                        <h1 class="info-user">Tài khoản</h1>
                        <el-input v-model="input" />
                    </el-col>

                    <el-col :span="24">
                        <h1 class="info-user"> Giới tính</h1>
                        <el-input v-model="input" />
                    </el-col>

                    <el-col :span="24">
                        <h1 class="info-user">Email</h1>
                        <el-input v-model="input" />
                    </el-col>
                    
                    <el-col :span="24">
                        <h1 class="info-user"> Lớp </h1>
                        <el-input v-model="inpit"  />
                    </el-col>

                    <el-col :span="24">
                        <h1 class="info-user"> Khoa </h1>
                        <el-input v-model="inpit"  />
                    </el-col>

                </el-col>
            </div>

            <div class="wrapper">

                <el-col>
                    <h1 class="txt-40">Thay đổi mật khẩu</h1>

                    <el-col :span="24">
                        <h1 class="info-user">Mật khẩu hiện tại</h1>
                        <el-input v-model="input" />
                    </el-col>

                    <el-col :span="24">
                        <h1 class="info-user">Mật khẩu mới</h1>
                        <el-input show-password="true" v-model="inputPassword" 	/>
                    </el-col>

                    <el-col :span="24">
                        <h1 class="info-user">Xác nhận mật khẩu</h1>
                        <el-input v-model="input" />
                    </el-col>
                    
                    <el-col :span="24">
                        <h1 class="info-user"> Lớp </h1>
                        <el-input v-model="inpit"  />
                    </el-col>

                    <el-col :span="24">
                        <h1 class="info-user"> Khoa </h1>
                        <el-input v-model="inpit"  />
                    </el-col>

                    <el-col :span="24">
                        <h1 class="info-user"> Giới tính</h1>
                        <el-input v-model="input" />
                    </el-col>


                </el-col>
            </div>
            
        </div>

        <div class="confirm-btn">
            <el-button 
            type="primary"
            
             >Xác nhận
        </el-button>
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
                <el-button type="primary" @click="centerDialogVisible = false">
                Xác nhận
                </el-button>
            </span>
            </template>
        </el-dialog>


    </div>
</template>

<script>
export default {
    data(){
        return{
            inputPassword: '123',
            openPickAvatar: false,
            arrSourcesImage:[
                {'id': 1, 'source': 'male1'},
                {'id': 2, 'source': 'male2'},
                {'id': 3, 'source': 'male3'},
                {'id': 4, 'source': 'male4'},
                {'id': 5, 'source': 'female1'},
                {'id': 6, 'source': 'female2'},
                {'id': 6, 'source': 'female3'},
                {'id': 6, 'source': 'female4'},
            ]
        }
    },

    mounted(){
        this.changeTitle()
    },

    methods: {
        changeTitle(){
          document.title = "Cài đặt tài khoản"
        },

        openPick(){
            this.openPickAvatar = true
        },

        chooseAvatar(source){
            alert(source)
        }
    }

}
</script>

<style lang="scss" >
.setting-account-container{ 
    position: relative;
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
    padding: 0 100px;
    margin: 80px 0;
}

.avatar-wrapper{
    display: flex;
    align-items: center;

    .change-img{
        margin-left: 40px;
    }
}

.info-wrapper{
    padding: 0 100px;
    display: flex;
    width: 100%;


    .wrapper{
        padding: 10px;
        border: 1px solid var(--light-blue-90);
        border-radius: 10px;
        width: 50%;
        display: flex;
        align-items: start;
        justify-content: center;
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

