['pragma solidity ^0.4.19;\n', '\n', 'contract Love {\n', '\n', '  mapping (address => address) private propose;\n', '  mapping (address => address) private partner;\n', '  mapping (uint256 => string[]) private partnerMessages;\n', '  mapping (uint256 => bool) private isHiddenMessages;\n', '  uint public proposeCount;\n', '  uint public partnerCount;\n', '\n', '  event Propose(address indexed from, address indexed to);\n', '  event CancelPropose(address indexed from, address indexed to);\n', '  event Partner(address indexed from, address indexed to);\n', '  event Farewell(address indexed from, address indexed to);\n', '  event Message(address indexed addressOne, address indexed addressTwo, string message, uint index);\n', '  event HiddenMessages(address indexed addressOne, address indexed addressTwo, bool flag);\n', '\n', '  function proposeTo(address to) public {\n', '    require(to != address(0));\n', '    require(msg.sender != to);\n', '    require(partner[msg.sender] != to);\n', '\n', '    address alreadyPropose = propose[to];\n', '    if (alreadyPropose == msg.sender) {\n', '      propose[to] = address(0);\n', '      if (propose[msg.sender] != address(0)) {\n', '        propose[msg.sender] = address(0);\n', '        proposeCount -= 2;\n', '\n', '      } else {\n', '        proposeCount--;\n', '      }\n', '\n', '      address selfPartner = partner[msg.sender];\n', '      if (selfPartner != address(0)) {\n', '        if (partner[selfPartner] == msg.sender) {\n', '          partner[selfPartner] = address(0);\n', '          partnerCount--;\n', '          Farewell(msg.sender, selfPartner);\n', '        }\n', '      }\n', '      partner[msg.sender] = to;\n', '\n', '      address targetPartner = partner[to];\n', '      if (targetPartner != address(0)) {\n', '        if (partner[targetPartner] == to) {\n', '          partner[targetPartner] = address(0);\n', '          partnerCount--;\n', '          Farewell(to, targetPartner);\n', '        }\n', '      }\n', '      partner[to] = msg.sender;\n', '\n', '      partnerCount++;\n', '      Partner(msg.sender, to);\n', '\n', '    } else {\n', '      if (propose[msg.sender] == address(0)) {\n', '        proposeCount++;\n', '      }\n', '      propose[msg.sender] = to;\n', '      Propose(msg.sender, to);\n', '    }\n', '  }\n', '\n', '  function cancelProposeTo() public {\n', '    address proposingTo = propose[msg.sender];\n', '    require(proposingTo != address(0));\n', '    propose[msg.sender] = address(0);\n', '    proposeCount--;\n', '    CancelPropose(msg.sender, proposingTo);\n', '  }\n', '\n', '  function addMessage(string message) public {\n', '    address target = partner[msg.sender];\n', '    require(isPartner(msg.sender, target) == true);\n', '    uint index = partnerMessages[uint256(keccak256(craetePartnerBytes(msg.sender, target)))].push(message) - 1;\n', '    Message(msg.sender, target, message, index);\n', '  }\n', '\n', '  function farewellTo(address to) public {\n', '    require(partner[msg.sender] == to);\n', '    require(partner[to] == msg.sender);\n', '    partner[msg.sender] = address(0);\n', '    partner[to] = address(0);\n', '    partnerCount--;\n', '    Farewell(msg.sender, to);\n', '  }\n', '\n', '  function isPartner(address a, address b) public view returns (bool) {\n', '    require(a != address(0));\n', '    require(b != address(0));\n', '    return (a == partner[b]) && (b == partner[a]);\n', '  }\n', '\n', '  function getPropose(address a) public view returns (address) {\n', '    return propose[a];\n', '  }\n', '\n', '  function getPartner(address a) public view returns (address) {\n', '    return partner[a];\n', '  }\n', '\n', '  function getPartnerMessage(address a, address b, uint index) public view returns (string) {\n', '    require(isPartner(a, b) == true);\n', '    uint256 key = uint256(keccak256(craetePartnerBytes(a, b)));\n', '    if (isHiddenMessages[key] == true) {\n', '      require((msg.sender == a) || (msg.sender == b));\n', '    }\n', '    uint count = partnerMessages[key].length;\n', '    require(index < count);\n', '    return partnerMessages[key][index];\n', '  }\n', '\n', '  function partnerMessagesCount(address a, address b) public view returns (uint) {\n', '    require(isPartner(a, b) == true);\n', '    uint256 key = uint256(keccak256(craetePartnerBytes(a, b)));\n', '    if (isHiddenMessages[key] == true) {\n', '      require((msg.sender == a) || (msg.sender == b));\n', '    }\n', '    return partnerMessages[key].length;\n', '  }\n', '\n', '  function getOwnPartnerMessage(uint index) public view returns (string) {\n', '    return getPartnerMessage(msg.sender, partner[msg.sender], index);\n', '  }\n', '\n', '  function craetePartnerBytes(address a, address b) private pure returns(bytes) {\n', '    bytes memory arr = new bytes(64);\n', '    bytes32 first;\n', '    bytes32 second;\n', '    if (uint160(a) < uint160(b)) {\n', '      first = keccak256(a);\n', '      second = keccak256(b);\n', '    } else {\n', '      first = keccak256(b);\n', '      second = keccak256(a);\n', '    }\n', '\n', '    for (uint i = 0; i < 32; i++) {\n', '      arr[i] = first[i];\n', '      arr[i + 32] = second[i];\n', '    }\n', '    return arr;\n', '  }\n', '\n', '  function setIsHiddenMessages(bool flag) public {\n', '    require(isPartner(msg.sender, partner[msg.sender]) == true);\n', '    uint256 key = uint256(keccak256(craetePartnerBytes(msg.sender, partner[msg.sender])));\n', '    isHiddenMessages[key] = flag;\n', '    HiddenMessages(msg.sender, partner[msg.sender], flag);\n', '  }\n', '}']
['pragma solidity ^0.4.19;\n', '\n', 'contract Love {\n', '\n', '  mapping (address => address) private propose;\n', '  mapping (address => address) private partner;\n', '  mapping (uint256 => string[]) private partnerMessages;\n', '  mapping (uint256 => bool) private isHiddenMessages;\n', '  uint public proposeCount;\n', '  uint public partnerCount;\n', '\n', '  event Propose(address indexed from, address indexed to);\n', '  event CancelPropose(address indexed from, address indexed to);\n', '  event Partner(address indexed from, address indexed to);\n', '  event Farewell(address indexed from, address indexed to);\n', '  event Message(address indexed addressOne, address indexed addressTwo, string message, uint index);\n', '  event HiddenMessages(address indexed addressOne, address indexed addressTwo, bool flag);\n', '\n', '  function proposeTo(address to) public {\n', '    require(to != address(0));\n', '    require(msg.sender != to);\n', '    require(partner[msg.sender] != to);\n', '\n', '    address alreadyPropose = propose[to];\n', '    if (alreadyPropose == msg.sender) {\n', '      propose[to] = address(0);\n', '      if (propose[msg.sender] != address(0)) {\n', '        propose[msg.sender] = address(0);\n', '        proposeCount -= 2;\n', '\n', '      } else {\n', '        proposeCount--;\n', '      }\n', '\n', '      address selfPartner = partner[msg.sender];\n', '      if (selfPartner != address(0)) {\n', '        if (partner[selfPartner] == msg.sender) {\n', '          partner[selfPartner] = address(0);\n', '          partnerCount--;\n', '          Farewell(msg.sender, selfPartner);\n', '        }\n', '      }\n', '      partner[msg.sender] = to;\n', '\n', '      address targetPartner = partner[to];\n', '      if (targetPartner != address(0)) {\n', '        if (partner[targetPartner] == to) {\n', '          partner[targetPartner] = address(0);\n', '          partnerCount--;\n', '          Farewell(to, targetPartner);\n', '        }\n', '      }\n', '      partner[to] = msg.sender;\n', '\n', '      partnerCount++;\n', '      Partner(msg.sender, to);\n', '\n', '    } else {\n', '      if (propose[msg.sender] == address(0)) {\n', '        proposeCount++;\n', '      }\n', '      propose[msg.sender] = to;\n', '      Propose(msg.sender, to);\n', '    }\n', '  }\n', '\n', '  function cancelProposeTo() public {\n', '    address proposingTo = propose[msg.sender];\n', '    require(proposingTo != address(0));\n', '    propose[msg.sender] = address(0);\n', '    proposeCount--;\n', '    CancelPropose(msg.sender, proposingTo);\n', '  }\n', '\n', '  function addMessage(string message) public {\n', '    address target = partner[msg.sender];\n', '    require(isPartner(msg.sender, target) == true);\n', '    uint index = partnerMessages[uint256(keccak256(craetePartnerBytes(msg.sender, target)))].push(message) - 1;\n', '    Message(msg.sender, target, message, index);\n', '  }\n', '\n', '  function farewellTo(address to) public {\n', '    require(partner[msg.sender] == to);\n', '    require(partner[to] == msg.sender);\n', '    partner[msg.sender] = address(0);\n', '    partner[to] = address(0);\n', '    partnerCount--;\n', '    Farewell(msg.sender, to);\n', '  }\n', '\n', '  function isPartner(address a, address b) public view returns (bool) {\n', '    require(a != address(0));\n', '    require(b != address(0));\n', '    return (a == partner[b]) && (b == partner[a]);\n', '  }\n', '\n', '  function getPropose(address a) public view returns (address) {\n', '    return propose[a];\n', '  }\n', '\n', '  function getPartner(address a) public view returns (address) {\n', '    return partner[a];\n', '  }\n', '\n', '  function getPartnerMessage(address a, address b, uint index) public view returns (string) {\n', '    require(isPartner(a, b) == true);\n', '    uint256 key = uint256(keccak256(craetePartnerBytes(a, b)));\n', '    if (isHiddenMessages[key] == true) {\n', '      require((msg.sender == a) || (msg.sender == b));\n', '    }\n', '    uint count = partnerMessages[key].length;\n', '    require(index < count);\n', '    return partnerMessages[key][index];\n', '  }\n', '\n', '  function partnerMessagesCount(address a, address b) public view returns (uint) {\n', '    require(isPartner(a, b) == true);\n', '    uint256 key = uint256(keccak256(craetePartnerBytes(a, b)));\n', '    if (isHiddenMessages[key] == true) {\n', '      require((msg.sender == a) || (msg.sender == b));\n', '    }\n', '    return partnerMessages[key].length;\n', '  }\n', '\n', '  function getOwnPartnerMessage(uint index) public view returns (string) {\n', '    return getPartnerMessage(msg.sender, partner[msg.sender], index);\n', '  }\n', '\n', '  function craetePartnerBytes(address a, address b) private pure returns(bytes) {\n', '    bytes memory arr = new bytes(64);\n', '    bytes32 first;\n', '    bytes32 second;\n', '    if (uint160(a) < uint160(b)) {\n', '      first = keccak256(a);\n', '      second = keccak256(b);\n', '    } else {\n', '      first = keccak256(b);\n', '      second = keccak256(a);\n', '    }\n', '\n', '    for (uint i = 0; i < 32; i++) {\n', '      arr[i] = first[i];\n', '      arr[i + 32] = second[i];\n', '    }\n', '    return arr;\n', '  }\n', '\n', '  function setIsHiddenMessages(bool flag) public {\n', '    require(isPartner(msg.sender, partner[msg.sender]) == true);\n', '    uint256 key = uint256(keccak256(craetePartnerBytes(msg.sender, partner[msg.sender])));\n', '    isHiddenMessages[key] = flag;\n', '    HiddenMessages(msg.sender, partner[msg.sender], flag);\n', '  }\n', '}']