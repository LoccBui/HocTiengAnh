<template>
    <v-card>
      <v-layout>
        <v-navigation-drawer
          expand-on-hover
          rail
        >
          <v-list>
            <v-list-item
              :title="nameUser"
              :subtitle="emailUser"             
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
import axiosInstance from '../axios'

import { inject, toRefs  } from "vue";
import router from "@/router";

import {authenticate} from '@/GlobalFunction/Authenticate.js'
import {dataUser} from '@/GlobalFunction/script.js'

export default {
  
    setup(props) {
      const { isSignIn } = toRefs(props);

      const Vue3GoogleOauth = inject("Vue3GoogleOauth");
          return{
              Vue3GoogleOauth,
              isSignIn
          }

      },

    mixins: [dataUser],  // get userData from global function

    data(){
        
        return {
            emailUser: '',
            nameUser: '',
            menuListItem: [
              {icon: 'mdi-magnify', title: 'Tra từ', value: '1', route: '/searching'},
              {icon: 'mdi-school', title: 'Học từ', value: '2', route: '/learning'},
              {icon: 'mdi-bookshelf', title: 'Chủ đề', value: '3', route: '/topic'},
              {icon: 'mdi-account', title: 'Quản lý tài khoản', value: '4', route: '/account'},
              {icon: 'mdi-account-group ', title: 'Quản lý lớp', value: '4', route: '/class'},
              {icon: 'mdi-logout  ', title: 'Đăng xuất', value: '5', route: '', action: 'logOut' }
            ]
        }
    },

    mounted(){
    },

    created(){
      var dataUser = JSON.parse(localStorage.getItem('dataUser'))
      
      
      this.emailUser = dataUser.email
      this.nameUser = dataUser.name
    },

    methods:{
      menuActionClick(action){
        if(action == 'logOut'){
          this.logOut()
        }
      },

      logOut(){
        this.Vue3GoogleOauth.isAuthorized = !this.Vue3GoogleOauth.isAuthorized  
        router.push('/login')
      },

      getDataUser(){
          
      }


    }
  
}
</script>

<style lang="scss" scoped>

</style>
