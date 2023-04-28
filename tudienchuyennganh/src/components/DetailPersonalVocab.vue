<template>
  <div class="container">
    <el-dialog
        v-model="dialogVisible"
        title="Chi tiết bộ từ"
        width="30%"
        :before-close="handleClose"
        fullscreen
        destroy-on-close
    >
        <el-input v-model="inputPersonalVocabName" :placeholder="dataPersonalVocab.PersonalVocabName" @input="this.checkChange()" />


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
            <el-button size="large" @click="handleClose">Đóng</el-button>
            <el-button size="large" color="var(--main-color)" @click="confirm()">
            Xác nhận
            </el-button>
        </span>
        </template>
    </el-dialog>

    <AskBox 
        v-if="warnDelete"
        :title="'Bạn có muốn xóa từ này ?'"
        :typeButton="'danger'"
        :btnYes="'Xóa'"
        @confirm="deleteVocab"
        @close="this.warnDelete = false"
    />


    </div>
</template>

<script>
import axiosInstance from '@/axios'
import AskBox from '@/components/AskBox.vue'
import { ElNotification } from 'element-plus'

export default {
    components: {AskBox},

    props: ['dataVocabID', 'accountID','dataPersonalVocab'],

    data(){
        return{
            dialogVisible: true,
            search: '',
            dataPersonalVocabAPI: '',
            inputPersonalVocabName: '',

            warnDelete: false,
            idVocabDelete: '',
            detailID: '',
            isChange: false,
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

        showNotification(title ,message, type){
            ElNotification({
                title: `${title}`,
                message: `${message}`,
                type: `${type}`,
            })
        },

        handleClose(){
            this.$emit('close')
        },


        handleDeleteVocab(dataVocab){
            this.detailID = dataVocab.PersonalDetailID
            this.idVocabDelete = dataVocab.VocabID
            this.warnDelete = true
        },


        deleteVocab(){
            axiosInstance.post('deleteVocabOfCollection',{
                "AccountID": this.accountID,
                "PersonalDetailID": this.detailID
            })
            .then(() => {
                this.warnDelete = false
                this.getDataPersonVocab()
                this.showNotification('Thông báo', 'Xóa thành công', 'success')
            })
        },

        checkChange(){
          this.isChange = true
        },

        confirm(){
            if(this.isChange){
                axiosInstance.patch('changeCollectionName', {
                    "PersonalVocabID": this.dataVocabID,
                    "PersonalVocabName": `${this.inputPersonalVocabName}`
                })
                .then( () => {
                    this.$emit('update')
                    this.showNotification('Thông báo', 'Cập nhật thành công', 'success')
                })
            }
            else{
                this.handleClose()
            }
        }

    }
}
</script>

<style lang="scss" scoped>

</style>
