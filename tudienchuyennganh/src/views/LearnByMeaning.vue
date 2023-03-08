<template>
  <div class="container">

    <div class="header">

        <v-progress-linear
            model-value= 80
            :buffer-value="bufferValue"
            height="50"
            value="20"
            color="#0038FF"
            rounded
            >
        </v-progress-linear>

        <div class="temporary"></div>

       <div class="score-cover">
            {{ currentScore }}
       </div>

    </div>

    <div class="sub-header">
        <span class="sub-header-text"> Chọn kết quả đúng nhất</span>
        <div class="status-learn">
            <v-icon>mdi-check</v-icon>
            <h1>Chính xác</h1>
        </div>

        <el-button :type="statusAnswer">ok</el-button>

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
                >{{ option.Word }}
            </button>
        </div>

        <div class="levels">
            level 1
        </div>
    </div>
    
  </div>
</template>

<script>
export default {
    props: ['listWord'],
    data(){
        return{
            currentScore: '100',
            titleQuestion: '',
            statusAnswer: 'default',
        }
    },

    mounted(){
        this.randomQuestion()
    },


    methods:{
        chooseAnswer(chooseAnswer){
            console.log("choose", chooseAnswer)
            console.log("answer", this.titleQuestion)


            if(chooseAnswer === this.titleQuestion){
                this.statusAnswer = 'success'
                setTimeout(() => {
                    this.randomQuestion()
                },1000)
            }else{
                this.statusAnswer = 'danger'
                setTimeout(() => {
                    this.randomQuestion()
                },1000)

            }
        },

        randomQuestion(){
            this.statusAnswer = 'default'

            const random = Math.floor(Math.random() * this.listWord.length);
            this.titleQuestion = this.listWord[random].Word 

        }
    }
}
</script>

<style lang="scss" scoped>
.container{
    width: 100%;
    height: 100vh;
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
}

.sub-header{
    display: flex;
    justify-content: space-between;
    padding: 20px 0px;

    .sub-header-text{
        font-size: 20px;
    }

    .status-learn{
        background-color: var(--success);
        padding: 40px;
        width: 10%;
        text-align: center;
        color: var(--light-blue-90);
        border-radius: 10px;
        
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
        height: 60px;
        border-radius: 20px;
        border: 1px solid var(--normal);
        background-color: var(--tints-90);
        transition: all 200ms;

        &:hover{
            font-size: 25px;
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