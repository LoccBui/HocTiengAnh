<template>
    <v-card>
      <v-layout>
        <v-navigation-drawer
          expand-on-hover
          rail
        >
          <v-list>
            <v-list-item
              prepend-avatar="https://randomuser.me/api/portraits/women/85.jpg"
              title="Sandra Adams"
              subtitle="sandra_a88@gmailcom"
            ></v-list-item>
          </v-list>
  
          <v-divider></v-divider>
  
          <v-list density="compact" nav  v-for="item in menuListItem" :key="item.value" >
            <v-list-item 
            :prepend-icon="`${item.icon}`" 
            :title="`${item.title}`" 
            :value="`${item.value}`" 
            router :to="`${item.route}`">
          </v-list-item>

            <!-- <v-list-item prepend-icon="mdi-account" title="My Files" value="myfiles"
            router to="/test"
            >          
            </v-list-item>
            <v-list-item prepend-icon="mdi-school" title="Học từ" value="shared"
            router to="/learning"
            ></v-list-item>
            <v-list-item prepend-icon="mdi-star" title="Starred" value="starred"></v-list-item> -->
          </v-list>
        </v-navigation-drawer>
  

        <v-main style="height: 1200px">
          <router-link to="/login">link login</router-link>
          <h1>Content sẽ xuất hiện tại ađây ha</h1>

          <div style="width:100%; height: 100%;background-color: aquamarine;">
            <router-view></router-view>
          </div>


            <!-- <div style="width:1000px; height: 500px;">
                <iframe style="border:0; padding:0;width:100vw;height:1000px;" src="https://dict.laban.vn/widget/widget?w=1500&h=600&hl=2&th=3"></iframe>
            </div> -->

            <!-- Youlish limited our search -->
            <!-- <div>
              <iframe allow="autoplay" id="fr_yg-widget-0" class="ygFrame" scrolling="yes" style="position: static; visibility: visible; display: inline-block; padding: 0px; border: none; max-width: 100%; margin-top: 0px; margin-bottom: 1px; width: 100%; height:1000px;" src="https://youglish.com/pronounce/great%2520power/english/all/emb=1&amp;e_id=yg-widget-0&amp;e_comp=8415&amp;e_zones=all,us,uk,aus&amp;e_h=-1&amp;e_notif_h=1&amp;e_bg_color=theme%5Flight"></iframe>
            </div> -->
        </v-main>

      </v-layout>
    </v-card>
  </template>
  

<script>
export default {
    data(){
        return {
            abc: ``,
            menuListItem: [
              {icon: 'mdi-magnify', title: 'abc', value: '1', route: '/title'},
              {icon: 'mdi-account', title: 'My Files', value: '2', route: '/learning'},
              {icon: 'mdi-school', title: 'Học từ', value: '3'},
              {icon: 'mdi-star', title: 'Starred', value: '4'}
            ]
        }
    },

    mounted(){
      
    },

    methods:{
      logg(){
        alert(1)
      },


    }
  
}
</script>

<style lang="scss" scoped>

</style>
