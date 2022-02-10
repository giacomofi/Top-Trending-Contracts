['pragma solidity ^0.4.23;\n', '\n', '\n', '// @title ERC20 interface\n', '// @dev see https://github.com/ethereum/EIPs/issues/20\n', 'contract iERC20 {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 tokens);\n', '  event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);\n', '}\n', '\n', '\n', '\n', '\n', '\n', '// @title SafeMath\n', '// @dev Math operations with safety checks that throw on error\n', 'library SafeMath {\n', '\n', '  // @dev Multiplies two numbers, throws on overflow.\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    require(c / a == b, "mul failed");\n', '    return c;\n', '  }\n', '\n', '  // @dev Integer division of two numbers, truncating the quotient.\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  // @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a, "sub fail");\n', '    return a - b;\n', '  }\n', '\n', '  // @dev Adds two numbers, throws on overflow.\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    require(c >= a, "add fail");\n', '    return c;\n', '  }\n', '}\n', '\n', '/* \n', '  Copyright 2018 Token Sales Network (https://tokensales.io)\n', '  Licensed under the MIT license (https://opensource.org/licenses/MIT)\n', '\n', '  Permission is hereby granted, free of charge, to any person obtaining a copy of this software \n', '  and associated documentation files (the "Software"), to deal in the Software without restriction, \n', '  including without limitation the rights to use, copy, modify, merge, publish, distribute, \n', '  sublicense, and/or sell copies of the Software, and to permit persons to whom the Software \n', '  is furnished to do so, subject to the following conditions:\n', '\n', '  The above copyright notice and this permission notice shall be included in all copies or \n', '  substantial portions of the Software.\n', '\n', '  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING \n', '  BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND \n', '  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, \n', '  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, \n', '  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n', '*/\n', '\n', '// @title Token Sale Network\n', '// A contract allowing users to buy a supply of tokens\n', '// Adapted from OpenZeppelin&#39;s Crowdsale contract\n', '// \n', 'contract TokenSales {\n', '  using SafeMath for uint256;\n', '\n', '  // Event for token purchase logging\n', '  // @param token that was sold\n', '  // @param seller who sold the tokens\n', '  // @param purchaser who paid for the tokens\n', '  // @param value weis paid for purchase\n', '  // @param amount amount of tokens purchased\n', '  event TokenPurchase(\n', '    address indexed token,\n', '    address indexed seller,\n', '    address indexed purchaser,\n', '    uint256 value,\n', '    uint256 amount\n', '  );\n', '\n', '  mapping(address => mapping(address => uint)) public saleAmounts;\n', '  mapping(address => mapping(address => uint)) public saleRates;\n', '\n', '  // @dev create a sale of tokens.\n', '  // @param _token - must be an ERC20 token\n', '  // @param _rate - how many token units a buyer gets per wei.\n', '  //   The rate is the conversion between wei and the smallest and indivisible token unit.\n', '  //   So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK\n', '  //   1 wei will give you 1 unit, or 0.001 TOK.\n', '  // @param _addedTokens - the number of tokens to add to the sale\n', '  function createSale(iERC20 token, uint256 rate, uint256 addedTokens) public {\n', '    uint currentSaleAmount = saleAmounts[msg.sender][token];\n', '    if(addedTokens > 0 || currentSaleAmount > 0) {\n', '      saleRates[msg.sender][token] = rate;\n', '    }\n', '    if (addedTokens > 0) {\n', '      saleAmounts[msg.sender][token] = currentSaleAmount.add(addedTokens);\n', '      token.transferFrom(msg.sender, address(this), addedTokens);\n', '    }\n', '  }\n', '\n', '  // @dev A payable function that takes ETH, and pays out in the token specified.\n', '  // @param seller - address selling the token\n', '  // @param token - the token address\n', '  function buy(iERC20 token, address seller) public payable {\n', '    uint size;\n', '    address sender = msg.sender;\n', '    assembly { size := extcodesize(sender) }\n', '    require(size == 0); // Disallow calling from contracts, for safety\n', '    uint256 weiAmount = msg.value;\n', '    require(weiAmount > 0);\n', '\n', '    uint rate = saleRates[seller][token];\n', '    uint amount = saleAmounts[seller][token];\n', '    require(rate > 0);\n', '\n', '    uint256 tokens = weiAmount.mul(rate);\n', '    saleAmounts[seller][token] = amount.sub(tokens);\n', '\n', '    emit TokenPurchase(\n', '      token,\n', '      seller,\n', '      msg.sender,\n', '      weiAmount,\n', '      tokens\n', '    );\n', '\n', '    token.transfer(msg.sender, tokens);\n', '    seller.transfer(msg.value);\n', '  }\n', '\n', '  // dev Cancels all the sender&#39;s sales of a given token\n', '  // @param token - the address of the token to be cancelled.\n', '  function cancelSale(iERC20 token) public {\n', '    uint amount = saleAmounts[msg.sender][token];\n', '    require(amount > 0);\n', '\n', '    delete saleAmounts[msg.sender][token];\n', '    delete saleRates[msg.sender][token];\n', '\n', '    if (amount > 0) {\n', '      token.transfer(msg.sender, amount);\n', '    }\n', '  }\n', '\n', '  // @dev fallback function always throws\n', '  function () external payable {\n', '    revert();\n', '  }\n', '}']
['pragma solidity ^0.4.23;\n', '\n', '\n', '// @title ERC20 interface\n', '// @dev see https://github.com/ethereum/EIPs/issues/20\n', 'contract iERC20 {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 tokens);\n', '  event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);\n', '}\n', '\n', '\n', '\n', '\n', '\n', '// @title SafeMath\n', '// @dev Math operations with safety checks that throw on error\n', 'library SafeMath {\n', '\n', '  // @dev Multiplies two numbers, throws on overflow.\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    require(c / a == b, "mul failed");\n', '    return c;\n', '  }\n', '\n', '  // @dev Integer division of two numbers, truncating the quotient.\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  // @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a, "sub fail");\n', '    return a - b;\n', '  }\n', '\n', '  // @dev Adds two numbers, throws on overflow.\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    require(c >= a, "add fail");\n', '    return c;\n', '  }\n', '}\n', '\n', '/* \n', '  Copyright 2018 Token Sales Network (https://tokensales.io)\n', '  Licensed under the MIT license (https://opensource.org/licenses/MIT)\n', '\n', '  Permission is hereby granted, free of charge, to any person obtaining a copy of this software \n', '  and associated documentation files (the "Software"), to deal in the Software without restriction, \n', '  including without limitation the rights to use, copy, modify, merge, publish, distribute, \n', '  sublicense, and/or sell copies of the Software, and to permit persons to whom the Software \n', '  is furnished to do so, subject to the following conditions:\n', '\n', '  The above copyright notice and this permission notice shall be included in all copies or \n', '  substantial portions of the Software.\n', '\n', '  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING \n', '  BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND \n', '  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, \n', '  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, \n', '  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n', '*/\n', '\n', '// @title Token Sale Network\n', '// A contract allowing users to buy a supply of tokens\n', "// Adapted from OpenZeppelin's Crowdsale contract\n", '// \n', 'contract TokenSales {\n', '  using SafeMath for uint256;\n', '\n', '  // Event for token purchase logging\n', '  // @param token that was sold\n', '  // @param seller who sold the tokens\n', '  // @param purchaser who paid for the tokens\n', '  // @param value weis paid for purchase\n', '  // @param amount amount of tokens purchased\n', '  event TokenPurchase(\n', '    address indexed token,\n', '    address indexed seller,\n', '    address indexed purchaser,\n', '    uint256 value,\n', '    uint256 amount\n', '  );\n', '\n', '  mapping(address => mapping(address => uint)) public saleAmounts;\n', '  mapping(address => mapping(address => uint)) public saleRates;\n', '\n', '  // @dev create a sale of tokens.\n', '  // @param _token - must be an ERC20 token\n', '  // @param _rate - how many token units a buyer gets per wei.\n', '  //   The rate is the conversion between wei and the smallest and indivisible token unit.\n', '  //   So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK\n', '  //   1 wei will give you 1 unit, or 0.001 TOK.\n', '  // @param _addedTokens - the number of tokens to add to the sale\n', '  function createSale(iERC20 token, uint256 rate, uint256 addedTokens) public {\n', '    uint currentSaleAmount = saleAmounts[msg.sender][token];\n', '    if(addedTokens > 0 || currentSaleAmount > 0) {\n', '      saleRates[msg.sender][token] = rate;\n', '    }\n', '    if (addedTokens > 0) {\n', '      saleAmounts[msg.sender][token] = currentSaleAmount.add(addedTokens);\n', '      token.transferFrom(msg.sender, address(this), addedTokens);\n', '    }\n', '  }\n', '\n', '  // @dev A payable function that takes ETH, and pays out in the token specified.\n', '  // @param seller - address selling the token\n', '  // @param token - the token address\n', '  function buy(iERC20 token, address seller) public payable {\n', '    uint size;\n', '    address sender = msg.sender;\n', '    assembly { size := extcodesize(sender) }\n', '    require(size == 0); // Disallow calling from contracts, for safety\n', '    uint256 weiAmount = msg.value;\n', '    require(weiAmount > 0);\n', '\n', '    uint rate = saleRates[seller][token];\n', '    uint amount = saleAmounts[seller][token];\n', '    require(rate > 0);\n', '\n', '    uint256 tokens = weiAmount.mul(rate);\n', '    saleAmounts[seller][token] = amount.sub(tokens);\n', '\n', '    emit TokenPurchase(\n', '      token,\n', '      seller,\n', '      msg.sender,\n', '      weiAmount,\n', '      tokens\n', '    );\n', '\n', '    token.transfer(msg.sender, tokens);\n', '    seller.transfer(msg.value);\n', '  }\n', '\n', "  // dev Cancels all the sender's sales of a given token\n", '  // @param token - the address of the token to be cancelled.\n', '  function cancelSale(iERC20 token) public {\n', '    uint amount = saleAmounts[msg.sender][token];\n', '    require(amount > 0);\n', '\n', '    delete saleAmounts[msg.sender][token];\n', '    delete saleRates[msg.sender][token];\n', '\n', '    if (amount > 0) {\n', '      token.transfer(msg.sender, amount);\n', '    }\n', '  }\n', '\n', '  // @dev fallback function always throws\n', '  function () external payable {\n', '    revert();\n', '  }\n', '}']