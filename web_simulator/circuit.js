import { doc, setDoc, onSnapshot } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-firestore.js";
import { signInAnonymously } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js";
import { db, auth } from "./firebase-config.js";

// DOM Elements
const powerSwitch = document.getElementById("powerSwitch");
const helmetSwitch = document.getElementById("helmetSwitch");
const statusText = document.getElementById("statusText");
const statusBox = document.querySelector(".status-box");
const syncBadge = document.getElementById("syncBadge");
const lastSyncedTime = document.getElementById("lastSyncedTime");
const activityLog = document.getElementById("activityLog");

const connectionBanner = document.getElementById("connectionBanner");
const connectionText = document.getElementById("connectionText");
const statusDot = document.querySelector(".status-dot");
const offlineAlert = document.getElementById("offlineAlert");

// SVG Elements
const wireSensor = document.getElementById("wireSensor");
const wireGreen = document.getElementById("wireGreen");
const wireRed = document.getElementById("wireRed");
const wireBuzzer = document.getElementById("wireBuzzer");
const sensorIndicator = document.getElementById("sensorIndicator");
const ledGreen = document.getElementById("ledGreen");
const ledRed = document.getElementById("ledRed");
const buzzerWave1 = document.getElementById("buzzerWave1");
const buzzerWave2 = document.getElementById("buzzerWave2");

// State
let isOffline = true;
let preventWriteOnNextUpdate = false; 
const DEVICE_ID = "webDemo"; // Writing to collection 'requests', document 'webDemo'

// 1. Authenticate Anonymously First
connectionText.textContent = "Authenticating...";
signInAnonymously(auth)
  .then(() => {
    console.log("Signed in anonymously");
    isOffline = false;
    statusDot.classList.remove("bg-offline");
    statusDot.classList.add("bg-connected");
    connectionText.textContent = "Connected (Firestore)";
    offlineAlert.classList.add("d-none");
    if (syncBadge.textContent === "Offline") {
        syncBadge.textContent = "Synced";
        syncBadge.className = "badge bg-success text-white border px-2 py-1";
    }
    
    // 2. Setup Firestore Listener once authenticated
    setupFirestoreListener();
  })
  .catch((error) => {
    console.error("Auth error:", error);
    isOffline = true;
    statusDot.classList.remove("bg-connected");
    statusDot.classList.add("bg-offline");
    connectionText.textContent = "Auth Failed";
    offlineAlert.classList.remove("d-none");
    offlineAlert.innerHTML = `<strong>Auth Error!</strong> Make sure 'Anonymous' sign-in provider is enabled in Firebase Authentication. (${error.message})`;
  });

function setupFirestoreListener() {
    const docRef = doc(db, "requests", DEVICE_ID);
    
    onSnapshot(docRef, (docSnap) => {
        if (docSnap.exists()) {
            const data = docSnap.data();
            
            // Prevent writing back what we just received
            preventWriteOnNextUpdate = true;
            
            // Ensure booleans, fallback to false
            const powerState = data.power === true;
            const helmetState = data.helmetDetected === true;
            
            const powerChanged = powerSwitch.checked !== powerState;
            const helmetChanged = helmetSwitch.checked !== helmetState;
            
            powerSwitch.checked = powerState;
            helmetSwitch.checked = helmetState;
            
            updateUI();
            
            if (powerChanged) {
                logActivity(`Power turned ${powerState ? 'ON' : 'OFF'} (Remote)`, powerState ? 'power-on' : 'power-off');
            }
            if (helmetChanged) {
                logActivity(`Helmet state changed to ${helmetState ? 'YES' : 'NO'} (Remote)`, helmetState ? 'helmet-yes' : 'helmet-no');
            }
            
            if (data.timestamp) {
                const date = new Date(data.timestamp);
                lastSyncedTime.textContent = `Last synced: ${date.toLocaleTimeString()}`;
            }
        }
    }, (error) => {
        console.error("Firestore Listen Error:", error);
        if (error.code === 'permission-denied') {
            offlineAlert.classList.remove("d-none");
            offlineAlert.innerHTML = `<strong>Permission Denied!</strong> Check your Firestore Rules. They should allow read/write for authenticated users.`;
        }
    });
}

// Switch Listeners
powerSwitch.addEventListener("change", () => {
    updateUI();
    logActivity(`Power turned ${powerSwitch.checked ? 'ON' : 'OFF'}`, powerSwitch.checked ? 'power-on' : 'power-off');
    writeToFirestore();
});

helmetSwitch.addEventListener("change", () => {
    updateUI();
    logActivity(`Helmet state changed to ${helmetSwitch.checked ? 'YES' : 'NO'}`, helmetSwitch.checked ? 'helmet-yes' : 'helmet-no');
    writeToFirestore();
});

function updateUI() {
    const isPowerOn = powerSwitch.checked;
    const isHelmetDetected = helmetSwitch.checked;

    // Reset all animations/classes
    wireSensor.className.baseVal = "wire-current";
    wireGreen.className.baseVal = "wire-current";
    wireRed.className.baseVal = "wire-current";
    wireBuzzer.className.baseVal = "wire-current";
    
    sensorIndicator.classList.remove("sensor-active");
    ledGreen.classList.remove("led-active-green");
    ledRed.classList.remove("led-active-red");
    buzzerWave1.classList.remove("active");
    buzzerWave1.classList.remove("buzzer-wave");
    buzzerWave2.classList.remove("active");
    buzzerWave2.classList.remove("buzzer-wave");
    
    statusBox.className = "status-box p-3 rounded";

    if (isHelmetDetected) {
        sensorIndicator.classList.add("sensor-active");
        wireSensor.classList.add("active");
    }

    if (!isPowerOn) {
        statusText.textContent = "Circuit is OFF";
        return;
    }

    // Circuit is ON
    if (isHelmetDetected) {
        statusText.textContent = "Circuit is ON — Helmet detected — Green LED active";
        statusBox.classList.add("active-helmet");
        
        wireGreen.classList.add("active");
        wireGreen.classList.add("active-success");
        ledGreen.classList.add("led-active-green");
    } else {
        statusText.textContent = "Circuit is ON — No helmet — Red LED & Buzzer active";
        statusBox.classList.add("active-no-helmet");
        
        wireRed.classList.add("active");
        wireRed.classList.add("active-error");
        ledRed.classList.add("led-active-red");
        
        wireBuzzer.classList.add("active");
        wireBuzzer.classList.add("active-error");
        
        buzzerWave1.classList.add("buzzer-wave", "active");
        buzzerWave2.classList.add("buzzer-wave", "active");
    }
}

function writeToFirestore() {
    if (preventWriteOnNextUpdate) {
        preventWriteOnNextUpdate = false;
        return; 
    }

    if (isOffline) {
        syncBadge.textContent = "Offline";
        syncBadge.className = "badge bg-warning text-dark border px-2 py-1";
        return;
    }

    syncBadge.textContent = "Syncing...";
    syncBadge.className = "badge bg-primary text-white border px-2 py-1";

    const timestamp = Date.now();
    const docRef = doc(db, "requests", DEVICE_ID);
    
    setDoc(docRef, {
        power: powerSwitch.checked,
        helmetDetected: helmetSwitch.checked,
        timestamp: timestamp
    }).then(() => {
        syncBadge.textContent = "Synced";
        syncBadge.className = "badge bg-success text-white border px-2 py-1";
        const date = new Date(timestamp);
        lastSyncedTime.textContent = `Last synced: ${date.toLocaleTimeString()}`;
    }).catch((error) => {
        console.error("Firestore write error:", error);
        syncBadge.textContent = "Sync failed";
        syncBadge.className = "badge bg-danger text-white border px-2 py-1";
        if (error.code === 'permission-denied') {
            alert("Firestore Write Denied. Ensure your Firestore Security Rules allow this write and Anonymous Auth is enabled.");
        }
    });
}

function logActivity(message, typeClass) {
    if (activityLog.children.length === 1 && activityLog.children[0].textContent === "Waiting for activity...") {
        activityLog.innerHTML = "";
    }

    const li = document.createElement("li");
    li.className = `list-group-item d-flex justify-content-between align-items-center log-${typeClass}`;
    
    const time = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' });
    
    li.innerHTML = `
        <span>${message}</span>
        <small class="text-muted">${time}</small>
    `;
    
    activityLog.insertBefore(li, activityLog.firstChild);
    
    if (activityLog.children.length > 10) {
        activityLog.removeChild(activityLog.lastChild);
    }
}

// Initial UI setup
updateUI();
