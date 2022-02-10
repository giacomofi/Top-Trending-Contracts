['pragma solidity ^0.4.11;\n', '\n', 'contract SafeMath {\n', '    function safeAdd(uint256 x, uint256 y) internal returns(uint256) {\n', '      uint256 z = x + y;\n', '      assert((z >= x) && (z >= y));\n', '      return z;\n', '    }\n', '\n', '    function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {\n', '      assert(x >= y);\n', '      uint256 z = x - y;\n', '      return z;\n', '    }\n', '\n', '    function safeMult(uint256 x, uint256 y) internal returns(uint256) {\n', '      uint256 z = x * y;\n', '      assert((x == 0)||(z/x == y));\n', '      return z;\n', '    }\n', '}\n', '\n', '\n', 'contract IndorsePreSale is SafeMath{\n', '    // Fund deposit address\n', '    address public ethFundDeposit = "0x1c82ee5b828455F870eb2998f2c9b6Cc2d52a5F6";                              \n', '    address public owner;                                       // Owner of the pre sale contract\n', '    mapping (address => uint256) public whiteList;\n', '\n', '    // presale parameters\n', '    bool public isFinalized;                                    // switched to true in operational state\n', '    uint256 public constant maxLimit =  14000 ether;            // Maximum limit for taking in the money\n', '    uint256 public constant minRequired = 100 ether;            // Minimum contribution per person\n', '    uint256 public totalSupply;\n', '    mapping (address => uint256) public balances;\n', '    \n', '    // events\n', '    event Contribution(address indexed _to, uint256 _value);\n', '    \n', '    modifier onlyOwner() {\n', '      require (msg.sender == owner);\n', '      _;\n', '    }\n', '\n', '    // @dev constructor\n', '    function IndorsePreSale() {\n', '      isFinalized = false;                                      //controls pre through crowdsale state\n', '      owner = msg.sender;\n', '      totalSupply = 0;\n', '    }\n', '\n', '    // @dev this function accepts Ether and increases the balances of the contributors\n', '    function() payable {           \n', '      uint256 checkedSupply = safeAdd(totalSupply, msg.value);\n', '      require (msg.value >= minRequired);                        // The contribution needs to be above 100 Ether\n', '      require (!isFinalized);                                    // Cannot accept Ether after finalizing the contract\n', '      require (checkedSupply <= maxLimit);\n', '      require (whiteList[msg.sender] == 1);\n', '      balances[msg.sender] = safeAdd(balances[msg.sender], msg.value);\n', '      \n', '      totalSupply = safeAdd(totalSupply, msg.value);\n', '      Contribution(msg.sender, msg.value);\n', '      ethFundDeposit.transfer(this.balance);                     // send the eth to Indorse multi-sig\n', '    }\n', '    \n', '    // @dev adds an Ethereum address to whitelist\n', '    function setWhiteList(address _whitelisted) onlyOwner {\n', '      whiteList[_whitelisted] = 1;\n', '    }\n', '\n', '    // @dev removed an Ethereum address from whitelist\n', '    function removeWhiteList(address _whitelisted) onlyOwner {\n', '      whiteList[_whitelisted] = 0;\n', '    }\n', '\n', '    /// @dev Ends the funding period and sends the ETH home\n', '    function finalize() external onlyOwner {\n', '      require (!isFinalized);\n', '      // move to operational\n', '      isFinalized = true;\n', '      ethFundDeposit.transfer(this.balance);                     // send the eth to Indorse multi-sig\n', '    }\n', '}']