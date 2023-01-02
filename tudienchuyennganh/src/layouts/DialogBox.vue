<template>
  
  <div id="overlay">
    <div class="dialog">
        <BoxContainer  :widthBox="width" :heightBox="height" >
        
            <template #header>
                <div class="header-box">
                    <div class="close-ask-box" >
                        <img src="../assets/icon/ic_checkmark.png" class="img-dialog" @click="closeBox()">    
                    </div>
                    <h3 class="state-text">{{titleBox}}</h3>
                </div>
            </template>

            <template #content >
                <h4>Nội dung sẽ abc da</h4>
            </template>

            <template #footer >
                <v-btn
                color="green"
                @click="confirmDelete"
                block
                >
                OK
                </v-btn>
            </template>
        
        </BoxContainer>      
    </div>
  </div>

</template>

<script>
import BoxContainer from './BoxContainer.vue';

export default {
    name: 'DialogBox',
    components: { BoxContainer },
    props: ['widthBox', 'heightBox', 'title', 'actionButton', 'type'],
    data(){
        return{
            titleBox: this.title,
            type: this.type,
        }
    },

    mounted(){
        this.checkType()
    },

    methods:{
        checkType(){
            if(this.type == 'success'){
                this.titleBox = "Thành công"
                alert(1)
            }
            else{
                alert(0)
            } 

        }
    }
}
</script>

<style lang="scss" scoped>

.header-box{
    width: 100%;
    height: 200px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
}

.img-dialog{
    height: 100%;
}

.state-text{
    text-transform: uppercase;
    color: #28A745;
    font-size: 30px;
}
</style>>
