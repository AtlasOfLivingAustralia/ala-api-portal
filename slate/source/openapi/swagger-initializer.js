window.onload = function() {
    //<editor-fold desc="Changeable Configuration Block">

    // the following lines will be replaced by docker/configurator, when it runs in a docker-container
    window.ui = SwaggerUIBundle({
      urls: [
        { name: "alerts", url: "./specs/alerts.json"},
        // { name: "ecodata", url: "./specs/ecodata-http.yaml"},
        { name: "images", url: "./specs/images.json"},
        { name: "userdetails", url: "./specs/userdetails.json"},
        { name: "download-statistics", url: "./specs/logger.json"},
        { name: "doi", url: "./specs/doi.json"},
        { name: "surveys", url: "./specs/biocollect.json"},
        { name: "species", url:"./specs/bie-index.json"},
        { name: "specieslist", url:"./specs/specieslist.json"},
        { name: "metadata", url:"./specs/collectory.json"},
        { name: "data-quality-service", url: "./specs/dqf-service.json"},
        { name: "occurrences", url: "./specs/biocache.json"},
        { name: "common", url: "./specs/common.json"},
        { name: "spatial", url: "./specs/spatial.json"},
        { name: "events", url: "./specs/events.json"},
        // TODO -comment out the below specs before staging and prod release as these apis have not yet been resealed to PROD
        // { name: "profiles", url:"./specs/profiles.json"},
        // { name: "namematching", url: "./specs/namematching.json"},

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
