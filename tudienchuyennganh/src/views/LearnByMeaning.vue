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

    </div>

    <div class="main-word">
        <h1 class="current-word">Trời ơi</h1>
        <div class="temporary"></div>
    </div>


    <div class="body">
        
        <div class="result-cover">
            <button type="button" class="option">1 xác</button>
            <button type="button" class="option">2 xác</button>
            <button type="button" class="option">3 xác</button>
            <button type="button" class="option">4 xác</button>
        </div>

        <div class="levels">
            level 1
        </div>
    </div>
    
  </div>
</template>

<script>
export default {
    data(){
        return{
            currentScore: '100'
        }
    }
}
</script>

<style lang="scss" scoped>
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

.body{
    display: flex;

    .result-cover{
        display: flex;
        flex-wrap: wrap;
        align-items: center;
        justify-content: space-evenly;
        
        background-color: aquamarine;
        height: 200px;
        width: 90%;

    }

    .option{
        height: 60px;
        border-radius: 20px;
        width: 500px;   
        border: 1px solid var(--normal);
        background-color: var(--tints-90);
        transition: all 500ms;

        &:hover{
            font-size: 25px;

        }
    }

    .levels{
        flex: 1;
        display: flex;
        align-items: flex-start;
        justify-content: center;
        border-radius: 10px;
    }
    
}
</style>