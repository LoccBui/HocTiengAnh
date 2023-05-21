import axiosInstance from "@/axios";


export const globalFunc = {
    speakWord: (word) => {
        const listenBtn = document.getElementById('myvoice');
        listenBtn.addEventListener('click', (e) => {
        e.preventDefault();

        const msg = new SpeechSynthesisUtterance( word );
        window.speechSynthesis.speak(msg);
        });
     },

     addToDetailLearning: (AccountID, VocabID, TopicID, Level, WrongTimes, Score) => {
        axiosInstance.post('detailLearning', {
            "AccountID": AccountID, 
            "VocabID":  VocabID, 
            "TopicID": TopicID,
            "Level":  Level,
            "WrongTimes": WrongTimes,
            "Score": Score
        })
        .then(res => console.log(res))
     }

 }

 export const dataUser = {
    data(){
        return{
            email: ''
        }
    }
 }


 export default globalFunc

  