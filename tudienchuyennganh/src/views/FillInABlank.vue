<template>
  <div class="container">
    <h1>fill in a blank</h1>
    <el-button type="primary"  @click="this.finishLearn()"> Tiếp theo </el-button>
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

<style>

</style>