<template>
   <div style="width:1000px; height: 500px;">
        <router-link to="/login">link login</router-link>

        <iframe style="border:0; padding:0;width:100vw;height:1000px;" src="https://dict.laban.vn/widget/widget?w=1500&h=1000&hl=2&th=3"></iframe>
    </div>
</template>

<script>
export default {
    mounted(){
        this.changeTitle()

    },

    methods:{
      changeTitle(){
        document.title = "Tra từ"
      },

    }
}
</script>

<style lang="scss" scoped>
.poweredby {
  display: none  !important;
}

</style>