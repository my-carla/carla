// Copyright (c) 2020 Computer Vision Center (CVC) at the Universitat Autonoma
// de Barcelona (UAB).
//
// This work is licensed under the terms of the MIT license.
// For a copy, see <https://opensource.org/licenses/MIT>.

#include "OSM2ODR.h"

#include <iostream>
#include <string>
#include <netimport/NIFrame.h>
#include <netimport/NILoader.h>
#include <netbuild/NBFrame.h>
#include <netbuild/NBNetBuilder.h>
#include <netwrite/NWFrame.h>
#include <utils/options/OptionsIO.h>
#include <utils/options/OptionsCont.h>
#include <utils/common/UtilExceptions.h>
#include <utils/common/RandHelper.h>
#include <utils/common/SystemFrame.h>
#include <utils/common/MsgHandler.h>
#include <utils/distribution/DistributionCont.h>
#include <utils/xml/XMLSubSys.h>
#include <utils/iodevices/OutputDevice.h>
#include <utils/geom/GeoConvHelper.h>


namespace osm2odr {

  void fillOptions() {
    OptionsCont& oc = OptionsCont::getOptions();
    oc.addCallExample("-c <CONFIGURATION>", "generate net with options read from file");
    oc.addCallExample("-n ./nodes.xml -e ./edges.xml -v -t ./owntypes.xml",
                      "generate net with given nodes, edges, and edge types doing verbose output");
    // insert options sub-topics
    SystemFrame::addConfigurationOptions(oc); // this subtopic is filled here, too
    oc.addOptionSubTopic("Input");
    oc.addOptionSubTopic("Output");
    GeoConvHelper::addProjectionOptions(oc);
    oc.addOptionSubTopic("Processing");
    oc.addOptionSubTopic("Building Defaults");
    oc.addOptionSubTopic("TLS Building");
    oc.addOptionSubTopic("Ramp Guessing");
    oc.addOptionSubTopic("Edge Removal");
    oc.addOptionSubTopic("Unregulated Nodes");
    oc.addOptionSubTopic("Junctions");
    oc.addOptionSubTopic("Pedestrian");
    oc.addOptionSubTopic("Bicycle");
    oc.addOptionSubTopic("Railway");
    oc.addOptionSubTopic("Formats");

    NIFrame::fillOptions();
    NBFrame::fillOptions(false);
    NWFrame::fillOptions(false);
    RandHelper::insertRandOptions();
}


  bool checkOptions() {
    bool ok = NIFrame::checkOptions();
    ok &= NBFrame::checkOptions();
    ok &= NWFrame::checkOptions();
    ok &= SystemFrame::checkOptions();
    return ok;
  }

  std::string ConvertOSMToOpenDRIVE(std::string osm_file, OSM2ODRSettings settings) {
    std::vector<std::string> OptionsArgs = {
      "--proj", settings.proj_string,
      "--geometry.remove", "--ramps.guess", "--edges.join", "--junctions.join", "--roundabouts.guess",
      "--tls.group-signals", "true",
      "--sidewalks.guess","true",
      "--osm.sidewalks", "true",
      "--osm.crossings", "true",
      "--default.lanewidth",
      std::to_string(settings.default_lane_width),
      "--default.sidewalk-width",
      std::to_string(settings.default_sidewalk_width),
      "--osm-files", "TRUE", "--opendrive-output", "TRUE", // necessary for now to enable osm input and xodr output
    };
    if (settings.osm_highways_types.size() == 0) {
      WRITE_ERROR("No osm way types specified for importing.");
      return "";
    }
    OptionsArgs.emplace_back("--keep-edges.by-type");
    std::string edges_types = "";
    for (std::string& osm_way_type : settings.osm_highways_types) {
      edges_types += "highway." + osm_way_type + ",";
    }
    OptionsArgs.emplace_back(edges_types);
    if (settings.elevation_layer_height > 0) {
      OptionsArgs.emplace_back("--osm.layer-elevation");
      OptionsArgs.emplace_back(std::to_string(settings.elevation_layer_height));
    }
    if (settings.use_offsets) {
      OptionsArgs.emplace_back("--offset.x");
      OptionsArgs.emplace_back(std::to_string(settings.offset_x));
      OptionsArgs.emplace_back("--offset.y");
      OptionsArgs.emplace_back(std::to_string(settings.offset_y));
    }
    if (!settings.center_map) {
      OptionsArgs.emplace_back("--offset.disable-normalization");
      OptionsArgs.emplace_back("true");
    }

    // OptionsCont::getOptions().clear();
    OptionsCont& oc = OptionsCont::getOptions();
    oc.input_osm_file = osm_file;
    oc.generate_traffic_lights = settings.generate_traffic_lights;
    oc.all_junctions_traffic_lights = settings.all_junctions_traffic_lights;
    oc.tl_excluded_highways_types = settings.tl_excluded_highways_types;

    XMLSubSys::init();
    fillOptions();
    OptionsIO::setArgs(OptionsArgs);
    OptionsIO::getOptions();
    if (oc.processMetaOptions(OptionsArgs.size() < 2)) {
        SystemFrame::close();
        return 0;
    }
    XMLSubSys::setValidation(oc.getString("xml-validation"), oc.getString("xml-validation.net"), "never");
    if (oc.isDefault("aggregate-warnings")) {
        oc.set("aggregate-warnings", "5");
    }
    MsgHandler::initOutputOptions();
    if (!checkOptions()) {
        throw ProcessError();
    }
    RandHelper::initRandGlobal();
    // build the projection
    if (!GeoConvHelper::init(oc)) {
        throw ProcessError("Could not build projection!");
    }
    NBNetBuilder nb;
    nb.applyOptions(oc);
    // load data
    NILoader nl(nb);
    nl.load(oc);
    // flush aggregated errors and optionally ignore them
    MsgHandler::getErrorInstance()->clear(oc.getBool("ignore-errors"));
    // check whether any errors occurred
    if (MsgHandler::getErrorInstance()->wasInformed()) {
        throw ProcessError();
    }
    nb.compute(oc);
    // check whether any errors occurred
    if (MsgHandler::getErrorInstance()->wasInformed()) {
        throw ProcessError();
    }
    NWFrame::writeNetwork(oc, nb);


    DistributionCont::clear();
    SystemFrame::close();

    return oc.output_xodr_file;
  }

} // namespace OSM2ODR
