<template>
    <div class="container">
        <div class="frame-content">
            <h1 class="heading-text">  404 </h1>
            <h1 class="description-text"> KHÔNG TÌM THẤY TRANG</h1>
            <v-btn
                color="primary"
                height="50px"
                rounded
                @click="backToHomePage"
            >Quay về trang chủ
            </v-btn>
        </div>

        <div class="frame-image">
            <img class="img-not-found" src="../../assets/img/PageNotFound.png" alt="Page Not Found">
        </div>
    </div>
</template>

<script>

export default {
    mounted() {
        this.changeTitle()
    },

    methods:{
        changeTitle(){
            document.title = "Không tìm thấy trang"
        },

        backToHomePage(){
            this.$router.push('/topic')
        }
        
    }
}
</script>

<style lang="scss" scoped>
.container{
    width: 100vw;
    height: 100vh;
    display: flex;
}

.frame-content,
.frame-image{
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
}

.frame-content{
    width: 50%;

    .heading-text{
        font-size: 200px;
        color: var(--main-color);
    }
    
    .description-text{
        font-size: 20px;
    }
}


.frame-image{
    flex: 1;
    .img-not-found{
        max-width: 80%;
    }
}
</style>>
