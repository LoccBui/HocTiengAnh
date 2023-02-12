<template>
    <div class="container">

        <div class="topic-cover">

            <div class="header-info">
                <div class="image-topic">
                    <img src="../assets/img/default-topic.jpg" alt="Topic Image" class="img-topic">
                </div>

                <div class="info-topic">

                    <h1>Tên chủ đề</h1>
                    <h1> 1/200 từ đã học</h1>
                
                    <v-progress-linear
                    v-model="value"
                    :buffer-value="bufferValue"
                    height="20"
                    value="20"
                    rounded
                    ></v-progress-linear>
                </div>
            </div>

            <div class="body-info">
                <div class="temporary"></div>
                <div class="action-info">
                    <h1 title="Từ cần ôn tập">
                        <v-icon>mdi-history</v-icon> 10 
                    </h1>

                    <h1 title="Từ khó">
                        <v-icon>mdi-alert-circle</v-icon> 20
                    </h1>           
                    
                    <br>

                    <v-btn color="primary" width="100px">Học</v-btn>
                    <v-btn color="primary" @click=" this.showOption = !this.showOption">
                        <v-icon>mdi-dots-vertical</v-icon>
                    </v-btn>
                </div>
            </div>

        </div>

        <div class="topic-cover">

        <div class="header-info">
            <div class="image-topic">
                <img src="../assets/img/default-topic.jpg" alt="Topic Image" class="img-topic">
            </div>

            <div class="info-topic">

                <h1>Tên chủ đề</h1>
                <h1> 1/200 từ đã học</h1>
            
                <v-progress-linear
                v-model="value"
                :buffer-value="bufferValue"
                height="20"
                value="20"
                rounded
                ></v-progress-linear>
            </div>
        </div>

        <div class="body-info">
            <div class="temporary"></div>
            <div class="action-info">
                <h1 title="Từ cần ôn tập">
                    <v-icon>mdi-history</v-icon> 10 
                </h1>

                <h1 title="Từ khó">
                    <v-icon>mdi-alert-circle</v-icon> 20
                </h1>           
                
                <br>

                <v-btn color="primary" width="100px">Học</v-btn>
                <v-btn color="primary" @click="abc()">
                    <v-icon>mdi-menu</v-icon>
                </v-btn>
            </div>
        </div>

        </div>

        <div class="topic-cover">

<div class="header-info">
    <div class="image-topic">
        <img src="../assets/img/default-topic.jpg" alt="Topic Image" class="img-topic">
    </div>

    <div class="info-topic">

        <h1>Tên chủ đề</h1>
        <h1> 1/200 từ đã học</h1>
    
        <v-progress-linear
        v-model="value"
        :buffer-value="bufferValue"
        height="20"
        value="20"
        rounded
        ></v-progress-linear>
    </div>
</div>

<div class="body-info">
    <div class="temporary"></div>
    <div class="action-info">
        <h1 title="Từ cần ôn tập">
            <v-icon>mdi-history</v-icon> 10 
        </h1>

        <h1 title="Từ khó">
            <v-icon>mdi-alert-circle</v-icon> 20
        </h1>           
        
        <br>

        <v-btn color="primary" width="100px">Học</v-btn>
        <v-btn color="primary" @click="abc()">
            <v-icon>mdi-menu</v-icon>
        </v-btn>
    </div>
</div>

        </div>

        <div class="topic-cover">



<div class="header-info">
    <div class="image-topic">
        <img src="../assets/img/default-topic.jpg" alt="Topic Image" class="img-topic">
    </div>

    <div class="info-topic">

        <h1>Tên chủ đề</h1>
        <h1> 1/200 từ đã học</h1>
    
        <v-progress-linear
        v-model="value"
        :buffer-value="bufferValue"
        height="20"
        value="20"
        rounded
        ></v-progress-linear>
    </div>
</div>

<div class="body-info">
    <div class="temporary"></div>
    <div class="action-info">
        <h1 title="Từ cần ôn tập">
            <v-icon>mdi-history</v-icon> 10 
        </h1>

        <h1 title="Từ khó">
            <v-icon>mdi-alert-circle</v-icon> 20
        </h1>           
        
        <br>

        <v-btn color="primary" width="100px">Học</v-btn>
        <v-btn color="primary" @click="abc()">
            <v-icon>mdi-menu</v-icon>
        </v-btn>
    </div>
</div>

        </div>

        <OptionLearning  v-if="showOption"
            @close-option = this.closeOptionBox()
        />
        
    </div>
</template>

<script>
import OptionLearning from './OptionLearning.vue';

export default {
    components: {OptionLearning},
    data(){
        return{
            showOption: false
        }
    },
    methods:{
        closeOptionBox(){
            this.showOption = false
        }
    }
}
</script>

<style lang="scss" scoped>

.container{
    position: relative;
    padding: 20px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-wrap: wrap;
    height: 100vh;
}


.topic-cover{
    flex-basis: 500px;
    max-height: 200px;
    margin: 20px;
    padding: 10px;

    border: 1px solid var(--light-blue-90);
    border-radius: 15px;

    line-height: 50px;

    .header-info{
        display: flex;
    }
    
    .body-info{
        display: flex;
        

        .temporary{
            width: 30%;
        }

        .action-info{
            flex: 1;
            display: flex;
            justify-content: space-around;
            align-items: center;
        }
    }


    .image-topic{
        display: flex;
        align-items: center;
        justify-content: center;
        width: 30%;

        .img-topic{
            width: 50%;
            height: 50%;
            border-radius: 50%;
            object-fit: contain ;
        }
    }

    .info-topic{
        flex: 1;
        // display: flex;
        // flex-direction: column;
    }
}



</style>