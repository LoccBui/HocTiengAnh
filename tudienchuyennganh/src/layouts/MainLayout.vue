<template>
    <v-card>
      <v-layout>
        <v-navigation-drawer
          expand-on-hover
          rail
          permanent 
        >
          <v-list>
            <v-list-item
              :title="nameUser"
              :subtitle="emailUser"             
            ></v-list-item>
          </v-list>
  
          <v-divider></v-divider>
  
          <v-list 
          density="comfortable" nav  v-for="item in menuListItem" :key="item.value"  @click="menuActionClick(item.action)" 
          
          >
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
import axiosInstance from '../axios'

export default {
    data(){     
        return {
            emailUser: '',
            nameUser: '',
            accountID: '',

            menuListItem: [
              {icon: 'mdi-magnify', title: 'Tra từ', value: '1', route: '/searching'},
              {icon: 'mdi-school', title: 'Học từ', value: '2', route: '/learning'},
              {icon: 'mdi-bookshelf', title: 'Chủ đề', value: '3', route: '/topic'},
              {icon: 'mdi-account', title: 'Quản lý tài khoản -  GV and SV', value: '4', route: '/account'},
              {icon: 'mdi-account-group ', title: 'Quản lý lớp - Admin', value: '5', route: '/class'},
              {icon: 'mdi-alpha-v-circle ', title: 'Quản lý tài khoản - Admin', value: '6', route: '/manage/vocab'},
              {icon: 'mdi-alpha-v-circle ', title: 'Quản lý từ vựng', value: '7', route: '/manage/vocab'},

              // maybe more
              {icon: 'mdi-alpha-v-circle ', title: 'Quản lý từ vựng', value: '8', route: '/manage/vocab'},
              {icon: 'mdi-logout  ', title: 'Đăng xuất', value: '5', route: '', action: 'logOut' }
            ]
        }
    },

    mounted(){
      emitter.on('data', this.handleDataUser);

      // this.getTopic()
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

      handleDataUser(data){

        let dataUser = {
            MaGV: '',
            accountID: '',
            email: '',
            name: ''
        }
        
        dataUser.MaGV = data.MaGV 
        dataUser.accountID= this.accountID = data.accountID 
        dataUser.email = this.emailUser = data.email
        dataUser.name = this.nameUser = data.name   

        localStorage.setItem('userInfo', JSON.stringify(dataUser))


       



        console.log("main",data)

      },

      getTopic(){
        axiosInstance.get(`getTopic/id=${this.accountID}`)
          .then(res => console.log(res))

      },

      logOut(){
        window.location.href = '/login'
      },
    }
  
}
</script>

<style lang="scss" scoped>

</style>
