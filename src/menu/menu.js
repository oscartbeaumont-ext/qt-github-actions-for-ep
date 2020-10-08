let servicesElem = document.querySelector('.services');

window.onload = function () {
  new QWebChannel(qt.webChannelTransport, (channel) => {
    var manager = channel.objects.manager;

    manager.getServices((services) => {
      services.forEach(service => {
        // skip if service is disabled
        if (!service.enabled || service.name == "Menu") {
          return;
        }

        // create service element
        let elem = createElement('a', 'service');
        elem.setAttribute('href', '#');

        // create img element
        let img = createElement('img');
        img.setAttribute('id', service.name);
        img.setAttribute('src', service.logo);
        img.setAttribute('alt', service.name);

        // append img to service element
        elem.appendChild(img);

        // create h3 element
        let h3 = document.createElement('h3');
        h3.appendChild(document.createTextNode(service.name));

        // append h3 element to service element
        elem.appendChild(h3);

        // append service element to services
        servicesElem.appendChild(elem);

        elem.addEventListener('click', () => manager.openService(service.name));
      });
    });
  });
}