['pragma solidity ^0.4.4;\n', '\n', '// kovan:   0x722475921ebc15078d4d6c93b4cff43eadf099c2\n', '// mainnet: 0x942ffef843d37805c59f30fabb99b46aad135288\n', '\n', 'contract PreTgeExperty {\n', '\n', '  // TGE\n', '  struct Contributor {\n', '    address addr;\n', '    uint256 amount;\n', '    uint256 timestamp;\n', '    bool rejected;\n', '  }\n', '  Contributor[] public contributors;\n', '  mapping(address => bool) public isWhitelisted;\n', '  address public managerAddr;\n', '  address public whitelistManagerAddr;\n', '\n', '  // wallet\n', '  struct Tx {\n', '    address founder;\n', '    address destAddr;\n', '    uint256 amount;\n', '    bool active;\n', '  }\n', '  mapping (address => bool) public founders;\n', '  Tx[] public txs;\n', '\n', '  // preTGE constructor\n', '  function PreTgeExperty() public {\n', '    whitelistManagerAddr = 0x8179C4797948cb4922bd775D3BcE90bEFf652b23;\n', '    managerAddr = 0x9B7A647b3e20d0c8702bAF6c0F79beb8E9B58b25;\n', '    founders[0xCE05A8Aa56E1054FAFC214788246707F5258c0Ae] = true;\n', '    founders[0xBb62A710BDbEAF1d3AD417A222d1ab6eD08C37f5] = true;\n', '    founders[0x009A55A3c16953A359484afD299ebdC444200EdB] = true;\n', '  }\n', '\n', '  // whitelist address\n', '  function whitelist(address addr) public isWhitelistManager {\n', '    isWhitelisted[addr] = true;\n', '  }\n', '\n', '  function reject(uint256 idx) public isManager {\n', '    // contributor must exist\n', '    assert(contributors[idx].addr != 0);\n', '    // contribution cant be rejected\n', '    assert(!contributors[idx].rejected);\n', '\n', '    // de-whitelist address\n', '    isWhitelisted[contributors[idx].addr] = false;\n', '\n', '    // reject contribution\n', '    contributors[idx].rejected = true;\n', '\n', '    // return ETH to contributor\n', '    contributors[idx].addr.transfer(contributors[idx].amount);\n', '  }\n', '\n', '  // contribute function\n', '  function() public payable {\n', '    // allow to contribute only whitelisted KYC addresses\n', '    assert(isWhitelisted[msg.sender]);\n', '\n', '    // save contributor for further use\n', '    contributors.push(Contributor({\n', '      addr: msg.sender,\n', '      amount: msg.value,\n', '      timestamp: block.timestamp,\n', '      rejected: false\n', '    }));\n', '  }\n', '\n', '  // one of founders can propose destination address for ethers\n', '  function proposeTx(address destAddr, uint256 amount) public isFounder {\n', '    txs.push(Tx({\n', '      founder: msg.sender,\n', '      destAddr: destAddr,\n', '      amount: amount,\n', '      active: true\n', '    }));\n', '  }\n', '\n', '  // another founder can approve specified tx and send it to destAddr\n', '  function approveTx(uint8 txIdx) public isFounder {\n', '    assert(txs[txIdx].founder != msg.sender);\n', '    assert(txs[txIdx].active);\n', '\n', '    txs[txIdx].active = false;\n', '    txs[txIdx].destAddr.transfer(txs[txIdx].amount);\n', '  }\n', '\n', '  // founder who created tx can cancel it\n', '  function cancelTx(uint8 txIdx) {\n', '    assert(txs[txIdx].founder == msg.sender);\n', '    assert(txs[txIdx].active);\n', '\n', '    txs[txIdx].active = false;\n', '  }\n', '\n', '  // isManager modifier\n', '  modifier isManager() {\n', '    assert(msg.sender == managerAddr);\n', '    _;\n', '  }\n', '\n', '  // isWhitelistManager modifier\n', '  modifier isWhitelistManager() {\n', '    assert(msg.sender == whitelistManagerAddr);\n', '    _;\n', '  }\n', '\n', '  // check if msg.sender is founder\n', '  modifier isFounder() {\n', '    assert(founders[msg.sender]);\n', '    _;\n', '  }\n', '\n', '  // view functions\n', '  function getContributionsCount(address addr) view returns (uint count) {\n', '    count = 0;\n', '    for (uint i = 0; i < contributors.length; ++i) {\n', '      if (contributors[i].addr == addr) {\n', '        ++count;\n', '      }\n', '    }\n', '    return count;\n', '  }\n', '\n', '  function getContribution(address addr, uint idx) view returns (uint amount, uint timestamp, bool rejected) {\n', '    uint count = 0;\n', '    for (uint i = 0; i < contributors.length; ++i) {\n', '      if (contributors[i].addr == addr) {\n', '        if (count == idx) {\n', '          return (contributors[i].amount, contributors[i].timestamp, contributors[i].rejected);\n', '        }\n', '        ++count;\n', '      }\n', '    }\n', '    return (0, 0, false);\n', '  }\n', '}']
['pragma solidity ^0.4.4;\n', '\n', '// kovan:   0x722475921ebc15078d4d6c93b4cff43eadf099c2\n', '// mainnet: 0x942ffef843d37805c59f30fabb99b46aad135288\n', '\n', 'contract PreTgeExperty {\n', '\n', '  // TGE\n', '  struct Contributor {\n', '    address addr;\n', '    uint256 amount;\n', '    uint256 timestamp;\n', '    bool rejected;\n', '  }\n', '  Contributor[] public contributors;\n', '  mapping(address => bool) public isWhitelisted;\n', '  address public managerAddr;\n', '  address public whitelistManagerAddr;\n', '\n', '  // wallet\n', '  struct Tx {\n', '    address founder;\n', '    address destAddr;\n', '    uint256 amount;\n', '    bool active;\n', '  }\n', '  mapping (address => bool) public founders;\n', '  Tx[] public txs;\n', '\n', '  // preTGE constructor\n', '  function PreTgeExperty() public {\n', '    whitelistManagerAddr = 0x8179C4797948cb4922bd775D3BcE90bEFf652b23;\n', '    managerAddr = 0x9B7A647b3e20d0c8702bAF6c0F79beb8E9B58b25;\n', '    founders[0xCE05A8Aa56E1054FAFC214788246707F5258c0Ae] = true;\n', '    founders[0xBb62A710BDbEAF1d3AD417A222d1ab6eD08C37f5] = true;\n', '    founders[0x009A55A3c16953A359484afD299ebdC444200EdB] = true;\n', '  }\n', '\n', '  // whitelist address\n', '  function whitelist(address addr) public isWhitelistManager {\n', '    isWhitelisted[addr] = true;\n', '  }\n', '\n', '  function reject(uint256 idx) public isManager {\n', '    // contributor must exist\n', '    assert(contributors[idx].addr != 0);\n', '    // contribution cant be rejected\n', '    assert(!contributors[idx].rejected);\n', '\n', '    // de-whitelist address\n', '    isWhitelisted[contributors[idx].addr] = false;\n', '\n', '    // reject contribution\n', '    contributors[idx].rejected = true;\n', '\n', '    // return ETH to contributor\n', '    contributors[idx].addr.transfer(contributors[idx].amount);\n', '  }\n', '\n', '  // contribute function\n', '  function() public payable {\n', '    // allow to contribute only whitelisted KYC addresses\n', '    assert(isWhitelisted[msg.sender]);\n', '\n', '    // save contributor for further use\n', '    contributors.push(Contributor({\n', '      addr: msg.sender,\n', '      amount: msg.value,\n', '      timestamp: block.timestamp,\n', '      rejected: false\n', '    }));\n', '  }\n', '\n', '  // one of founders can propose destination address for ethers\n', '  function proposeTx(address destAddr, uint256 amount) public isFounder {\n', '    txs.push(Tx({\n', '      founder: msg.sender,\n', '      destAddr: destAddr,\n', '      amount: amount,\n', '      active: true\n', '    }));\n', '  }\n', '\n', '  // another founder can approve specified tx and send it to destAddr\n', '  function approveTx(uint8 txIdx) public isFounder {\n', '    assert(txs[txIdx].founder != msg.sender);\n', '    assert(txs[txIdx].active);\n', '\n', '    txs[txIdx].active = false;\n', '    txs[txIdx].destAddr.transfer(txs[txIdx].amount);\n', '  }\n', '\n', '  // founder who created tx can cancel it\n', '  function cancelTx(uint8 txIdx) {\n', '    assert(txs[txIdx].founder == msg.sender);\n', '    assert(txs[txIdx].active);\n', '\n', '    txs[txIdx].active = false;\n', '  }\n', '\n', '  // isManager modifier\n', '  modifier isManager() {\n', '    assert(msg.sender == managerAddr);\n', '    _;\n', '  }\n', '\n', '  // isWhitelistManager modifier\n', '  modifier isWhitelistManager() {\n', '    assert(msg.sender == whitelistManagerAddr);\n', '    _;\n', '  }\n', '\n', '  // check if msg.sender is founder\n', '  modifier isFounder() {\n', '    assert(founders[msg.sender]);\n', '    _;\n', '  }\n', '\n', '  // view functions\n', '  function getContributionsCount(address addr) view returns (uint count) {\n', '    count = 0;\n', '    for (uint i = 0; i < contributors.length; ++i) {\n', '      if (contributors[i].addr == addr) {\n', '        ++count;\n', '      }\n', '    }\n', '    return count;\n', '  }\n', '\n', '  function getContribution(address addr, uint idx) view returns (uint amount, uint timestamp, bool rejected) {\n', '    uint count = 0;\n', '    for (uint i = 0; i < contributors.length; ++i) {\n', '      if (contributors[i].addr == addr) {\n', '        if (count == idx) {\n', '          return (contributors[i].amount, contributors[i].timestamp, contributors[i].rejected);\n', '        }\n', '        ++count;\n', '      }\n', '    }\n', '    return (0, 0, false);\n', '  }\n', '}']