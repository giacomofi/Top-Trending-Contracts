['pragma solidity ^0.4.18;\n', '\n', 'contract Agencies {\n', '  mapping (address => string) private agencyOfOwner;\n', '  mapping (string => address) private ownerOfAgency;\n', '\n', '  event Set (string indexed _agency, address indexed _owner);\n', '  event Unset (string indexed _agency, address indexed _owner);\n', '\n', '  function Agencies () public {\n', '  }\n', '\n', '  function agencyOf (address _owner) public view returns (string _agency) {\n', '    return agencyOfOwner[_owner];\n', '  }\n', '\n', '  function ownerOf (string _agency) public view returns (address _owner) {\n', '    return ownerOfAgency[_agency];\n', '  }\n', '\n', '  function set (string _agency) public {\n', '    require(bytes(_agency).length > 2);\n', '    require(ownerOf(_agency) == address(0));\n', '\n', '    address owner = msg.sender;\n', '    string storage oldAgency = agencyOfOwner[owner];\n', '\n', '    if (bytes(oldAgency).length > 0) {\n', '      Unset(oldAgency, owner);\n', '      delete ownerOfAgency[oldAgency];\n', '    }\n', '\n', '    agencyOfOwner[owner] = _agency;\n', '    ownerOfAgency[_agency] = owner;\n', '    Set(_agency, owner);\n', '  }\n', '\n', '  function unset () public {\n', '    require(bytes(agencyOfOwner[msg.sender]).length > 0);\n', '\n', '    address owner = msg.sender;\n', '    string storage oldAgency = agencyOfOwner[owner];\n', '\n', '    Unset(oldAgency, owner);\n', '\n', '    delete ownerOfAgency[oldAgency];\n', '    delete agencyOfOwner[owner];\n', '  }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'contract Agencies {\n', '  mapping (address => string) private agencyOfOwner;\n', '  mapping (string => address) private ownerOfAgency;\n', '\n', '  event Set (string indexed _agency, address indexed _owner);\n', '  event Unset (string indexed _agency, address indexed _owner);\n', '\n', '  function Agencies () public {\n', '  }\n', '\n', '  function agencyOf (address _owner) public view returns (string _agency) {\n', '    return agencyOfOwner[_owner];\n', '  }\n', '\n', '  function ownerOf (string _agency) public view returns (address _owner) {\n', '    return ownerOfAgency[_agency];\n', '  }\n', '\n', '  function set (string _agency) public {\n', '    require(bytes(_agency).length > 2);\n', '    require(ownerOf(_agency) == address(0));\n', '\n', '    address owner = msg.sender;\n', '    string storage oldAgency = agencyOfOwner[owner];\n', '\n', '    if (bytes(oldAgency).length > 0) {\n', '      Unset(oldAgency, owner);\n', '      delete ownerOfAgency[oldAgency];\n', '    }\n', '\n', '    agencyOfOwner[owner] = _agency;\n', '    ownerOfAgency[_agency] = owner;\n', '    Set(_agency, owner);\n', '  }\n', '\n', '  function unset () public {\n', '    require(bytes(agencyOfOwner[msg.sender]).length > 0);\n', '\n', '    address owner = msg.sender;\n', '    string storage oldAgency = agencyOfOwner[owner];\n', '\n', '    Unset(oldAgency, owner);\n', '\n', '    delete ownerOfAgency[oldAgency];\n', '    delete agencyOfOwner[owner];\n', '  }\n', '}']