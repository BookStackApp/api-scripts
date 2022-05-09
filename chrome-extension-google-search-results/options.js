const inputs = [...document.querySelectorAll('input[type="text"]')];
const form = document.querySelector('form');
const message = document.getElementById('message');

// Store settings on submit
form.addEventListener('submit', event => {

    event.preventDefault();

    const settings = {};
    for (const input of inputs) {
        settings[input.name] = input.value;
    }

    chrome.storage.sync.set(settings, () => {
        message.textContent = 'Settings updated!';
    });

});

// Restore settings on load
chrome.storage.sync.get({
    tokenId: '',
    tokenSecret: '',
    baseUrl: '',
}, settings => {
    for (const input of inputs) {
        input.value = settings[input.name];
    }
});