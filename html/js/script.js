const taserUI = document.getElementById('taser-ui');
const currentShotsElement = document.getElementById('current-shots');
const maxShotsElement = document.getElementById('max-shots');
const availableCartridgesElement = document.getElementById('available-cartridges');
const iconWrapper = document.querySelector('.icon-wrapper');

let lastShotsValue = 0;
let emptyTaser = false;

window.addEventListener('message', function(event) {
    const data = event.data;
    
    if (data.type === 'updateTaserUI') {
        updateTaserUI(data);
    } else if (data.type === 'hideTaserUI') {
        hideUI();
    }
});

function updateTaserUI(data) {
    if (taserUI.classList.contains('hidden')) {
        taserUI.classList.remove('hidden');
        taserUI.style.opacity = '0';
        taserUI.style.transform = 'translateY(10px)';
        
        setTimeout(() => {
            taserUI.style.opacity = '1';
            taserUI.style.transform = 'translateY(0)';
        }, 50);
    }
    
    const currentShots = data.currentCartridges;
    const maxShots = data.maxCartridges;
    const availableCartridges = data.availableCartridges;
    
    const wasTaserEmpty = emptyTaser;
    emptyTaser = (currentShots === 0);

    if (emptyTaser && !wasTaserEmpty) {
        taserUI.classList.add('show-reload-hint');
    } else if (!emptyTaser && wasTaserEmpty) {
        taserUI.classList.remove('show-reload-hint');
    }

    if (currentShots < lastShotsValue) {
        taserUI.classList.add('shot-animation');
        iconWrapper.classList.add('electric-pulse');

        setTimeout(() => {
            taserUI.classList.remove('shot-animation');
        }, 500);
        
        setTimeout(() => {
            iconWrapper.classList.remove('electric-pulse');
        }, 500);
    }
    
    currentShotsElement.className = '';
    if (currentShots === 0) {
        currentShotsElement.classList.add('no-ammo');
    } else if (currentShots <= Math.ceil(maxShots * 0.3)) {
        currentShotsElement.classList.add('low-ammo');
    }

    currentShotsElement.textContent = currentShots;
    maxShotsElement.textContent = maxShots;
    availableCartridgesElement.textContent = availableCartridges;

    lastShotsValue = currentShots;
}

function hideUI() {
    if (!taserUI.classList.contains('hidden')) {
        taserUI.style.opacity = '0';
        taserUI.style.transform = 'translateY(10px)';
        
        setTimeout(() => {
            taserUI.classList.add('hidden');
            taserUI.classList.remove('show-reload-hint');
        }, 300);
    }
}
