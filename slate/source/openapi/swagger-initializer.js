window.onload = function() {
    //<editor-fold desc="Changeable Configuration Block">

    // the following lines will be replaced by docker/configurator, when it runs in a docker-container
    window.ui = SwaggerUIBundle({
      urls: [
        { name: "alerts", url: "./specs/alerts.json"},
        // { name: "biocache", url: "./specs/biocache-http.yaml"},
        // { name: "ecodata", url: "./specs/ecodata-http.yaml"},
        { name: "image-service", url: "./specs/images.json"},
        { name: "userdetails", url: "./specs/userdetails.json"},
        { name: "logger", url: "./specs/logger.json"},
        { name: "doi", url: "./specs/doi.json"},
        { name: "biocollect", url: "./specs/biocollect.json"},
        { name: "bie-index", url:"./specs/bie-index.json"},
        { name: "specieslist", url:"./specs/specieslist.json"},
        { name: "collectory", url:"./specs/collectory.json"},
        { name: "profiles", url:"./specs/profiles.json"},
        { name: "data-quality-service", url: "./specs/data-quality-service.json"}
      ],
      dom_id: '#swagger-ui',
      deepLinking: true,
      presets: [
        SwaggerUIBundle.presets.apis,
        SwaggerUIStandalonePreset
      ],
      plugins: [
        SwaggerUIBundle.plugins.DownloadUrl
      ],
      layout: "StandaloneLayout"
    });

    //</editor-fold>
  };
