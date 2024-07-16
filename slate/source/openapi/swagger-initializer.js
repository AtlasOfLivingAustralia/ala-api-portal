window.onload = function() {
    //<editor-fold desc="Changeable Configuration Block">

    // the following lines will be replaced by docker/configurator, when it runs in a docker-container
    window.ui = SwaggerUIBundle({
      urls: [
        { name: "alerts", url: "./specs/alerts-dev.json"},
        { name: "common", url: "./specs/common.json"},
        { name: "data-quality-service", url: "./specs/dqf-service.json"},
        { name: "doi", url: "./specs/doi.json"},
        { name: "download-statistics", url: "./specs/logger.json"},
        { name: "ecodata", url: "./specs/ecodata.json"},
        { name: "events", url: "./specs/events.json"},
        { name: "fieldguide", url: "./specs/fieldguide.json"},
        { name: "images", url: "./specs/images.json"},
        { name: "metadata", url:"./specs/collectory.json"},
        { name: "namematching", url: "./specs/namematching.json"},
        { name: "occurrences", url: "./specs/biocache.json"},
        { name: "profiles", url:"./specs/profiles.json"},
        { name: "sensitive", url: "./specs/sensitive.json"},
        { name: "spatial", url: "./specs/spatial.json"},
        { name: "species", url:"./specs/bie-index.json"},
        { name: "specieslist", url:"./specs/specieslist.json"},
        { name: "surveys", url: "./specs/biocollect.json"},
        { name: "userdetails", url: "./specs/userdetails.json"},
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
