
export const func = {
    speakWord: (word) => {
        console.log("script.js: run")
        const listenBtn = document.getElementById('myvoice');
        listenBtn.addEventListener('click', (e) => {
        e.preventDefault();
        
        const msg = new SpeechSynthesisUtterance( word );
        window.speechSynthesis.speak(msg);
        });
     },

 }

 export const dataUser = {
    email: '',
    name: ''
 }


  