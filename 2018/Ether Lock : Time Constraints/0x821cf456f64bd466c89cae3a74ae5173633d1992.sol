['pragma solidity ^0.4.19;\n', '\n', 'contract Wicflight {\n', '  /*\n', '  * Potential statuses for the Insurance struct\n', '  * 0: ongoing\n', '  * 1: insurance contract resolved normaly and the flight landed before the limit\n', '  * 2: insurance contract resolved normaly and the flight landed after the limit\n', '  * 3: insurance contract resolved because cancelled by the user\n', '  * 4: insurance contract resolved because flight cancelled by the air company\n', '  * 5: insurance contract resolved because flight redirected\n', '  * 6: insurance contract resolved because flight diverted\n', '  */\n', '  struct Insurance {          // all the infos related to a single insurance\n', '    bytes32 productId;           // ID string of the product linked to this insurance\n', '    uint limitArrivalTime;    // maximum arrival time after which we trigger compensation (timestamp in sec)\n', '    uint32 premium;           // amount of the premium\n', '    uint32 indemnity;         // amount of the indemnity\n', '    uint8 status;             // status of this insurance contract. See comment above for potential values\n', '  }\n', '\n', '  event InsuranceCreation(    // event sent when a new insurance contract is added to this smart contract\n', '    bytes32 flightId,         // <carrier_code><flight_number>.<timestamp_in_sec_of_departure_date>\n', '    uint32 premium,           // amount of the premium paid by the user\n', '    uint32 indemnity,         // amount of the potential indemnity\n', '    bytes32 productId            // ID string of the product linked to this insurance\n', '  );\n', '\n', '  /*\n', '   * Potential statuses for the InsuranceUpdate event\n', '   * 1: flight landed before the limit\n', '   * 2: flight landed after the limit\n', '   * 3: insurance contract cancelled by the user\n', '   * 4: flight cancelled\n', '   * 5: flight redirected\n', '   * 6: flight diverted\n', '   */\n', '  event InsuranceUpdate(      // event sent when the situation of a particular insurance contract is resolved\n', '    bytes32 productId,           // id string of the user linked to this account\n', '    bytes32 flightId,         // <carrier_code><flight_number>.<timestamp_in_sec_of_departure_date>\n', '    uint32 premium,           // amount of the premium paid by the user\n', '    uint32 indemnity,         // amount of the potential indemnity\n', '    uint8 status              // new status of the insurance contract. See above comment for potential values\n', '  );\n', '\n', '  address creator;            // address of the creator of the contract\n', '\n', '  // All the insurances handled by this smart contract are contained in this mapping\n', '  // key: a string containing the flight number and the timestamp separated by a dot\n', '  // value: an array of insurance contracts for this flight\n', '  mapping (bytes32 => Insurance[]) insuranceList;\n', '\n', '\n', '  // ------------------------------------------------------------------------------------------ //\n', '  // MODIFIERS / CONSTRUCTOR\n', '  // ------------------------------------------------------------------------------------------ //\n', '\n', '  /**\n', '   * @dev This modifier checks that only the creator of the contract can call this smart contract\n', '   */\n', '  modifier onlyIfCreator {\n', '    if (msg.sender == creator) _;\n', '  }\n', '\n', '  /**\n', '   * @dev Constructor\n', '   */\n', '  function Wicflight() public {\n', '    creator = msg.sender;\n', '  }\n', '\n', '\n', '  // ------------------------------------------------------------------------------------------ //\n', '  // INTERNAL FUNCTIONS\n', '  // ------------------------------------------------------------------------------------------ //\n', '\n', '  function areStringsEqual (bytes32 a, bytes32 b) private pure returns (bool) {\n', '    // generate a hash for each string and compare them\n', '    return keccak256(a) == keccak256(b);\n', '  }\n', '\n', '\n', '  // ------------------------------------------------------------------------------------------ //\n', '  // FUNCTIONS TRIGGERING TRANSACTIONS\n', '  // ------------------------------------------------------------------------------------------ //\n', '\n', '  /**\n', '   * @dev Add a new insurance for the given flight\n', '   * @param flightId <carrier_code><flight_number>.<timestamp_in_sec_of_departure_date>\n', '   * @param limitArrivalTime Maximum time after which we trigger the compensation (timestamp in sec)\n', '   * @param premium Amount of premium paid by the client\n', '   * @param indemnity Amount (potentialy) perceived by the client\n', '   * @param productId ID string of product linked to the insurance\n', '   */\n', '  function addNewInsurance(\n', '    bytes32 flightId,\n', '    uint limitArrivalTime,\n', '    uint32 premium,\n', '    uint32 indemnity,\n', '    bytes32 productId)\n', '  public\n', '  onlyIfCreator {\n', '\n', '    Insurance memory insuranceToAdd;\n', '    insuranceToAdd.limitArrivalTime = limitArrivalTime;\n', '    insuranceToAdd.premium = premium;\n', '    insuranceToAdd.indemnity = indemnity;\n', '    insuranceToAdd.productId = productId;\n', '    insuranceToAdd.status = 0;\n', '\n', '    insuranceList[flightId].push(insuranceToAdd);\n', '\n', '    // send an event about the creation of this insurance contract\n', '    InsuranceCreation(flightId, premium, indemnity, productId);\n', '  }\n', '\n', '  /**\n', '   * @dev Update the status of a flight\n', '   * @param flightId <carrier_code><flight_number>.<timestamp_in_sec_of_departure_date>\n', '   * @param actualArrivalTime The actual arrival time of the flight (timestamp in sec)\n', '   */\n', '  function updateFlightStatus(\n', '    bytes32 flightId,\n', '    uint actualArrivalTime)\n', '  public\n', '  onlyIfCreator {\n', '\n', '    uint8 newStatus = 1;\n', '\n', '    // go through the list of all insurances related to the given flight\n', '    for (uint i = 0; i < insuranceList[flightId].length; i++) {\n', '\n', '      // we check this contract is still ongoing before updating it\n', '      if (insuranceList[flightId][i].status == 0) {\n', '\n', '        newStatus = 1;\n', '\n', '        // if the actual arrival time is over the limit the user wanted,\n', '        // we trigger the indemnity, which means status = 2\n', '        if (actualArrivalTime > insuranceList[flightId][i].limitArrivalTime) {\n', '          newStatus = 2;\n', '        }\n', '\n', '        // update the status of the insurance contract\n', '        insuranceList[flightId][i].status = newStatus;\n', '\n', '        // send an event about this update for each insurance\n', '        InsuranceUpdate(\n', '          insuranceList[flightId][i].productId,\n', '          flightId,\n', '          insuranceList[flightId][i].premium,\n', '          insuranceList[flightId][i].indemnity,\n', '          newStatus\n', '        );\n', '      }\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Manually resolve an insurance contract\n', '   * @param flightId <carrier_code><flight_number>.<timestamp_in_sec_of_departure_date>\n', '   * @param newStatusId ID of the resolution status for this insurance contract\n', '   * @param productId ID string of the product linked to the insurance\n', '   */\n', '  function manualInsuranceResolution(\n', '    bytes32 flightId,\n', '    uint8 newStatusId,\n', '    bytes32 productId)\n', '  public\n', '  onlyIfCreator {\n', '\n', '    // go through the list of all insurances related to the given flight\n', '    for (uint i = 0; i < insuranceList[flightId].length; i++) {\n', '\n', '      // look for the insurance contract with the correct ID number\n', '      if (areStringsEqual(insuranceList[flightId][i].productId, productId)) {\n', '\n', '        // we check this contract is still ongoing before updating it\n', '        if (insuranceList[flightId][i].status == 0) {\n', '\n', '          // change the status of the insurance contract to the specified one\n', '          insuranceList[flightId][i].status = newStatusId;\n', '\n', '          // send an event about this update\n', '          InsuranceUpdate(\n', '            productId,\n', '            flightId,\n', '            insuranceList[flightId][i].premium,\n', '            insuranceList[flightId][i].indemnity,\n', '            newStatusId\n', '          );\n', '\n', '          return;\n', '        }\n', '      }\n', '    }\n', '  }\n', '\n', '  function getInsurancesCount(bytes32 flightId) public view onlyIfCreator returns (uint) {\n', '    return insuranceList[flightId].length;\n', '  }\n', '\n', '  function getInsurance(bytes32 flightId, uint index) public view onlyIfCreator returns (bytes32, uint, uint32, uint32, uint8) {\n', '    Insurance memory ins = insuranceList[flightId][index];\n', '    return (ins.productId, ins.limitArrivalTime, ins.premium, ins.indemnity, ins.status);\n', '  }\n', '\n', '}']