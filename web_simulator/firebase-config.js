// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-firestore.js";
import { getAuth } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js";

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyCmrGALI3ATsFNJvW2LIMrSVYAouQsq_kM",
  authDomain: "test-5cf65.firebaseapp.com",
  projectId: "test-5cf65",
  storageBucket: "test-5cf65.appspot.com",
  messagingSenderId: "737399835094",
  appId: "1:737399835094:web:5a782ac1386decc3c07c77",
  measurementId: "G-DY3DHFTQ50"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);
const auth = getAuth(app);

export { db, auth };
