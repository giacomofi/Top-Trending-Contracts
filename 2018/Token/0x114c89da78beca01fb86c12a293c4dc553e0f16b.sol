['pragma solidity ^0.4.16;\n', '\n', 'interface Token3DAPP {\n', '    function transfer(address receiver, uint amount);\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '\n', 'contract PreSale3DAPP is Pausable {\n', '    using SafeMath for uint256;\n', '\n', '    Token3DAPP public tokenReward; \n', '    uint256 public deadline;\n', '\n', '    uint256 public tokenPrice = 10000; // 1 ETH = 10 000 Tokens\n', '    uint256 public minimalETH = 200000000000000000; // minimal = 0.2 ETH\n', '\n', '    function PreSale3DAPP(address _tokenReward) {\n', '        tokenReward = Token3DAPP(_tokenReward); // our token address\n', '        deadline = block.timestamp.add(2 weeks); \n', '    }\n', '\n', '    function () whenNotPaused payable {\n', '        buy(msg.sender);\n', '    }\n', '\n', '    function buy(address buyer) whenNotPaused payable {\n', '        require(buyer != address(0));\n', '        require(msg.value != 0);\n', '        require(msg.value >= minimalETH);\n', '\n', '        uint amount = msg.value;\n', '        uint tokens = amount.mul(tokenPrice);\n', '        tokenReward.transfer(buyer, tokens);\n', '    }\n', '\n', '    function transferFund() onlyOwner {\n', '        owner.transfer(this.balance);\n', '    }\n', '\n', '    function updatePrice(uint256 _tokenPrice) onlyOwner {\n', '        tokenPrice = _tokenPrice;\n', '    }\n', '\n', '    function updateMinimal(uint256 _minimalETH) onlyOwner {\n', '        minimalETH = _minimalETH;\n', '    }\n', '\n', '    function transferTokens(uint256 _tokens) onlyOwner {\n', '        tokenReward.transfer(owner, _tokens); \n', '    }\n', '\n', '    // airdrop\n', '    function airdrop(address[] _array1, uint256[] _array2) onlyOwner {\n', '       address[] memory arrayAddress = _array1;\n', '       uint256[] memory arrayAmount = _array2;\n', '       uint256 arrayLength = arrayAddress.length.sub(1);\n', '       uint256 i = 0;\n', '       \n', '       while (i <= arrayLength) {\n', '           tokenReward.transfer(arrayAddress[i], arrayAmount[i]);\n', '           i = i.add(1);\n', '       }  \n', '   }\n', '\n', '}']