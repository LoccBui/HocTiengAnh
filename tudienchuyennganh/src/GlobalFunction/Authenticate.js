import router from "@/router";

export const authenticate = {
    auth: (isAuthorized, urlTrue, urlFalse) => {
        if (isAuthorized == true) {
            router.push(`/${urlTrue}`);
        }
        else{
            router.push(`/${urlFalse}`);
        }
    }    
 }



  