// MoorFood JavaScript
let moorfoodData = {
    hunger: 100,
    thirst: 100,
    isVisible: false
};

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    initializeMoorFood();
    setupEventListeners();
    updateStatusBar();
});

// Initialize MoorFood
function initializeMoorFood() {
    // Request initial data from client
    fetch('https://localhost/getStatus').then(response => {
        if (response.ok) {
            return response.json();
        }
    }).then(data => {
        if (data) {
            moorfoodData.hunger = data.hunger || 100;
            moorfoodData.thirst = data.thirst || 100;
            updateStatusBar();
        }
    }).catch(error => {
        console.log('MoorFood: Using default values');
    });
}

// Setup Event Listeners
function setupEventListeners() {
    // Eat buttons
    document.querySelectorAll('.eat-btn').forEach(button => {
        button.addEventListener('click', function() {
            const item = this.getAttribute('data-item');
            eatItem(item);
        });
    });
    
    // Drink buttons
    document.querySelectorAll('.drink-btn').forEach(button => {
        button.addEventListener('click', function() {
            const item = this.getAttribute('data-item');
            drinkItem(item);
        });
    });
    
    // Category filters (if needed)
    document.querySelectorAll('.category').forEach(category => {
        category.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-8px) scale(1.02)';
        });
        
        category.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(-5px) scale(1)';
        });
    });
    
    // Keyboard shortcuts
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && moorfoodData.isVisible) {
            closeMenu();
        }
    });
}

// Update Status Bar
function updateStatusBar() {
    const hungerBar = document.getElementById('hunger-bar');
    const thirstBar = document.getElementById('thirst-bar');
    const hungerValue = document.getElementById('hunger-value');
    const thirstValue = document.getElementById('thirst-value');
    
    if (hungerBar) {
        hungerBar.style.width = moorfoodData.hunger + '%';
        
        // Change color based on level
        if (moorfoodData.hunger < 25) {
            hungerBar.style.background = 'linear-gradient(90deg, #ff4444, #ff6666)';
        } else if (moorfoodData.hunger < 50) {
            hungerBar.style.background = 'linear-gradient(90deg, #ffaa00, #ffcc00)';
        } else {
            hungerBar.style.background = 'linear-gradient(90deg, #ff6b6b, #ff8e8e)';
        }
    }
    
    if (thirstBar) {
        thirstBar.style.width = moorfoodData.thirst + '%';
        
        // Change color based on level
        if (moorfoodData.thirst < 25) {
            thirstBar.style.background = 'linear-gradient(90deg, #ff4444, #ff6666)';
        } else if (moorfoodData.thirst < 50) {
            thirstBar.style.background = 'linear-gradient(90deg, #ffaa00, #ffcc00)';
        } else {
            thirstBar.style.background = 'linear-gradient(90deg, #4ecdc4, #6ee7df)';
        }
    }
    
    if (hungerValue) {
        hungerValue.textContent = Math.round(moorfoodData.hunger) + '%';
    }
    
    if (thirstValue) {
        thirstValue.textContent = Math.round(moorfoodData.thirst) + '%';
    }
}

// Eat Item
function eatItem(item) {
    if (!item) return;
    
    // Send to client
    fetch('https://localhost/eatItem', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ item: item })
    }).then(response => {
        if (response.ok) {
            // Show eating animation
            showEatingAnimation(item);
            
            // Update status (will be updated from client)
            setTimeout(() => {
                showNotification('You ate ' + getItemName(item) + '!', 'success');
            }, 2000);
        } else {
            showNotification('Failed to eat item', 'error');
        }
    }).catch(error => {
        console.error('Error eating item:', error);
        showNotification('Error eating item', 'error');
    });
}

// Drink Item
function drinkItem(item) {
    if (!item) return;
    
    // Send to client
    fetch('https://localhost/drinkItem', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ item: item })
    }).then(response => {
        if (response.ok) {
            // Show drinking animation
            showDrinkingAnimation(item);
            
            // Update status (will be updated from client)
            setTimeout(() => {
                showNotification('You drank ' + getItemName(item) + '!', 'success');
            }, 2000);
        } else {
            showNotification('Failed to drink item', 'error');
        }
    }).catch(error => {
        console.error('Error drinking item:', error);
        showNotification('Error drinking item', 'error');
    });
}

// Get Item Name
function getItemName(item) {
    const foodItem = document.querySelector(`[data-item="${item}"]`);
    if (foodItem) {
        const nameElement = foodItem.querySelector('h4');
        return nameElement ? nameElement.textContent : item;
    }
    return item;
}

// Show Eating Animation
function showEatingAnimation(item) {
    const button = document.querySelector(`[data-item="${item}"].eat-btn`);
    if (button) {
        button.disabled = true;
        button.textContent = 'Eating...';
        
        // Add animation class
        const foodItem = button.closest('.food-item');
        foodItem.classList.add('eating');
        
        setTimeout(() => {
            button.disabled = false;
            button.textContent = 'Eat';
            foodItem.classList.remove('eating');
        }, 5000);
    }
}

// Show Drinking Animation
function showDrinkingAnimation(item) {
    const button = document.querySelector(`[data-item="${item}"].drink-btn`);
    if (button) {
        button.disabled = true;
        button.textContent = 'Drinking...';
        
        // Add animation class
        const foodItem = button.closest('.food-item');
        foodItem.classList.add('drinking');
        
        setTimeout(() => {
            button.disabled = false;
            button.textContent = 'Drink';
            foodItem.classList.remove('drinking');
        }, 3000);
    }
}

// Show Notification
function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    notification.textContent = message;
    
    // Style notification
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: ${type === 'success' ? 'rgba(76, 175, 80, 0.9)' : type === 'error' ? 'rgba(244, 67, 54, 0.9)' : 'rgba(33, 150, 243, 0.9)'};
        color: white;
        padding: 15px 20px;
        border-radius: 8px;
        z-index: 10000;
        animation: slideIn 0.3s ease;
        backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.2);
    `;
    
    document.body.appendChild(notification);
    
    // Remove after 3 seconds
    setTimeout(() => {
        notification.style.animation = 'slideOut 0.3s ease';
        setTimeout(() => {
            document.body.removeChild(notification);
        }, 300);
    }, 3000);
}

// Close Menu
function closeMenu() {
    // Send close message to client
    fetch('https://localhost/closeMenu', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({})
    }).catch(error => {
        console.error('Error closing menu:', error);
    });
}

// Update Status from Client
window.addEventListener('message', function(event) {
    const data = event.data;
    
    if (data.action === 'updateStatus') {
        if (data.hunger !== undefined) {
            moorfoodData.hunger = data.hunger;
        }
        if (data.thirst !== undefined) {
            moorfoodData.thirst = data.thirst;
        }
        updateStatusBar();
    }
});

// Show Menu
function showMenu() {
    moorfoodData.isVisible = true;
    document.body.style.display = 'block';
    
    // Animate in
    document.getElementById('moorfood-container').style.animation = 'fadeIn 0.5s ease';
}

// Hide Menu
function hideMenu() {
    moorfoodData.isVisible = false;
    document.body.style.display = 'none';
}

// Handle messages from FiveM
window.addEventListener('message', function(event) {
    const data = event.data;
    
    if (data.action === 'showMenu') {
        showMenu();
    } else if (data.action === 'hideMenu') {
        hideMenu();
    } else if (data.action === 'updateStatus') {
        if (data.hunger !== undefined) {
            moorfoodData.hunger = data.hunger;
        }
        if (data.thirst !== undefined) {
            moorfoodData.thirst = data.thirst;
        }
        updateStatusBar();
    }
});

// Add CSS animations
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    
    @keyframes slideOut {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(100%);
            opacity: 0;
        }
    }
    
    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: scale(0.9);
        }
        to {
            opacity: 1;
            transform: scale(1);
        }
    }
    
    .eating {
        background: rgba(255, 107, 107, 0.2) !important;
        border: 2px solid #ff6b6b !important;
        animation: pulse 1s infinite;
    }
    
    .drinking {
        background: rgba(78, 205, 196, 0.2) !important;
        border: 2px solid #4ecdc4 !important;
        animation: pulse 1s infinite;
    }
    
    @keyframes pulse {
        0% { transform: scale(1); }
        50% { transform: scale(1.05); }
        100% { transform: scale(1); }
    }
    
    .notification {
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
    }
`;
document.head.appendChild(style);

// Expose functions for external calls
window.moorfood = {
    showMenu: showMenu,
    hideMenu: hideMenu,
    updateStatus: function(hunger, thirst) {
        moorfoodData.hunger = hunger;
        moorfoodData.thirst = thirst;
        updateStatusBar();
    }
};
