['pragma solidity ^0.4.4;\n', '\n', 'contract ThreesigWallet {\n', '\n', '  mapping (address => bool) public founders;\n', '\n', '  struct Tx {\n', '    address founder;\n', '    address destAddr;\n', '    bool active;\n', '  }\n', '  \n', '  Tx[] public txs;\n', '  \n', '  // constructor made of 3 independent wallets\n', '  function ThreesigWallet() {\n', '    founders[0xCE05A8Aa56E1054FAFC214788246707F5258c0Ae] = true;\n', '    founders[0xBb62A710BDbEAF1d3AD417A222d1ab6eD08C37f5] = true;\n', '    founders[0x009A55A3c16953A359484afD299ebdC444200EdB] = true;\n', '  }\n', '  \n', '  // preICO contract will send ETHers here\n', '  function() payable {}\n', '  \n', '  // one of founders can propose destination address for ethers\n', '  function proposeTx(address destAddr) isFounder {\n', '    txs.push(Tx({\n', '      founder: msg.sender,\n', '      destAddr: destAddr,\n', '      active: true\n', '    }));\n', '  }\n', '  \n', '  // another founder can approve specified tx and send it to destAddr\n', '  function approveTx(uint8 txIdx) isFounder {\n', '    assert(txs[txIdx].founder != msg.sender);\n', '    assert(txs[txIdx].active);\n', '    \n', '    txs[txIdx].active = false;\n', '    txs[txIdx].destAddr.transfer(this.balance);\n', '  }\n', '\n', '  // cancel tx\n', '  function cancelTx(uint8 txIdx) isFounder {\n', '    assert(txs[txIdx].founder == msg.sender);\n', '    txs[txIdx].active = false;\n', '  }\n', '  \n', '  // check if msg.sender is founder\n', '  modifier isFounder() {\n', '    require(founders[msg.sender]);\n', '    _;\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.4;\n', '\n', 'contract ThreesigWallet {\n', '\n', '  mapping (address => bool) public founders;\n', '\n', '  struct Tx {\n', '    address founder;\n', '    address destAddr;\n', '    bool active;\n', '  }\n', '  \n', '  Tx[] public txs;\n', '  \n', '  // constructor made of 3 independent wallets\n', '  function ThreesigWallet() {\n', '    founders[0xCE05A8Aa56E1054FAFC214788246707F5258c0Ae] = true;\n', '    founders[0xBb62A710BDbEAF1d3AD417A222d1ab6eD08C37f5] = true;\n', '    founders[0x009A55A3c16953A359484afD299ebdC444200EdB] = true;\n', '  }\n', '  \n', '  // preICO contract will send ETHers here\n', '  function() payable {}\n', '  \n', '  // one of founders can propose destination address for ethers\n', '  function proposeTx(address destAddr) isFounder {\n', '    txs.push(Tx({\n', '      founder: msg.sender,\n', '      destAddr: destAddr,\n', '      active: true\n', '    }));\n', '  }\n', '  \n', '  // another founder can approve specified tx and send it to destAddr\n', '  function approveTx(uint8 txIdx) isFounder {\n', '    assert(txs[txIdx].founder != msg.sender);\n', '    assert(txs[txIdx].active);\n', '    \n', '    txs[txIdx].active = false;\n', '    txs[txIdx].destAddr.transfer(this.balance);\n', '  }\n', '\n', '  // cancel tx\n', '  function cancelTx(uint8 txIdx) isFounder {\n', '    assert(txs[txIdx].founder == msg.sender);\n', '    txs[txIdx].active = false;\n', '  }\n', '  \n', '  // check if msg.sender is founder\n', '  modifier isFounder() {\n', '    require(founders[msg.sender]);\n', '    _;\n', '  }\n', '\n', '}']
