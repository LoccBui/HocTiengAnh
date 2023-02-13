import {defineStore} from 'pinia'

export const useTestStore = defineStore('test', {
    state: () => {
        return{
            username: null
        }
    }, 
    actions:{
        changeUsername (payload) {
            this.username = payload
        }
    }
})