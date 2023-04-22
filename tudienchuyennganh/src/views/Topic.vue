<template>
    <div class="container">

    <div>
        <h1 class="txt-20 m-ud-8">Kho từ chung</h1>
    </div>

    <div class="wrapper">

        <div class="topic-cover" v-for="topic in dataTopicsAPI[0]" :key="topic.TopicID">
            <div class="body-info" >
                <div class="left-info" >

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

                <div class="temporary"></div>

                <div class="right-info">

                    <el-button size="large" color="var(--main-color)" @click="this.$router.push(`learning/topicid=${topic.TopicID}`)"
                    >Học
                    </el-button>
                </div>
            </div>

        </div>
    </div>

    <el-divider /> 
    <div>
        <h1 class="txt-20 m-ud-8">Kho từ của tôi</h1>
    </div>

    <div class="wrapper">

        <div class="topic-cover" v-for="topic in dataPersonalVocabAPI" :key="topic.PersonalVocabID">
            <div class="body-info" >
                
                <div class="left-info" >

                    <div class="info-topic">
                        <h1>{{ topic.PersonalVocabName }}</h1>
                    
                        <v-progress-linear
                        model-value= 30
                        :buffer-value="bufferValue"
                        height="20"
                        color="var(--main-color)"
                        rounded
                        ></v-progress-linear>
                    </div>
                </div>

                <div class="temporary"></div>

                <div class="right-info">
                    <el-button size="large" color="var(--main-color)" @click="this.$router.push(`learning/topicid=${topic.PersonalVocabID}`)"   
                    >Ôn
                    </el-button>
                </div>
            </div>

        </div>
    </div>


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
            dataTopicsAPI: [],
            accountID: '',
            showSinhVienForm: false,
            showGiaoVienForm: false,
            dataPersonalVocabAPI: '',

        }
    },

    mounted(){
        this.handleNewUser()
        this.changeTitle()
        this.getDataTopic()
    

        this.getPersonalVocab()


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
                this.showSinhVienForm = false
            }
            else{
                window.location.href = '/login'
            }

        },
        
        //lấy data từ emitter
        handleDataUser(data){
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

        handleFinishForm(){
            this.showSinhVienForm = false
            this.showGiaoVienForm = false
            window.location.reload()
        },

        getPersonalVocab(){
            axiosInstance.post('getPersonalVocab', {
                "AccountID": this.accountID
            })
            .then((res) => {
                this.dataPersonalVocabAPI = res.data
            })
        },
        

    }
}
</script>

<style lang="scss" scoped>

.container{
    min-height: 700px;
    padding: 2%;

}

.wrapper{
    display: flex;
    justify-content: start;
    align-items: start;
    flex-wrap: wrap;
}


.topic-cover{
    min-height: 200px;
    max-width: 400px;
    min-width: 400px;
    border: 1px solid transparent;
    border-radius: 15px;
    line-height: 50px;
    box-shadow: rgba(0, 0, 0, 0.24) 0px 3px 8px;

    display: flex;
    align-items: center;
    justify-content: center;
    padding: 2%;


    .body-info{
        width: 100%;
        height: 100px;
        display: flex;
        align-items: center;
        justify-content: center;

        .left-info{
            width: 50%;
        }
    
        .temporary{
            width: 10%;
        }

        .right-info{
            flex: 1;
            height: 100%;
            .el-button{
                width: 100%;
                height: inherit;
            }
        }
    }



    .info-topic{
        flex: 1;
    }
}

.topic-cover + .topic-cover{
    margin: 0 20px;
}



</style>