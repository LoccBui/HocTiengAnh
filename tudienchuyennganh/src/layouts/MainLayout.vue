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
  
          <v-list density="compact" nav  v-for="item in menuListItem" :key="item.value"  @click="menuActionClick(item.action)" >
              <v-list-item 
              :prepend-icon="`${item.icon}`" 
              :title="`${item.title}`" 
              :value="`${item.value}`" 
              router :to="`${item.route}`"
              @click="`${item.func}`">
            </v-list-item> 
          </v-list>
        </v-navigation-drawer>
  

        <v-main style="height: 100vh">
          <div style="width:100%">
            <router-view></router-view>
          </div>
        </v-main>

      </v-layout>
    </v-card>
  </template>
  

<script>

import { inject, toRefs  } from "vue";
import router from "@/router";

import {authenticate} from '@/GlobalFunction/Authenticate.js'

export default {
  
    setup(props) {
      const { isSignIn } = toRefs(props);

      const Vue3GoogleOauth = inject("Vue3GoogleOauth");
          return{
              Vue3GoogleOauth,
              isSignIn
          }

      },
    mixins: [authenticate], 

    data(){
        return {
            menuListItem: [
              {icon: 'mdi-magnify', title: 'Tra từ', value: '1', route: '/searching'},
              {icon: 'mdi-school', title: 'Học từ', value: '2', route: '/learning'},
              {icon: 'mdi-bookshelf', title: 'Chủ đề', value: '3', route: '/topic'},
              {icon: 'mdi-account', title: 'Quản lý tài khoản', value: '4', route: '/account'},
              {icon: 'mdi-account-group ', title: 'Quản lý lớp', value: '4', route: '/account'},
              {icon: 'mdi-logout  ', title: 'Đăng xuất', value: '5', route: '', action: 'logOut' }
            ]
        }
    },

    mounted(){
      // this.checkAuth()   
       
    },

    methods:{
      menuActionClick(action){
        if(action == 'logOut'){
          this.logOut()
        }
      },

      logOut(){
        this.Vue3GoogleOauth.isAuthorized = !this.Vue3GoogleOauth.isAuthorized
        
        localStorage.removeItem("authorized");
        router.push('/login')
      },

      checkAuth(){
        let auth = localStorage.getItem("authorized")
        
        authenticate.auth(auth, 'topic', 'register')
       }


    }
  
}
</script>

<style lang="scss" scoped>

</style>
