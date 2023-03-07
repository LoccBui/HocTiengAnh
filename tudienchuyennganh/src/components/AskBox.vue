<template>
  <div>
      <v-dialog
        v-model="dialog"
        width="auto"
        transition="dialog-bottom-transition"
        persistent
      >
        <v-card width="500px" :title="`${title}`" >
        
        <v-card-actions>          
            <v-btn variant="flat" color="primary" @click="confirm()">Xác nhận </v-btn>
            <v-btn variant="flat" color="error" @click="close()">Đóng</v-btn>
        </v-card-actions>
        </v-card>
    </v-dialog>
  </div>
</template>

<script>
export default {
    props: ['title'],
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

        }
    }
}
</script>

<style>

</style>