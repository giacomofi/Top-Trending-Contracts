['pragma solidity ^0.4.4;\n', '\n', 'contract Registry {\n', '  address owner;\n', '  mapping (address => uint) public expirations;\n', '  uint public weiPerBlock;\n', '  uint public minBlockPurchase;\n', '\n', '  function Registry() {\n', '    owner = msg.sender;\n', '    // works out to about $7 per month\n', '    weiPerBlock = 100000000000;\n', '    // roughly 1 day worth of blocks at 20 sec transaction time\n', '    minBlockPurchase = 4320;\n', '  }\n', '\n', '  function () payable {\n', '    uint senderExpirationBlock = expirations[msg.sender];\n', '    if (senderExpirationBlock > 0 && senderExpirationBlock < block.number) {\n', '      // The sender already has credit, add to it\n', '      expirations[msg.sender] = senderExpirationBlock + blocksForWei(msg.value);\n', '    } else {\n', '      // The senders credit has either expired or the sender is unregistered\n', '      // Give them block credits starting from the current block\n', '      expirations[msg.sender] = block.number + blocksForWei(msg.value);\n', '    }\n', '  }\n', '\n', '  function blocksForWei(uint weiValue) returns (uint) {\n', '    assert(weiValue >= weiPerBlock * minBlockPurchase);\n', '    return weiValue / weiPerBlock;\n', '  }\n', '\n', '  function setWeiPerBlock(uint newWeiPerBlock) {\n', '    if (msg.sender == owner) weiPerBlock = newWeiPerBlock;\n', '  }\n', '\n', '  function setMinBlockPurchase(uint newMinBlockPurchase) {\n', '    if (msg.sender == owner) minBlockPurchase = newMinBlockPurchase;\n', '  }\n', '\n', '  function withdraw(uint weiValue) {\n', '    if (msg.sender == owner) owner.transfer(weiValue);\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.4;\n', '\n', 'contract Registry {\n', '  address owner;\n', '  mapping (address => uint) public expirations;\n', '  uint public weiPerBlock;\n', '  uint public minBlockPurchase;\n', '\n', '  function Registry() {\n', '    owner = msg.sender;\n', '    // works out to about $7 per month\n', '    weiPerBlock = 100000000000;\n', '    // roughly 1 day worth of blocks at 20 sec transaction time\n', '    minBlockPurchase = 4320;\n', '  }\n', '\n', '  function () payable {\n', '    uint senderExpirationBlock = expirations[msg.sender];\n', '    if (senderExpirationBlock > 0 && senderExpirationBlock < block.number) {\n', '      // The sender already has credit, add to it\n', '      expirations[msg.sender] = senderExpirationBlock + blocksForWei(msg.value);\n', '    } else {\n', '      // The senders credit has either expired or the sender is unregistered\n', '      // Give them block credits starting from the current block\n', '      expirations[msg.sender] = block.number + blocksForWei(msg.value);\n', '    }\n', '  }\n', '\n', '  function blocksForWei(uint weiValue) returns (uint) {\n', '    assert(weiValue >= weiPerBlock * minBlockPurchase);\n', '    return weiValue / weiPerBlock;\n', '  }\n', '\n', '  function setWeiPerBlock(uint newWeiPerBlock) {\n', '    if (msg.sender == owner) weiPerBlock = newWeiPerBlock;\n', '  }\n', '\n', '  function setMinBlockPurchase(uint newMinBlockPurchase) {\n', '    if (msg.sender == owner) minBlockPurchase = newMinBlockPurchase;\n', '  }\n', '\n', '  function withdraw(uint weiValue) {\n', '    if (msg.sender == owner) owner.transfer(weiValue);\n', '  }\n', '\n', '}']