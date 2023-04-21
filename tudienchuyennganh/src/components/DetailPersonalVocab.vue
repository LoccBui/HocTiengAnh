<template>
  <div class="container">
    <el-dialog
        v-model="dialogVisible"
        title="Tips"
        width="30%"
        :before-close="handleClose"
        fullscreen
        destroy-on-close
    >
        <el-input v-model="inputPersonalVocabName" :placeholder="dataPersonalVocab.PersonalVocabName" />


        <el-table 
            :data="filterPersonalVocab" 
            :default-sort="{ prop: 'VocabID', order: 'ascending' }"
            empty-text="Không có dữ liệu"
            max-height="500px"
        >
    
        <el-table-column label="ID" prop="VocabID" width="50" sortable/>
        <el-table-column label="Word" prop="Word" />
        <el-table-column label="IPA" prop="IPA" />
        <el-table-column label="Label" prop="Label" />
        <el-table-column label="Lemma" prop="Lemma" />
        <el-table-column label="Vietnamese" prop="Vietnamese" />
        <el-table-column label="Cluster" prop="Cluster" />
        <el-table-column label="Position" prop="Position" />
        <el-table-column label="Example" prop="Example" />
        <el-table-column label="VN_Example" prop="VN_Example" />


        <el-table-column>
    
            <template #header>
            <el-input v-model="search" size="large" placeholder="Tìm kiếm từ" clearable>
            </el-input>
            </template>
    
            <template #default="scope">
                <el-button
                    size="large"
                    type="danger"
                    @click="handleDeleteVocab(scope.row)"
                    >Xóa
                </el-button>
            </template>
    
        </el-table-column>
        </el-table>






        <template #footer>
        <span class="dialog-footer">
            <el-button @click="dialogVisible = false">Đóng</el-button>
            <el-button type="primary" @click="dialogVisible = false">
            Xác nhận
            </el-button>
        </span>
        </template>
    </el-dialog>
    </div>
    </template>

<script>
import axiosInstance from '@/axios'

export default {
    props: ['dataVocabID', 'accountID','dataPersonalVocab'],

    data(){
        return{
            dialogVisible: true,
            search: '',
            dataPersonalVocabAPI: '',
            inputPersonalVocabName: ''
        }
    },

    computed: {
        filterPersonalVocab(){
          if (!this.search) {
              return this.dataPersonalVocabAPI;
            }
            return this.dataPersonalVocabAPI.filter(cls => cls.Word.toLowerCase().includes(this.search.toLowerCase()));
        }
      },  

    mounted(){
        this.getDataPersonVocab()
    },

    methods:{
        getDataPersonVocab(){
            axiosInstance.post('detailPersonalVocab', {
                "AccountID": this.accountID,
                "PersonalVocabID": this.dataVocabID
            })
            .then((res) => {
                this.dataPersonalVocabAPI = res.data
            })
            .then(()=>{
                this.inputPersonalVocabName = this.dataPersonalVocab.PersonalVocabName
            })
        },

        handleClose(){
            this.$emit('close')
        }
    }
}
</script>

<style lang="scss" scoped>

</style>
