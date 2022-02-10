['pragma solidity ^0.4.19;\n', '\n', '\n', 'contract theCyberInterface {\n', '  // The contract may call a few methods on theCyber once it is itself a member.\n', '  function newMember(uint8 _memberId, bytes32 _memberName, address _memberAddress) public;\n', '  function getMembershipStatus(address _memberAddress) public view returns (bool member, uint8 memberId);\n', '  function getMemberInformation(uint8 _memberId) public view returns (bytes32 memberName, string memberKey, uint64 memberSince, uint64 inactiveSince, address memberAddress);\n', '}\n', '\n', '\n', 'contract theCyberGatekeeperTwoInterface {\n', '  // The contract may read the entrants from theCyberGatekeeperTwo.\n', '  function entrants(uint256 i) public view returns (address);\n', '  function totalEntrants() public view returns (uint8);\n', '}\n', '\n', '\n', 'contract theCyberAssigner {\n', '  // This contract supplements the second gatekeeper contract at the address\n', '  // 0xbB902569a997D657e8D10B82Ce0ec5A5983C8c7C. Once enough members have been\n', '  // registered with the gatekeeper, the assignAll() method may be called,\n', '  // which (assuming theCyberAssigner is itself a member of theCyber), will\n', '  // try to assign a membership to each of the submitted addresses.\n', '\n', '  // The assigner will interact with theCyber contract at the given address.\n', '  address private constant THECYBERADDRESS_ = 0x97A99C819544AD0617F48379840941eFbe1bfAE1;\n', '\n', '  // the assigner will read the entrants from the second gatekeeper contract.\n', '  address private constant THECYBERGATEKEEPERADDRESS_ = 0xbB902569a997D657e8D10B82Ce0ec5A5983C8c7C;\n', '\n', '  // There can only be 128 entrant submissions.\n', '  uint8 private constant MAXENTRANTS_ = 128;\n', '\n', '  // The contract remains active until all entrants have been assigned.\n', '  bool private active_ = true;\n', '\n', '  // Entrants are assigned memberships based on an incrementing member id.\n', '  uint8 private nextAssigneeIndex_;\n', '\n', '  function assignAll() public returns (bool) {\n', '    // The contract must still be active in order to assign new members.\n', '    require(active_);\n', '\n', '    // Require a large transaction so that members are added in bulk.\n', '    require(msg.gas > 6000000);\n', '\n', '    // All entrants must be registered in order to assign new members.\n', '    uint8 totalEntrants = theCyberGatekeeperTwoInterface(THECYBERGATEKEEPERADDRESS_).totalEntrants();\n', '    require(totalEntrants >= MAXENTRANTS_);\n', '\n', '    // Initialize variables for checking membership statuses.\n', '    bool member;\n', '    address memberAddress;\n', '\n', '    // The contract must be a member of theCyber in order to assign new members.\n', '    (member,) = theCyberInterface(THECYBERADDRESS_).getMembershipStatus(this);\n', '    require(member);\n', '    \n', '    // Pick up where the function last left off in assigning new members.\n', '    uint8 i = nextAssigneeIndex_;\n', '\n', '    // Loop through entrants as long as sufficient gas remains.\n', '    while (i < MAXENTRANTS_ && msg.gas > 200000) {\n', '      // Find the entrant at the given index.\n', '      address entrant = theCyberGatekeeperTwoInterface(THECYBERGATEKEEPERADDRESS_).entrants(i);\n', '\n', '      // Determine whether the entrant is already a member of theCyber.\n', '      (member,) = theCyberInterface(THECYBERADDRESS_).getMembershipStatus(entrant);\n', '\n', '      // Determine whether the target membership is already owned.\n', '      (,,,,memberAddress) = theCyberInterface(THECYBERADDRESS_).getMemberInformation(i + 1);\n', '      \n', '      // Ensure that there was no member found with the given id / address.\n', '      if ((entrant != address(0)) && (!member) && (memberAddress == address(0))) {\n', '        // Add the entrant as a new member of theCyber.\n', '        theCyberInterface(THECYBERADDRESS_).newMember(i + 1, bytes32(""), entrant);\n', '      }\n', '\n', '      // Move on to the next entrant / member id.\n', '      i++;\n', '    }\n', '\n', '    // Set the index where the function left off; set as inactive if finished.\n', '    nextAssigneeIndex_ = i;\n', '    if (nextAssigneeIndex_ >= MAXENTRANTS_) {\n', '      active_ = false;\n', '    }\n', '\n', '    return true;\n', '  }\n', '\n', '  function nextAssigneeIndex() public view returns(uint8) {\n', '    // Return the current assignee index.\n', '    return nextAssigneeIndex_;\n', '  }\n', '\n', '  function maxEntrants() public pure returns(uint8) {\n', '    // Return the total number of entrants allowed by the gatekeeper.\n', '    return MAXENTRANTS_;\n', '  }\n', '}']