<template>
    <div class="container">

        
        <h1>Tên chủ đề</h1>
        <div class="owner-area" >
            <el-button color="var(--main-color)" size="medium" v-for="topic in arrOwnerTopic" :key="topic.TopicID" @click="changeTopicAnalyst(topic)"> {{ topic.TopicName }} </el-button>
        </div>

        <el-divider />

        <div class="analyst-cover">

            <div class="analyst-area">
                Từ sai nhiều nhất
               <el-table v-loading="loading"
                    :data="arrWrongWord"
                    style="width: 100%; min-height: 200px; max-height: 200px; overflow-y: scroll ;"
                    element-loading-text="Chưa có dữ liệu..."
                    element-loading-background="#e6ebff">

                    <el-table-column type="index" :index="indexMethod"/>
                    <el-table-column prop="Word" label="Từ vựng" fit/>
                    <el-table-column prop="TotalWrong" label="Số lần sai" fit/>
               </el-table>

            </div>


            <div class="analyst-area">
                Sinh viên nhiều điểm nhất

                <div v-if="notHaveData">Chưa có dữ liệu</div>

                <el-table
                    :data="arrMostScore"
                    style="width: 100%; min-height: 200px; max-height: 200px; overflow-y: scroll ;"
                    v-loading="loading"
                    element-loading-text="Chưa có dữ liệu..."
                    element-loading-background="#e6ebff"
                    align="center"
                    size="small"
                >
                    <el-table-column type="index" :index="indexMethod" />
                    <el-table-column prop="Name" label="Họ và tên" fit/>
                    <el-table-column prop="ClassName" label="Lớp"  />
                    <el-table-column prop="TotalScore" label="Tổng điểm"  />
                </el-table>

            </div>

 
        </div>

    </div>
</template>

<script>
import axiosInstance from '../axios'
import { requireTokenMixin } from '@/mixin/requireTokenMixin'
import Cookies from 'js-cookie';


export default {
    mixins:[requireTokenMixin],
    data(){
        return{
            accountID: '',
            selectedTopicID: '',
            arrOwnerTopic: [],

            arrWrongWord: [],
            arrMostScore: [],

            loading: false
        }
    },

    mounted(){
        this.handleDataLocal()

        this.getTopic()
    },

    computed:{
        indexMethod(index){
            console.log(index)
        }
    },

    methods:{
        handleDataLocal(){
            let dataUser = JSON.parse(Cookies.get('userInfo'))
            this.accountID = dataUser.accountID
        },

        async getTopic(){
            let result = await axiosInstance.get(`getTopic/${this.accountID}`)

            if(result.status == 200){
                this.arrOwnerTopic = (result.data)
                this.selectedTopicID = result.data[0].TopicID
                this.handleAnalyst()
            }
        },

        handleAnalyst(){
            this.getMostWrongWord()
            this.getMostScore()

        },

        async getMostWrongWord(){
            try{

                let result = await axiosInstance.post('wrongTimesTopic', {
                    "TopicID": this.selectedTopicID
                })

                if(result.status == 200){
                    this.loading = false
                    this.arrWrongWord = result.data
                }
            }
            catch(e){
                this.loading = true
            }

        },

        async getMostScore(){
            try{
                let result = await axiosInstance.post('topicScore', {
                    "TopicID": this.selectedTopicID
                })

                if(result.status == 200){
                    this.loading = false
                    this.arrMostScore = result.data
                }
            }
            catch(e){
                this.loading = true
            }
            
        },

        changeTopicAnalyst(data){
            this.selectedTopicID = data.TopicID
            console.log(this.selectedTopicID)
            this.handleAnalyst()
        }



    }
}
</script>

<style lang="scss" scoped>
    .container{
        min-height: 600px;
        padding: 2%;
    }

    .owner-area{
        display: flex;
        align-items: start;
        padding: 1%;
        box-shadow: rgba(0, 0, 0, 0.24) 0px 3px 8px;
        border-radius: 15px;        
    }

    .owner-area + .owner-area {
        margin-top: 2%;
    }

    .analyst-cover{
        width: 500px;
        display: flex;
        align-items: center;
    }

    .analyst-area{
        width: 600px;
        flex: 1;
        margin: 0 20px;
        padding: 2%;
        box-shadow: rgba(0, 0, 0, 0.24) 0px 3px 8px;
        border-radius: 15px;   
        background-color: var(--main-color);
        color: white;
        font-weight: 800;
        text-transform: uppercase;
    }

    .ranking-cover{
        display: flex;

        .right-side{
            text-align: end;
        }
    }

</style>
