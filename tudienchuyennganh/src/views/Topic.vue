<template>
    <div class="container">

        <div class="topic-cover" v-for="topic in dataTopicsAPI[0]" :key="topic.TopicID">
            <div class="header-info" >
                <div class="image-topic">
                    <img src="../../assets/img/default-topic.jpg" alt="Topic Image" class="img-topic">
                </div>

                <div class="info-topic">
                    <h1>{{ topic.TopicName }}</h1>
                    <h1> 1/ {{ topic.QuantityWords }} từ đã học</h1>
                
                    <v-progress-linear
                    model-value= 30
                    :buffer-value="bufferValue"
                    height="20"
                    color="var(--main-color)"
                    rounded
                    ></v-progress-linear>
                </div>
            </div>

            <div class="body-info">
                <div class="temporary"></div>
                <div class="action-info">
                    <h1 title="Từ cần ôn tập">
                        <v-icon>mdi-history</v-icon> 10 
                    </h1>

                    <h1 title="Từ khó">
                        <v-icon>mdi-alert-circle</v-icon> 20
                    </h1>           
                    
                    <br>

                    <!-- <v-btn color="var(--main-color)" width="100px" 
                    router :to="{params: {id: topic.TopicID}, name: 'LearnTopic' }"
                    >Học </v-btn> -->

                    <el-button size="large" color="var(--main-color)" @click="this.$router.push(`learning/topicid=${topic.TopicID}`)"
                    router :to="{params: {id: topic.TopicID}, name: 'LearnTopic' }"
                    >Học</el-button>

                    <el-button size="large" color="var(--main-color)" @click=" this.showOption = !this.showOption">
                        <v-icon>mdi-dots-vertical</v-icon>
                    </el-button>
                </div>
            </div>

        </div>



        <OptionLearning  v-if="showOption"
            @close-option = this.closeOptionBox()
        />

        <NewSinhVienForm v-if="showSinhVienForm"
        @finish-update-information = handleFinishForm
        />

        <NewGiaoVienForm v-if="showGiaoVienForm"
        @finish-update-information = handleFinishForm
        />
        
    </div>
</template>

<script>
import OptionLearning from './OptionLearning.vue';
import axiosInstance from '../axios'
import NewSinhVienForm from '../components/NewSinhVienForm.vue';
import NewGiaoVienForm from '@/components/NewGiaoVienForm.vue';


export default {
    components: {OptionLearning,NewSinhVienForm, NewGiaoVienForm},
    data(){
        return{
            showOption: false,
            dataTopicsAPI: [],
            accountID: '',
            showSinhVienForm: false,
            showGiaoVienForm: false,

        }
    },

    mounted(){
        this.handleNewUser()
        this.changeTitle()
        this.getDataTopic()
    

    },

    methods:{
        changeTitle(){
            document.title = "Học từ vựng"
        },

        handleNewUser(){

            let isNew = JSON.parse(localStorage.getItem('isNew'))
            let dataUser = JSON.parse(localStorage.getItem('userInfo'))
            

            console.log('isNew', isNew === true ? 1: 0)
            
            if(isNew == true){

                // user mới là giáo viên
                if(dataUser.Role== 2)
                {
                    this.showGiaoVienForm = true
                }
                // user mới là sinh viên
                else{
                    this.showSinhVienForm = true
                }        
            }
            else if(isNew == false){
                console.log(' ko show form')

                this.showSinhVienForm = false
            }
            else{
                window.location.href = '/login'
            }

        },
        
        //lấy data từ emitter
        handleDataUser(data){
            console.log("trạng thái", data)
            this.accountID = data.accountID   
            this.getDataTopic()
        },

        // lấy data topic theo id khoa nhận từ emmitter
        getDataTopic(){
            let dataUser = JSON.parse(localStorage.getItem('userInfo'))
            this.accountID = dataUser.accountID
            
            axiosInstance.get(`getTopic/${this.accountID}`)
                .then(res => this.handleData(res.data))
        },

        // lấy data topic 
        handleData(dataAPI){
            this.dataTopicsAPI.push(dataAPI)
        },

        closeOptionBox(){
            this.showOption = false
        },

        handleFinishForm(){
            this.showSinhVienForm = false
            this.showGiaoVienForm = false
            window.location.reload()
        }
        

    }
}
</script>

<style lang="scss" scoped>

.container{
    height: 1000px;
    display: flex;
    justify-content: start;
    align-items: start;
    flex-wrap: wrap;
}


.topic-cover{
    flex-basis: 400px;
    max-height: 200px;
    margin: 20px;
    padding: 10px;

    border: 1px solid transparent;
    border-radius: 15px;

    line-height: 50px;
    box-shadow: rgba(0, 0, 0, 0.24) 0px 3px 8px;
    .header-info{
        display: flex;
    }
    
    .body-info{
        display: flex;
        

        .temporary{
            width: 30%;
        }

        .action-info{
            flex: 1;
            display: flex;
            justify-content: space-around;
            align-items: center;
        }
    }


    .image-topic{
        display: flex;
        align-items: center;
        justify-content: center;
        width: 30%;

        .img-topic{
            width: 50%;
            height: 50%;
            border-radius: 50%;
            object-fit: contain ;
        }
    }

    .info-topic{
        flex: 1;
        // display: flex;
        // flex-direction: column;
    }
}



</style>