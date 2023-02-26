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
import emitter from '../eventBus.js'

export default {
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
      emitter.on('data', this.getDataUser);
    },

    beforeDestroy() {
      emitter.off('data')
    },

    methods:{
      menuActionClick(action){
        if(action == 'logOut'){
          this.logOut()
        }
      },

      getDataUser(data){
        console.log("data emit", data)
        this.emailUser = data.email
        this.nameUser = data.name   
      },

      logOut(){
        window.location.href = '/login'
      },
    }
  
}
</script>

<style lang="scss" scoped>

</style>
