['pragma solidity ^0.4.11;\n', '\n', 'contract CardboardUnicorns {\n', '  address public owner;\n', '  function mint(address who, uint value);\n', '  function changeOwner(address _newOwner);\n', '  function withdraw();\n', '  function withdrawForeignTokens(address _tokenContract);\n', '}\n', 'contract RealUnicornCongress {\n', '  uint public priceOfAUnicornInFinney;\n', '}\n', 'contract ForeignToken {\n', '  function balanceOf(address _owner) constant returns (uint256);\n', '  function transfer(address _to, uint256 _value) returns (bool);\n', '}\n', '\n', 'contract CardboardUnicornAssembler {\n', '  address public cardboardUnicornTokenAddress;\n', '  address public realUnicornAddress = 0xfB6916095ca1df60bB79Ce92cE3Ea74c37c5d359;\n', '  address public owner = msg.sender;\n', '  uint public pricePerUnicorn = 1 finney;\n', '  uint public lastPriceSetDate = 0;\n', '  \n', '  event PriceUpdate(uint newPrice, address updater);\n', '\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '  \n', '  /**\n', '   * Change ownership of the assembler\n', '   */\n', '  function changeOwner(address _newOwner) onlyOwner {\n', '    owner = _newOwner;\n', '  }\n', '  function changeTokenOwner(address _newOwner) onlyOwner {\n', '    CardboardUnicorns cu = CardboardUnicorns(cardboardUnicornTokenAddress);\n', '    cu.changeOwner(_newOwner);\n', '  }\n', '  \n', '  /**\n', '   * Change the CardboardUnicorns token contract managed by this contract\n', '   */\n', '  function changeCardboardUnicornTokenAddress(address _newTokenAddress) onlyOwner {\n', '    CardboardUnicorns cu = CardboardUnicorns(_newTokenAddress);\n', '    require(cu.owner() == address(this)); // We must be the owner of the token\n', '    cardboardUnicornTokenAddress = _newTokenAddress;\n', '  }\n', '  \n', '  /**\n', '   * Change the real unicorn contract location.\n', '   * This contract is used as a price reference; should the Ethereum Foundation\n', '   * re-deploy their contract, this should be called to update the reference.\n', '   */\n', '  function changeRealUnicornAddress(address _newUnicornAddress) onlyOwner {\n', '    realUnicornAddress = _newUnicornAddress;\n', '  }\n', '  \n', '  function withdraw(bool _includeToken) onlyOwner {\n', '    if (_includeToken) {\n', '      // First have the token contract send all its funds to its owner (which is us)\n', '      CardboardUnicorns cu = CardboardUnicorns(cardboardUnicornTokenAddress);\n', '      cu.withdraw();\n', '    }\n', '\n', '    // Then send that whole total to our owner\n', '    owner.transfer(this.balance);\n', '  }\n', '  function withdrawForeignTokens(address _tokenContract, bool _includeToken) onlyOwner {\n', '    ForeignToken token = ForeignToken(_tokenContract);\n', '\n', '    if (_includeToken) {\n', '      // First have the token contract send its tokens to its owner (which is us)\n', '      CardboardUnicorns cu = CardboardUnicorns(cardboardUnicornTokenAddress);\n', '      cu.withdrawForeignTokens(_tokenContract);\n', '    }\n', '\n', '    // Then send that whole total to our owner\n', '    uint256 amount = token.balanceOf(address(this));\n', '    token.transfer(owner, amount);\n', '  }\n', '\n', '  /**\n', '   * Update the price of a CardboardUnicorn to be 1/1000 a real Unicorn&#39;s price\n', '   */\n', '  function updatePriceFromRealUnicornPrice() {\n', '    require(block.timestamp > lastPriceSetDate + 7 days); // If owner set the price, cannot sync right after\n', '    RealUnicornCongress congress = RealUnicornCongress(realUnicornAddress);\n', '    pricePerUnicorn = (congress.priceOfAUnicornInFinney() * 1 finney) / 1000;\n', '    PriceUpdate(pricePerUnicorn, msg.sender);\n', '  }\n', '  \n', '  /**\n', '   * Set a specific price for a CardboardUnicorn\n', '   */\n', '  function setPrice(uint _newPrice) onlyOwner {\n', '    pricePerUnicorn = _newPrice;\n', '    lastPriceSetDate = block.timestamp;\n', '    PriceUpdate(pricePerUnicorn, msg.sender);\n', '  }\n', '  \n', '  /**\n', '   * Strap a horn to a horse!\n', '   */\n', '  function assembleUnicorn() payable {\n', '    if (msg.value >= pricePerUnicorn) {\n', '        CardboardUnicorns cu = CardboardUnicorns(cardboardUnicornTokenAddress);\n', '        cu.mint(msg.sender, msg.value / pricePerUnicorn);\n', '        owner.transfer(msg.value);\n', '    }\n', '  }\n', '  \n', '  function() payable {\n', '      assembleUnicorn();\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.11;\n', '\n', 'contract CardboardUnicorns {\n', '  address public owner;\n', '  function mint(address who, uint value);\n', '  function changeOwner(address _newOwner);\n', '  function withdraw();\n', '  function withdrawForeignTokens(address _tokenContract);\n', '}\n', 'contract RealUnicornCongress {\n', '  uint public priceOfAUnicornInFinney;\n', '}\n', 'contract ForeignToken {\n', '  function balanceOf(address _owner) constant returns (uint256);\n', '  function transfer(address _to, uint256 _value) returns (bool);\n', '}\n', '\n', 'contract CardboardUnicornAssembler {\n', '  address public cardboardUnicornTokenAddress;\n', '  address public realUnicornAddress = 0xfB6916095ca1df60bB79Ce92cE3Ea74c37c5d359;\n', '  address public owner = msg.sender;\n', '  uint public pricePerUnicorn = 1 finney;\n', '  uint public lastPriceSetDate = 0;\n', '  \n', '  event PriceUpdate(uint newPrice, address updater);\n', '\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '  \n', '  /**\n', '   * Change ownership of the assembler\n', '   */\n', '  function changeOwner(address _newOwner) onlyOwner {\n', '    owner = _newOwner;\n', '  }\n', '  function changeTokenOwner(address _newOwner) onlyOwner {\n', '    CardboardUnicorns cu = CardboardUnicorns(cardboardUnicornTokenAddress);\n', '    cu.changeOwner(_newOwner);\n', '  }\n', '  \n', '  /**\n', '   * Change the CardboardUnicorns token contract managed by this contract\n', '   */\n', '  function changeCardboardUnicornTokenAddress(address _newTokenAddress) onlyOwner {\n', '    CardboardUnicorns cu = CardboardUnicorns(_newTokenAddress);\n', '    require(cu.owner() == address(this)); // We must be the owner of the token\n', '    cardboardUnicornTokenAddress = _newTokenAddress;\n', '  }\n', '  \n', '  /**\n', '   * Change the real unicorn contract location.\n', '   * This contract is used as a price reference; should the Ethereum Foundation\n', '   * re-deploy their contract, this should be called to update the reference.\n', '   */\n', '  function changeRealUnicornAddress(address _newUnicornAddress) onlyOwner {\n', '    realUnicornAddress = _newUnicornAddress;\n', '  }\n', '  \n', '  function withdraw(bool _includeToken) onlyOwner {\n', '    if (_includeToken) {\n', '      // First have the token contract send all its funds to its owner (which is us)\n', '      CardboardUnicorns cu = CardboardUnicorns(cardboardUnicornTokenAddress);\n', '      cu.withdraw();\n', '    }\n', '\n', '    // Then send that whole total to our owner\n', '    owner.transfer(this.balance);\n', '  }\n', '  function withdrawForeignTokens(address _tokenContract, bool _includeToken) onlyOwner {\n', '    ForeignToken token = ForeignToken(_tokenContract);\n', '\n', '    if (_includeToken) {\n', '      // First have the token contract send its tokens to its owner (which is us)\n', '      CardboardUnicorns cu = CardboardUnicorns(cardboardUnicornTokenAddress);\n', '      cu.withdrawForeignTokens(_tokenContract);\n', '    }\n', '\n', '    // Then send that whole total to our owner\n', '    uint256 amount = token.balanceOf(address(this));\n', '    token.transfer(owner, amount);\n', '  }\n', '\n', '  /**\n', "   * Update the price of a CardboardUnicorn to be 1/1000 a real Unicorn's price\n", '   */\n', '  function updatePriceFromRealUnicornPrice() {\n', '    require(block.timestamp > lastPriceSetDate + 7 days); // If owner set the price, cannot sync right after\n', '    RealUnicornCongress congress = RealUnicornCongress(realUnicornAddress);\n', '    pricePerUnicorn = (congress.priceOfAUnicornInFinney() * 1 finney) / 1000;\n', '    PriceUpdate(pricePerUnicorn, msg.sender);\n', '  }\n', '  \n', '  /**\n', '   * Set a specific price for a CardboardUnicorn\n', '   */\n', '  function setPrice(uint _newPrice) onlyOwner {\n', '    pricePerUnicorn = _newPrice;\n', '    lastPriceSetDate = block.timestamp;\n', '    PriceUpdate(pricePerUnicorn, msg.sender);\n', '  }\n', '  \n', '  /**\n', '   * Strap a horn to a horse!\n', '   */\n', '  function assembleUnicorn() payable {\n', '    if (msg.value >= pricePerUnicorn) {\n', '        CardboardUnicorns cu = CardboardUnicorns(cardboardUnicornTokenAddress);\n', '        cu.mint(msg.sender, msg.value / pricePerUnicorn);\n', '        owner.transfer(msg.value);\n', '    }\n', '  }\n', '  \n', '  function() payable {\n', '      assembleUnicorn();\n', '  }\n', '\n', '}']
