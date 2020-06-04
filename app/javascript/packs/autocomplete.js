const addressInput = document.getElementById('delivery-address');

if (addressInput) {
  const places = require('places.js');
  const placesAutocomplete = places({
    container: addressInput
    });
}
