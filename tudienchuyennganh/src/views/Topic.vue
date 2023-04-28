<template>
    <div class="container">

    <div>
        <h1 class="txt-20 m-ud-8">Kho từ chung</h1>
    </div>

    <div class="wrapper">

        <div  v-if="loadingTopicData">
            <el-button size="large" plain round color="#7d5b28">
                Hiện chưa có bộ từ vựng nào !
            </el-button>
        </div>

        <div class="topic-cover" v-for="(topic,index) in dataTopicsAPI[0]" :key="topic.TopicID">
            <div class="body-info" >
                <div class="left-info" >

                    <div class="info-topic">
                        <h1>{{ topic.TopicName }}</h1>
                        <el-button plain round type="primary" v-if="dataStatusLearning.length > 0"> 
                            {{ dataStatusLearning[index].TopicID == topic.TopicID ? dataStatusLearning[index].Learned : 0 }} 
                            / 
                            {{ dataStatusLearning[index].TopicID == topic.TopicID ? dataStatusLearning[index].Total : 0 }} từ đã học
                        </el-button>
                    
                        <el-progress v-if="dataStatusLearning.length > 0"
                            color="var(--main-color)"
                            :text-inside="true"
                            :stroke-width="24"
                            :percentage="Math.floor((dataStatusLearning[index].Learned * 100) / dataStatusLearning[index].Total)" 
                        />

                    </div>
                </div>

                <div class="temporary"></div>

                <div class="right-info">

                    <el-button size="large" color="var(--main-color)" @click="this.$router.push(`learning/topicid=${topic.TopicID}`)"
                    >Học
                    </el-button>
                </div>
                <div class="temporary"></div>
            </div>

        </div>

    </div>

    <el-divider /> 
    <div>
        <h1 class="txt-20 m-ud-8">Kho từ của tôi</h1>
    </div>

    <div class="wrapper">

        <div v-if="loadingPersonalData">
            <el-button size="large" plain round color="#7d5b28" @click="this.$router.push(`/manage/personal/${this.accountID}`)">
                Hiện chưa có bộ từ vựng cá nhân nào !
            </el-button>
        </div>

        <div v-else class="topic-cover" v-for="topic in dataPersonalVocabAPI" :key="topic.PersonalVocabID">
            <div class="body-info" >
                
                <div class="left-info" >

                    <div class="info-topic">
                        <h1>{{ topic.PersonalVocabName }}</h1>
                    </div>
                </div>
                

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

import { requireTokenMixin } from '@/mixin/requireTokenMixin'

export default {
    components: {OptionLearning,NewSinhVienForm, NewGiaoVienForm},
    mixins:[requireTokenMixin],
    data(){
        return{
            dataTopicsAPI: [],
            accountID: '',
            showSinhVienForm: false,
            showGiaoVienForm: false,
            dataPersonalVocabAPI: '',
            dataStatusLearning: [],

            progressPercent: '',

            loadingPersonalData: false,

            loadingTopicData: false,

        }
    },

    mounted(){
        this.changeTitle()
        this.handleNewUser()
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
        

        // lấy data topic theo id khoa nhận từ emmitter
        getDataTopic(){
            let dataUser = JSON.parse(localStorage.getItem('userInfo'))
            this.accountID = dataUser.accountID
            
            axiosInstance.get(`getTopic/${this.accountID}`)
                .then(res =>{
                    this.dataTopicsAPI.push(res.data)
                    this.getStatusLearning(res.data)
                    this.loadingTopicData = false
                })
                .catch(() => {
                    this.loadingTopicData = true
                })
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
                    console.log("adadad",res.data)
                    this.dataPersonalVocabAPI = res.data
                    this.loadingPersonalData = false
                })

                .catch(() => {
                    this.loadingPersonalData = true
                })

        },

        getStatusLearning(data){
            for (let i = 0; i <  data.length; i++){
                try{
                    axiosInstance.post('getStatusLearning',
                        {
                            AccountID: this.accountID,
                            TopicID: data[i].TopicID
                        }
                    )
                    .then((res) => {
                        this.dataStatusLearning.push(res.data[0])
                    })
                }
                catch (e) {

                }
            }

        }
        

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
    flex-wrap: wrap;
}



.topic-cover{
    min-height: 200px;
    max-width: 450px;
    min-width: 450px;
    border: 1px solid transparent;
    line-height: 50px;
    box-shadow: rgba(0, 0, 0, 0.3) 0px 3px 8px;
    border-radius: 30px;

    display: flex;
    align-items: center;
    justify-content: center;
    padding: 2%;
    transition: 400ms;

    &:first-child{
        margin: 20px 20px;

    }

    &:hover{
        border-radius: 0px;
        box-shadow: var(--tints-20) 0px 2px 5px;

    }

    & + .topic-cover{
        margin: 20px 20px;
    }


    .body-info{
        width: 100%;
        height: 120px;
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





</style>