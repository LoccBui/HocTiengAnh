<template>
  <div class="askbox-container">
    <el-dialog 
        class="askBox"
        v-model="dialog"
        :title="`${title}`" 
        width="30%" 
        :before-close="this.handleClose">

        <span>    Hành động này không thể hoàn tác </span>
        
        <template #footer>
        <span class="dialog-footer">
            
            <el-button 
                size="large"         
                @click="close()"
                >Đóng
            </el-button>

            <el-button 
                :type="`${typeButton}`"
                size="large" 
                @click="confirm()"
                >{{ btnYes }}
            </el-button>
        </span>
        </template>
    </el-dialog>

  </div>
</template>

<script>
export default {
    props: ['title', 'typeButton', 'btnYes' ],
    data(){
        return{
            dialog: true,   
        }

    },
    methods:{
        confirm(){
            this.$emit('confirm')
        },

        close(){
            this.dialog = false
            this.$emit('close')

        },

        handleClose(){
            this.$emit('close')
        }
    }
}
</script>

<style lang="scss">

.askbox-container{
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

    .dialog-footer{
        display: flex;

    }

    .el-button{
            width:50%;
        }
}
@media screen and (max-width: 900px){
    .el-dialog{
        width: 80% !important;
    }
}

</style>