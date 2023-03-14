
export const func = {
    speakWord: (word) => {
        const listenBtn = document.getElementById('myvoice');
        listenBtn.addEventListener('click', (e) => {
        e.preventDefault();

        console.log("script.js: speakWord: " + word)
        
        const msg = new SpeechSynthesisUtterance( word );
        window.speechSynthesis.speak(msg);
        });
     },

 }

 export const dataUser = {
    data(){
        return{
            email: ''
        }
    }
 }


  