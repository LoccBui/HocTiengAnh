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
export default {
    data(){
        return {
            abc: ``,
            menuListItem: [
              {icon: 'mdi-magnify', title: 'Tra từ', value: '1', route: '/searching'},
              {icon: 'mdi-school', title: 'Học từ', value: '3', route: '/learning'},
              {icon: 'mdi-account', title: 'My Files', value: '2', route: '/learning'},
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
