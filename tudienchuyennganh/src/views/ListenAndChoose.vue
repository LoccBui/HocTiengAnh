<template>
  <div class="container"> 

    <div class="header"> 
      <h1 class="w80">Nghe và chọn kết quả</h1>
      <div class="w20">
        <el-button color="#0038FF"  @click="this.finishLearn()"> 
          <v-icon>mdi-arrow-right-thick</v-icon>
          Tiếp theo 
        </el-button>
      </div>
    </div>

    <div>
      <div>
        <h1 class="w80 question-text">Chiến thắng</h1>
      </div>
      <div class="w20"></div>
    </div>

    <div class="learning-wrapper">

      <div class="left-side-learning">

          <div class="options">

            <el-button color="var(--main-color)" >
              <v-icon> mdi-volume-high </v-icon>
              
            </el-button>

            <el-button color="var(--main-color)" >
              <v-icon> mdi-volume-high </v-icon>
              
            </el-button>

            <el-button color="var(--main-color)" >
              <v-icon> mdi-volume-high </v-icon>
              
            </el-button>

            <el-button color="var(--main-color)" >
              <v-icon> mdi-volume-high </v-icon>
              
            </el-button>

            <el-button color="var(--main-color)" >
              <v-icon> mdi-volume-high </v-icon>
              
            </el-button>

            <el-button color="var(--main-color)" >
              <v-icon> mdi-volume-high </v-icon>
              
            </el-button>

          </div>
      </div>

      <div class="right-side-learning">
        level 2
      </div>

    </div>
</div>
</template>

<script>
export default {
  methods:{
    finishLearn(){
        console.log('emit')
        this.$emit('finish-learn')
    }, 
      
  }
}
</script>

<style lang="scss" scoped>

.w80{
  width: 80%;
}

.w20{
  flex: 1;
}

.container{
  width: 100%;
}

.header{
  display: flex;
  height: 80px;

  .el-button{
    width: 100%;
    height: 100%;
  }
}


.question-text{
  font-size: 50px;
  font-weight: 600;
  text-align: center;
}

.learning-wrapper{
  display: flex;
  align-items: center;
  background-color: khaki;
  width: 100%;
  height: 500px;

  .left-side-learning{
    width: 80%;

    .options{
      background-color: olive;
      display: flex;
      flex-wrap: wrap;
      justify-content: space-between;


      .el-button {
        font-size: 40px;
        height: 80px;
        margin: 20px 0;
        flex-basis: 40%;
      }
    }
  }

  .right-side-learning{
    flex: 1;
    background-color: tan;
  }
}


</style>