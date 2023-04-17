<template>
    <div class="container">

        
        <h1>Tên chủ đề</h1>
        <div class="owner-area" >
            <el-button color="var(--main-color)" size="medium" v-for="topic in arrOwnerTopic" :key="topic.TopicID" @click="changeTopicAnalyst(topic)"> {{ topic.TopicName }} </el-button>
        </div>

        <el-divider />
        <h1> Đây là khu vực phân tích</h1>


        <div class="analyst-cover">

            <div class="analyst-area">
                Từ sai nhiều nhất
               <div  v-loading="loading"
                    element-loading-text="Chưa có dữ liệu..."
                    element-loading-background="#e6ebff">
                    
                    <div v-for="word in arrWrongWord" :key="word.VOCABID"   class="ranking-cover">
                        <div class="w80">
                            <span> {{ word.VocabID }} - </span>
                            <span> {{ word.Word }}</span>
                        </div>

                        <div class="right-side w20">
                            <span> {{ word.TotalWrong }}</span>
                        </div>
                    </div>
               </div>

            </div>


            <div class="analyst-area">
                Sinh viên nhiều điểm nhất

                <div v-if="notHaveData">Chưa có dữ liệu</div>

                <el-table
                    :data="arrMostScore"
                    style="width: 100%"
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

            <div class="analyst-area">
                Bảng xếp hạng
                <div v-loading="loading"
                    element-loading-text="Chưa có dữ liệu..."
                    element-loading-background="#e6ebff"
                >
                
                </div>
            </div>


        </div>










        
        <img src="https://img.timviec.com.vn/2021/02/dashboard-la-gi-2.jpg" alt="">

        <div>
            <img src="https://images.klipfolio.com/website/public/52e06bbd-9d6a-4c7c-b267-43b2302c375d/Digital%20Marketing.png" alt="">
        </div>

        <span><img src="https://images.klipfolio.com/website/public/92def65c-d0fc-47bf-86e7-b90b709f8158/social-media-dashboard.png" alt=""></span>
        <span><img src="https://images.klipfolio.com/website/public/8be365cb-7c1b-4a4e-a90d-f588f0553be1/marketing%20dashboard.png" alt=""></span>

    </div>
</template>

<script>
import axiosInstance from '../axios'
export default {
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
            let dataUser = JSON.parse(localStorage.getItem('userInfo'))

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
        width: 100%;
        display: flex;
        align-items: center;
        justify-content: space-around;
    }

    .analyst-area{
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
