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

       <div class="score-cover">
            {{ currentScore }}
       </div>

    </div>

    <div class="sub-header">
        <h1>Chọn kết quả đúng nhất</h1>
        <div class="status-learn">
            <h1     >Chính xác</h1>
        </div>

    </div>

    <div class="main-word">
        <h1 class="current-word">Trời ơi</h1>
        <div class="temporary"></div>
    </div>


    <div class="body">
        
        <div class="result-cover">
            <button  type="button" class="option">1 xác</button>
            <button  type="button" class="option">2 xác</button>
            <button  type="button" class="option">3 xác</button>
            <button  type="button" class="option">4 xác</button>
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
    justify-content: center;
    align-items: center;

    .score-cover{
        border-radius: 20px;
        background-color: var(--gray-text);
        padding: 10px;
        width: 10%;
        text-align: center;
    }
}

.sub-header{
    display: flex;
    justify-content: space-between;
    padding: 20px 0px;

    .status-learn{
        background-color: lawngreen;
        padding: 10px;
        width: 10%;
    }
}

.main-word{
    .current-word{
        width: 90%;
        text-align:center ;
    }
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
        background-color: #0038FF;
        border-radius: 20px;
        width: 500px;
    }

    .levels{
        display: flex;
        align-items: center;
        justify-content: center;
        flex: 1;
        background-color: firebrick;
    }
    
}
</style>