<template>
  <div class="container">
    {{ dataReview }}
    <div class="word-cover" v-for="word in dataReview" :key="word.VocabID">
          {{ word.Word }}
          {{ word.Label }}
          {{ word.Vietnamese }}
          {{ word.Cluster }}
          {{ word.Position }}

          <el-button>Thêm vào từ của tôi</el-button>
    </div>
    
  </div>
</template>

<script>
export default {
    props: ['dataReview'],
    data(){
        return{
            
        }
    },

    mounted(){
    }
}
</script>

<style lang="scss" scoped>
.container{
  width: 100%;
  padding: 20px 0 0 0 !important;
}

.word-cover{
  width: 200px;
  height: 200px;
  padding: 5px;
  border: 1px solid black
}
</style>