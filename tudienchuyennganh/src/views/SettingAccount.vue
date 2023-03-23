<template>
    <div class="container">
    


        <div class="info-wrapper">
            <div class="wrapper">

                <el-col>
                    <h1 class="txt-40">Cài đặt tài khoản</h1>
                
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

        <el-button 
            type="primary"
            class="confirm-btn"
             >Xác nhận
        </el-button>

        


        

    </div>
</template>

<script>
export default {
    data(){
        return{
            inputPassword: '123'
        }
    },

    mounted(){
        this.changeTitle()
    },

    methods: {
        changeTitle(){
          document.title = "Cài đặt tài khoản"
        },
    }

}
</script>

<style lang="scss" scoped>
.container{
    padding: 50px;
    font-weight: 200;
    height: 100vh;
}

.txt-40{
    font-weight: 500;
    padding: 20px 0;
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
    margin-top: 20px;
    width: 200px !important;
    height: 40px;
}

.info-wrapper{
    display: flex;
    width: 100%;

    .wrapper{
        padding: 20px;
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
</style>

