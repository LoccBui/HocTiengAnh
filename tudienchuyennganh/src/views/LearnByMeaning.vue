<template>
  <div class="container">

    <div class="header">
        <el-progress :text-inside="true" :stroke-width="26" :percentage="progressPercent" />

        <div class="temporary"></div>

       <div class="score-cover">
            {{ totalScore }}
       </div>

    </div>

    <div class="sub-header">
        <span class="sub-header-text"> Chọn kết quả đúng nhất</span>
        <div class="status-learn">
            <el-alert :title="statusText" :type="statusAnswer" :closable="false" effect="dark" show-icon />
        </div>
    </div>

    <div class="main-word">
        <h1 class="current-word">{{ titleQuestion }}</h1>
        <div class="temporary"></div>
    </div>


    <div class="options-choose-cover">
        
        <div class="result-cover">
            <button
                type="button" 
                class="option" 
                v-for="option in listWord" :key="option"
                @click="this.chooseAnswer(option.Word)"
                >{{ option.Vietnamese }}
            </button>
        </div>


        <div class="levels">
            {{ titleQuestion.Level }} 1
        </div>
    </div>
    
  </div>
</template>

<script>
export default {
    props: ['listWord'],
    data(){
        return{
            totalScore: 0,
            titleQuestion: '',
            statusAnswer: 'info',
            statusText: 'Kết quả',

            progressLength: '',
            progressPercent: 0
        }
    },

    mounted(){
        this.randomQuestion()
        this.progressLength = this.listWord.length
    },


    methods:{
        chooseAnswer(chooseAnswer, id){

            if(chooseAnswer === this.titleQuestion){
                this.statusAnswer = 'success'
                this.statusText = 'Chính xác'

                this.progressPercent += ( 100 / this.progressLength ) 
                this.totalScore += 100
                console.log("SOCRE", this.totalScore)

                if(this.progressPercent == 100){
                    alert('correct all')
                }

                setTimeout(() => {
                    this.randomQuestion()
                },1000)

            }
            else{
                this.statusAnswer = 'error'
                this.statusText = 'Không đúng'



                setTimeout(() => {
                    this.randomQuestion()
                },1000)
            }
        },

        randomQuestion(){
            this.statusAnswer = 'info'
            this.statusText = 'Kết quả'

            const random = Math.floor(Math.random() * this.listWord.length);
            this.titleQuestion = this.listWord[random].Word 

        }
    }
}
</script>

<style lang="scss" scoped>
.container{
    width: 100%;
}

.header{
    display: flex;
    align-items: center;

    .score-cover{
        
        border-radius: 20px;
        background-color: var(--tints-80);
        padding: 10px 0px;
        text-align: center;
        width: 12%;
    }

    .el-progress{
        width: 100%;
    }
}

.sub-header{
    display: flex;
    justify-content: space-between;
    padding: 20px 0px;

    .sub-header-text{
        font-size: 20px;
    }

    .status-learn{
        background-color: var(--tints-80);
        height: 200px;
        width: 10%;
        text-align: center;
        color: var(--light-blue-90);
        border-radius: 10px;
        z-index: 10;
        
    }

    .el-alert {
        height: 100%;
    }

}

.main-word{
    .current-word{
        font-size: 50px;
        width: 90%;
        text-align:center ;
    }
}

.temporary{
    width: 10%;
}

.options-choose-cover{
    width: 100%;
    height: auto;
    padding: 20px;
    display: flex;
    background-color: cadetblue;


    .result-cover{
        width: 90%;
        background-color: yellowgreen;
        height: auto;
        display: flex;
        flex-wrap: wrap;
        align-items: center;
        justify-content: space-around;
        
    }

    .option{
        width: 35%;
        height: 70px;
        border-radius: 20px;
        border: 1px solid var(--normal);
        background-color: var(--tints-90);
        word-break: keep-all;
        text-align: center;
        transition: all 200ms;

        &:hover{
            font-size: 20px;
        }     
    }

    .levels{
        width: 10%;
        height: 200px;
        border-radius: 10px;
        background-color: blueviolet;
        ;
    }
    
}
</style>