<template>
    <div class="container">
    
        <h1 class="txt-40">Cài đặt tài khoản</h1>

        <el-row :gutter="20">

            <el-col :span="20">
                <h1 class="info-user">Tài khoản</h1>
                <el-input v-model="input" />
            </el-col>

            <el-col :span="20">
                <h1 class="info-user" >Mật khẩu</h1>
                <el-input show-password="true" v-model="inputPassword" 	/>
            </el-col>

            <el-col :span="20">
                <h1 class="info-user">Email</h1>
                <el-input v-model="input" />
            </el-col>
            
            <el-col :span="10">
                <h1 class="info-user"> Lớp </h1>
                <el-input v-model="inpit"  />
            </el-col>

            <el-col :span="10">
                <h1 class="info-user"> Khoa </h1>
                <el-input v-model="inpit"  />
            </el-col>

            <el-col :span="20">
                <h1 class="info-user"> Giới tính</h1>
                <el-input v-model="input" />
            </el-col>

       
        </el-row>

        <el-divider />

        <el-button type="primary">Xác nhận</el-button>
        <el-button>Đóng</el-button>


        

    </div>
</template>

<script>
export default {
    data(){
        return{
            inputPassword: '123'
        }
    }
}
</script>

<style lang="scss" scoped>
.container{
    padding: 50px;
}

.el-col + .el-col {
    margin-top: 20px;
}

.info-user{
    color: var(--gray-text);
    font-weight: 500;
}
</style>

