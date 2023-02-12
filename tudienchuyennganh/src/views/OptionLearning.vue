<template>
    <div class="overlay">
        <div class="cover">
            
            <div class="header">
                <div class="temporary"></div>
                <v-icon @click="closeOption()">mdi-close</v-icon>
            </div>
            
            <h1> Tên chủ đề </h1>
            <h1> Miêu tả </h1>
            


            <h1>Bài học đang đợi bạn</h1>
            <v-btn color="primary" width="200px" rounded>Học</v-btn>

            <br>

            <h1>Luyện tập thôi nào</h1>

            <v-btn color="primary" rounded>
                <v-icon>mdi-history</v-icon>
            </v-btn>
            <v-btn color="primary" rounded>
                <v-icon>mdi-alert-circle</v-icon>
            </v-btn>
            
        </div>
    </div>
</template>

<script>
export default {
    name: 'OptionLearning',
    data(){
        return{

        }
    },

    methods: {
        closeOption(){
            this.$emit('close-option')
        }
    }
}
</script>

<style lang="scss" scoped>

.overlay{
    position: fixed;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    z-index: 1;
    background-color: rgba(0,0,0, 0.4);
}

.cover{
    position: absolute;
    width: 500px;
    height: 500px;
    background-color: white;
    box-shadow: rgba(0, 0, 0, 0.24) 0px 3px 8px;
    border-radius: 10px;
    padding: 20px;
    line-height: 40px;

    z-index: 2;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
}

.header{
    display: flex;
    justify-content: space-between;
}
</style>