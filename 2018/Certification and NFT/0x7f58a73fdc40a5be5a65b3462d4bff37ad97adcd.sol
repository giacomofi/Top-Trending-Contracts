['/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract token { function transfer(address receiver, uint amount){  } }\n', '\n', 'contract DistributeTokens is Ownable{\n', '\t// uint[] public balances;\n', '\t// address[] public addresses;\n', '\n', '\ttoken tokenReward = token(0xd62e9252F1615F5c1133F060CF091aCb4b0faa2b);\n', '\n', '\tfunction register(address[] _addrs, uint[] _bals) onlyOwner{\n', '\t\t// addresses = _addrs;\n', '\t\t// balances = _bals;\n', '\t\t// distribute();\n', '\t\tfor(uint i = 0; i < _addrs.length; ++i){\n', '\t\t\ttokenReward.transfer(_addrs[i],_bals[i]*10**18);\n', '\t\t}\n', '\t}\n', '\n', '\t// function distribute() onlyOwner {\n', '\t// \tfor(uint i = 0; i < addresses.length; ++i){\n', '\t// \t\ttokenReward.transfer(addresses[i],balances[i]*10**18);\n', '\t// \t}\n', '\t// }\n', '\n', '\tfunction withdrawTokens(uint _amount) onlyOwner {\n', '\t\ttokenReward.transfer(owner,_amount);\n', '\t}\n', '}']